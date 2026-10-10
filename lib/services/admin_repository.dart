import 'admin_backend.dart';

/// Thin data layer for the staff workspace. Row-level security is enforced by
/// Supabase; this client only reads and updates records the signed-in admin is
/// already permitted to access.
class AdminRepository {
  AdminRepository._();

  static final instance = AdminRepository._();

  Future<AdminDataSnapshot> load() async {
    final client = AdminBackend.client;
    final results = await Future.wait<dynamic>([
      client.from('profiles').select().order('created_at', ascending: false),
      client.from('routes').select().order('submitted_at', ascending: false),
      client
          .from('store_orders')
          .select()
          .order('created_at', ascending: false),
    ]);

    return AdminDataSnapshot(
      profiles: _rows(results[0]),
      routes: _rows(results[1]),
      orders: _rows(results[2]),
    );
  }

  Future<void> decideRoute({
    required String routeId,
    required String decision,
  }) async {
    final client = AdminBackend.client;
    final userId = _currentUserId;
    await client
        .from('routes')
        .update({
          'approval_status': decision,
          'reviewed_at': DateTime.now().toUtc().toIso8601String(),
          'reviewed_by': userId,
        })
        .eq('id', routeId);
    await _writeAudit(
      action: 'route_$decision',
      entityType: 'route',
      entityId: routeId,
    );
  }

  Future<void> setMemberStatus({
    required String memberId,
    required bool suspended,
  }) async {
    await AdminBackend.client
        .from('profiles')
        .update({'status': suspended ? 'suspended' : 'active'})
        .eq('id', memberId);
    await _writeAudit(
      action: suspended ? 'member_suspended' : 'member_restored',
      entityType: 'profile',
      entityId: memberId,
    );
  }

  Future<void> confirmOrderPayment(String orderId) async {
    await AdminBackend.client
        .from('store_orders')
        .update({'payment_status': 'confirmed'})
        .eq('id', orderId);
    await _writeAudit(
      action: 'payment_confirmed',
      entityType: 'store_order',
      entityId: orderId,
    );
  }

  String get _currentUserId {
    final user = AdminBackend.client.auth.currentUser;
    if (user == null) throw StateError('No admin user is signed in.');
    return user.id;
  }

  Future<void> _writeAudit({
    required String action,
    required String entityType,
    required String entityId,
  }) => AdminBackend.client.from('admin_audit_log').insert({
    'admin_id': _currentUserId,
    'action': action,
    'entity_type': entityType,
    'entity_id': entityId,
  });

  static List<Map<String, dynamic>> _rows(dynamic response) =>
      List<Map<String, dynamic>>.from(
        (response as List).map((row) => Map<String, dynamic>.from(row as Map)),
      );
}

class AdminDataSnapshot {
  const AdminDataSnapshot({
    required this.profiles,
    required this.routes,
    required this.orders,
  });

  final List<Map<String, dynamic>> profiles;
  final List<Map<String, dynamic>> routes;
  final List<Map<String, dynamic>> orders;
}
