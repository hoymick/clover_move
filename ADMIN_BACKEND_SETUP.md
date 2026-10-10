# Clover Move Admin Panel

The live staff sign-in is deployed at
`https://hoymick.github.io/clover_move/#/admin-dashboard`.

The production Supabase project, row-level security, staff audit trail, and
GitHub Pages deployment are already connected. The only remaining setup action
is choosing the first staff account.

## 1. Create the first admin account

In Supabase **Authentication**, create or invite the staff email address. The
database automatically creates that person's standard member profile. Copy the
user UUID, then run this SQL in the Supabase SQL Editor:

```sql
update public.profiles
set role = 'admin'
where id = 'AUTH_USER_UUID';
```

Only an active profile with role `admin` can pass the staff sign-in screen.
The Flutter app cannot grant itself this role.

## 2. Deployment configuration

In GitHub repository **Settings → Secrets and variables → Actions**, add:

- `SUPABASE_URL` — the project's HTTPS URL.
- `SUPABASE_PUBLISHABLE_KEY` — the project's publishable key.

Never add `SUPABASE_SERVICE_ROLE_KEY` to GitHub Pages, the Flutter project, or
the app. It can bypass row-level security and belongs only on a private server.

Both GitHub Actions secrets are already set. Push any commit to `main` to
rebuild GitHub Pages.

## Local staff build

```bash
flutter run --dart-define=SCREEN=admin-dashboard \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

The app verifies both an authenticated session and an active `admin` profile;
ordinary member, host, and partner accounts are refused at the gateway.
