# Clover Move Admin Backend Setup

The public preview is already live at
`https://hoymick.github.io/clover_move/#/admin-dashboard`.

To turn that preview into the real staff-only Admin Panel, set up the Supabase
project once. The app is already prepared for it.

## 1. Create the project

Create a Supabase project for Clover Move, then in **SQL Editor** run
[`supabase/schema.sql`](supabase/schema.sql). This creates secured profiles,
routes, Meet Points, store orders, and audit logging with row-level security.

## 2. Create the first admin account

In Supabase **Authentication**, invite the staff email address. Copy the new
user's UUID, then run the final commented `insert into public.profiles` example
at the bottom of `supabase/schema.sql`, replacing its placeholder UUID and
email. That `admin` role is required to sign in.

## 3. Configure the browser deployment

In GitHub repository **Settings → Secrets and variables → Actions**, add:

- `SUPABASE_URL` — the project's HTTPS URL.
- `SUPABASE_PUBLISHABLE_KEY` — the project's publishable key.

Never add `SUPABASE_SERVICE_ROLE_KEY` to GitHub Pages, the Flutter project, or
the app. It can bypass row-level security and belongs only on a private server.

Push any commit to `main` after adding the two values. GitHub Pages rebuilds
automatically, and the preview replaces its local-entry button with staff email
and password sign-in.

## Local staff-preview build

```bash
flutter run --dart-define=SCREEN=admin-dashboard \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

The app verifies both an authenticated session and an active `admin` profile;
ordinary member, host, and partner accounts are refused at the gateway.
