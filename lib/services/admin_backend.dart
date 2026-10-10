import 'package:supabase_flutter/supabase_flutter.dart';

/// Runtime configuration is intentionally supplied at build/deploy time. Never
/// place a Supabase service-role key in this client app or public repository.
abstract final class AdminBackend {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;

  static Future<void> initialize() async {
    if (!isConfigured) return;
    await Supabase.initialize(url: url, publishableKey: publishableKey);
  }

  static SupabaseClient get client {
    if (!isConfigured) {
      throw StateError('Supabase is not configured for this build.');
    }
    return Supabase.instance.client;
  }

  /// A signed-in user becomes an administrator only when their protected
  /// profile record carries the `admin` role. The client never grants itself a
  /// role; database row-level security enforces the same check server-side.
  static Future<bool> signInAdmin({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    final user = response.user;
    if (user == null) return false;

    final profile = await client
        .from('profiles')
        .select('role, status')
        .eq('id', user.id)
        .maybeSingle();
    final role = profile?['role'];
    final status = profile?['status'];
    if (role == 'admin' && status == 'active') return true;

    await client.auth.signOut();
    return false;
  }

  static Future<void> signOut() async {
    if (isConfigured) await client.auth.signOut();
  }
}
