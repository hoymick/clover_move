-- Clover Move admin backend
-- Run this once in Supabase SQL Editor. The Flutter client uses only the
-- publishable anon key; never add a service-role key to the mobile or web app.

create extension if not exists pgcrypto with schema extensions;
create schema private;
revoke all on schema private from public;
grant usage on schema private to authenticated;

create type public.profile_role as enum ('member', 'host', 'partner', 'admin');
create type public.account_status as enum ('active', 'suspended');
create type public.approval_status as enum ('pending', 'approved', 'rejected');
create type public.fulfilment_type as enum ('delivery', 'pickup');

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  full_name text not null,
  role public.profile_role not null default 'member',
  status public.account_status not null default 'active',
  created_at timestamptz not null default now()
);

-- Every Auth user gets a regular member profile. Staff elevation happens only
-- through a server-side SQL action, never in the Flutter client.
create or replace function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name)
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data ->> 'full_name', split_part(coalesce(new.email, ''), '@', 1), 'Clover Move member')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create or replace function private.is_active_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin' and status = 'active'
  );
$$;

-- `security definer` is required to avoid a recursive profiles RLS lookup;
-- callers must still be signed in. The functions live outside the Data API.
revoke all on function private.handle_new_user() from public, anon, authenticated;
revoke all on function private.is_active_admin() from public, anon;
grant execute on function private.is_active_admin() to authenticated;

create table public.routes (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles (id),
  title text not null,
  route_type text not null,
  meeting_point text not null,
  schedule_text text not null,
  restriction_reason text not null default '',
  approval_status public.approval_status not null default 'pending',
  submitted_at timestamptz not null default now(),
  reviewed_at timestamptz,
  reviewed_by uuid references public.profiles (id)
);

create table public.meet_points (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text not null,
  county text not null,
  collection_enabled boolean not null default true,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.store_orders (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.profiles (id),
  fulfilment public.fulfilment_type not null,
  delivery_address text,
  meet_point_id uuid references public.meet_points (id),
  amount_cents integer not null check (amount_cents >= 0),
  payment_status text not null default 'pending',
  created_at timestamptz not null default now(),
  check (
    (fulfilment = 'delivery' and delivery_address is not null and meet_point_id is null)
    or
    (fulfilment = 'pickup' and meet_point_id is not null and delivery_address is null)
  )
);

create table public.admin_audit_log (
  id bigint generated always as identity primary key,
  admin_id uuid not null references public.profiles (id),
  action text not null,
  entity_type text not null,
  entity_id text not null,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index routes_owner_id_index on public.routes (owner_id);
create index routes_reviewed_by_index on public.routes (reviewed_by);
create index store_orders_customer_id_index on public.store_orders (customer_id);
create index store_orders_meet_point_id_index on public.store_orders (meet_point_id);
create index admin_audit_log_admin_id_index on public.admin_audit_log (admin_id);

alter table public.profiles enable row level security;
alter table public.routes enable row level security;
alter table public.meet_points enable row level security;
alter table public.store_orders enable row level security;
alter table public.admin_audit_log enable row level security;

create policy "members can view their profile" on public.profiles
  for select to authenticated using (id = (select auth.uid()) or private.is_active_admin());
create policy "admins manage profiles" on public.profiles
  for all to authenticated using (private.is_active_admin()) with check (private.is_active_admin());

create policy "owners view their routes" on public.routes
  for select to authenticated using (owner_id = (select auth.uid()) or private.is_active_admin());
create policy "owners create routes" on public.routes
  for insert to authenticated with check (owner_id = (select auth.uid()));
create policy "owners edit pending routes" on public.routes
  for update to authenticated using (owner_id = (select auth.uid()) and approval_status = 'pending')
  with check (owner_id = (select auth.uid()) and approval_status = 'pending');
create policy "admins moderate routes" on public.routes
  for update to authenticated using (private.is_active_admin()) with check (private.is_active_admin());

create policy "public can view active collection points" on public.meet_points
  for select to anon, authenticated using (active = true and collection_enabled = true);
create policy "admins manage meet points" on public.meet_points
  for all to authenticated using (private.is_active_admin()) with check (private.is_active_admin());

create policy "customers view their orders" on public.store_orders
  for select to authenticated using (customer_id = (select auth.uid()) or private.is_active_admin());
create policy "customers create their orders" on public.store_orders
  for insert to authenticated with check (customer_id = (select auth.uid()));
create policy "admins manage orders" on public.store_orders
  for all to authenticated using (private.is_active_admin()) with check (private.is_active_admin());

create policy "admins view audit history" on public.admin_audit_log
  for select to authenticated using (private.is_active_admin());
create policy "admins write audit history" on public.admin_audit_log
  for insert to authenticated with check (admin_id = (select auth.uid()) and private.is_active_admin());

-- Explicit Data API privileges. RLS remains the authorization layer; no table
-- becomes publicly writable merely because it is exposed to the API.
grant usage on schema public to anon, authenticated;
grant select on public.meet_points to anon;
grant select, insert, update on public.profiles to authenticated;
grant select, insert, update on public.routes to authenticated;
grant select, insert, update on public.store_orders to authenticated;
grant select, insert, update, delete on public.meet_points to authenticated;
grant select, insert on public.admin_audit_log to authenticated;

-- After inviting/creating the first staff account in Supabase Authentication,
-- insert its Auth user UUID below and change role to admin:
-- update public.profiles set role = 'admin'
-- where id = 'AUTH_USER_UUID';
