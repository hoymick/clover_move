create or replace function private.prevent_admin_self_lockout()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  if old.role = 'admin' and old.id = (select auth.uid()) then
    if tg_op = 'DELETE' then
      raise exception 'You cannot delete your own administrator account.' using errcode = '42501';
    end if;
    if new.status <> 'active' or new.role <> 'admin' then
      raise exception 'You cannot suspend or remove your own administrator access.' using errcode = '42501';
    end if;
  end if;
  if tg_op = 'DELETE' then return old; end if;
  return new;
end;
$$;
revoke all on function private.prevent_admin_self_lockout() from public, anon, authenticated;
create trigger prevent_admin_self_lockout
before update or delete on public.profiles
for each row execute function private.prevent_admin_self_lockout();
