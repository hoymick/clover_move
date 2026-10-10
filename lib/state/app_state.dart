import 'package:flutter/foundation.dart';

import '../models/app_language.dart';
import '../models/leaf_category.dart';
import '../services/admin_backend.dart';
import '../services/admin_repository.dart';

/// The moderation state used by the in-app Admin Workspace. It is deliberately
/// held separately from the member-facing onboarding state so the UI can be
/// connected to a server repository later without changing its screens.
enum AdminApprovalStatus { pending, approved, rejected }

/// How a physical store order reaches the member. Store fulfilment is separate
/// from event payment, because an event reservation has no parcel to ship.
enum StoreFulfilment { delivery, pickup }

class AdminApproval {
  const AdminApproval({
    required this.id,
    required this.title,
    required this.host,
    required this.type,
    required this.meetingPoint,
    required this.schedule,
    required this.restrictionReason,
    required this.submittedAt,
    this.status = AdminApprovalStatus.pending,
  });

  final String id;
  final String title;
  final String host;
  final String type;
  final String meetingPoint;
  final String schedule;
  final String restrictionReason;
  final String submittedAt;
  final AdminApprovalStatus status;

  AdminApproval copyWith({AdminApprovalStatus? status}) => AdminApproval(
    id: id,
    title: title,
    host: host,
    type: type,
    meetingPoint: meetingPoint,
    schedule: schedule,
    restrictionReason: restrictionReason,
    submittedAt: submittedAt,
    status: status ?? this.status,
  );
}

class AdminMember {
  const AdminMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.joined,
    this.suspended = false,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String joined;
  final bool suspended;

  AdminMember copyWith({bool? suspended}) => AdminMember(
    id: id,
    name: name,
    email: email,
    role: role,
    joined: joined,
    suspended: suspended ?? this.suspended,
  );
}

class AdminPayment {
  const AdminPayment({
    required this.id,
    required this.title,
    required this.payer,
    required this.amount,
    required this.channel,
    required this.createdAt,
    this.confirmed = false,
  });

  final String id;
  final String title;
  final String payer;
  final int amount;
  final String channel;
  final String createdAt;
  final bool confirmed;

  AdminPayment copyWith({bool? confirmed}) => AdminPayment(
    id: id,
    title: title,
    payer: payer,
    amount: amount,
    channel: channel,
    createdAt: createdAt,
    confirmed: confirmed ?? this.confirmed,
  );
}

/// Session state for the onboarding choices. Browsing needs no account, so
/// nothing here requires a login — see screen 03.
class AppState extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;
  LeafCategory? _category;
  bool _termsAccepted = false;
  bool _adminPreviewActive = false;
  StoreFulfilment _storeFulfilment = StoreFulfilment.delivery;
  String _deliveryAddress = '14 Oakfield Avenue, Dublin 6';
  String _pickupPoint = 'Talbot Hotel · Dublin 1';
  String? _activeApprovalId;
  bool _adminLoading = false;
  String? _adminLoadError;
  List<AdminApproval> _approvals = [
    const AdminApproval(
      id: 'route-morning',
      title: 'Morning Route',
      host: 'Niamh L. · verified host · 38 routes',
      type: 'Walking route',
      meetingPoint: 'Talbot Hotel',
      schedule: '07:00 – 09:00',
      restrictionReason:
          'Women-only session requested by the venue members. It runs alongside a mixed class.',
      submittedAt: 'Today, 09:42',
    ),
    const AdminApproval(
      id: 'route-bray',
      title: 'Bray Cliff Walk',
      host: 'Declan F. · verified host · 12 routes',
      type: 'Walking route',
      meetingPoint: 'Bray Seafront',
      schedule: '10:00 – 12:00',
      restrictionReason:
          'Open to all adults. No access restrictions requested.',
      submittedAt: 'Today, 08:18',
    ),
    const AdminApproval(
      id: 'route-wicklow',
      title: 'Sunday Spin · Wicklow Gap',
      host: 'Cycling Club · verified partner',
      type: 'Cycling route',
      meetingPoint: 'Laragh Car Park',
      schedule: '09:00 – 13:30',
      restrictionReason:
          'Experienced cyclists only due to the route elevation.',
      submittedAt: 'Yesterday, 16:22',
    ),
  ];
  List<AdminMember> _members = [
    const AdminMember(
      id: 'member-andrea',
      name: 'Andrea Ní Bhriain',
      email: 'andrea@example.ie',
      role: 'Member',
      joined: '12 Sep 2026',
    ),
    const AdminMember(
      id: 'member-niamh',
      name: 'Niamh L.',
      email: 'niamh@talbothotel.ie',
      role: 'Host',
      joined: '08 Sep 2026',
    ),
    const AdminMember(
      id: 'member-cycling',
      name: 'Wicklow Cycling Club',
      email: 'hello@wicklowcycling.ie',
      role: 'Partner',
      joined: '31 Aug 2026',
    ),
  ];
  List<AdminPayment> _payments = [
    const AdminPayment(
      id: 'payment-1',
      title: 'Clover Move Autumn Walk',
      payer: 'Andrea Ní Bhriain',
      amount: 1200,
      channel: 'Clover Move checkout',
      createdAt: 'Today, 10:04',
    ),
    const AdminPayment(
      id: 'payment-2',
      title: 'Morning Route',
      payer: 'Paul O’Connor',
      amount: 800,
      channel: 'Host direct payment',
      createdAt: 'Today, 09:16',
    ),
  ];

  AppLanguage get language => _language;
  LeafCategory? get category => _category;
  bool get termsAccepted => _termsAccepted;
  bool get adminPreviewActive => _adminPreviewActive;
  bool get adminLoading => _adminLoading;
  String? get adminLoadError => _adminLoadError;
  bool get usesLiveAdminData =>
      AdminBackend.isConfigured && AdminBackend.client.auth.currentUser != null;
  StoreFulfilment get storeFulfilment => _storeFulfilment;
  String get deliveryAddress => _deliveryAddress;
  String get pickupPoint => _pickupPoint;
  int get storeDeliveryCost =>
      _storeFulfilment == StoreFulfilment.delivery ? 495 : 0;
  int get storeOrderTotal => 13700 - 1370 + storeDeliveryCost;
  List<AdminApproval> get approvals => List.unmodifiable(_approvals);
  List<AdminApproval> get pendingApprovals => List.unmodifiable(
    _approvals.where((item) => item.status == AdminApprovalStatus.pending),
  );
  List<AdminMember> get members => List.unmodifiable(_members);
  List<AdminPayment> get payments => List.unmodifiable(_payments);
  AdminApproval? get activeApproval {
    final id = _activeApprovalId;
    if (id == null) {
      return pendingApprovals.isEmpty ? null : pendingApprovals.first;
    }
    return _approvals.where((item) => item.id == id).firstOrNull;
  }

  /// The category to display with when the user has not chosen one yet.
  LeafCategory get activeCategory => _category ?? LeafCategory.green;

  void setLanguage(AppLanguage value) {
    if (_language == value) return;
    _language = value;
    notifyListeners();
  }

  void setCategory(LeafCategory value) {
    if (_category == value) return;
    _category = value;
    notifyListeners();
  }

  void acceptTerms() {
    if (_termsAccepted) return;
    _termsAccepted = true;
    notifyListeners();
  }

  void setStoreFulfilment(StoreFulfilment value) {
    if (_storeFulfilment == value) return;
    _storeFulfilment = value;
    notifyListeners();
  }

  void setDeliveryAddress(String value) {
    final address = value.trim();
    if (address.isEmpty || address == _deliveryAddress) return;
    _deliveryAddress = address;
    notifyListeners();
  }

  void setPickupPoint(String value) {
    if (value == _pickupPoint) return;
    _pickupPoint = value;
    notifyListeners();
  }

  /// Opens the workspace after the secure access screen has authenticated staff.
  void enterAdminPreview() {
    _adminPreviewActive = true;
    notifyListeners();
  }

  void leaveAdminPreview() {
    _adminPreviewActive = false;
    notifyListeners();
  }

  void selectApproval(String id) {
    _activeApprovalId = id;
    notifyListeners();
  }

  Future<void> loadAdminData() async {
    if (!usesLiveAdminData) return;
    _adminLoading = true;
    _adminLoadError = null;
    notifyListeners();
    try {
      final snapshot = await AdminRepository.instance.load();
      final profilesById = {
        for (final profile in snapshot.profiles)
          _string(profile, 'id'): profile,
      };
      _approvals = snapshot.routes.map((route) {
        final owner = profilesById[_string(route, 'owner_id')];
        final ownerName = owner == null
            ? 'Clover Move host'
            : _string(owner, 'full_name');
        final ownerRole = owner == null
            ? 'Host'
            : _titleCase(_string(owner, 'role'));
        return AdminApproval(
          id: _string(route, 'id'),
          title: _string(route, 'title'),
          host: '$ownerName · $ownerRole',
          type: _string(route, 'route_type'),
          meetingPoint: _string(route, 'meeting_point'),
          schedule: _string(route, 'schedule_text'),
          restrictionReason: _string(
            route,
            'restriction_reason',
            'No restriction declared.',
          ),
          submittedAt: _displayDate(_string(route, 'submitted_at')),
          status: _approvalStatus(_string(route, 'approval_status')),
        );
      }).toList();
      _members = snapshot.profiles.map((profile) {
        return AdminMember(
          id: _string(profile, 'id'),
          name: _string(profile, 'full_name'),
          email: _string(profile, 'email'),
          role: _titleCase(_string(profile, 'role')),
          joined: _displayDate(_string(profile, 'created_at')),
          suspended: _string(profile, 'status') == 'suspended',
        );
      }).toList();
      _payments = snapshot.orders.map((order) {
        final payer = profilesById[_string(order, 'customer_id')];
        final fulfilment = _titleCase(_string(order, 'fulfilment'));
        return AdminPayment(
          id: _string(order, 'id'),
          title: 'Store order · $fulfilment',
          payer: payer == null
              ? 'Clover Move member'
              : _string(payer, 'full_name'),
          amount: (order['amount_cents'] as num?)?.toInt() ?? 0,
          channel: 'Clover Move checkout',
          createdAt: _displayDate(_string(order, 'created_at')),
          confirmed: _string(order, 'payment_status') == 'confirmed',
        );
      }).toList();
    } catch (_) {
      _adminLoadError = 'Could not load the latest admin records.';
    } finally {
      _adminLoading = false;
      notifyListeners();
    }
  }

  Future<void> decideApproval(String id, AdminApprovalStatus status) async {
    final index = _approvals.indexWhere((item) => item.id == id);
    if (index == -1) return;
    _approvals[index] = _approvals[index].copyWith(status: status);
    _activeApprovalId = null;
    notifyListeners();
    if (!usesLiveAdminData) return;
    try {
      await AdminRepository.instance.decideRoute(
        routeId: id,
        decision: status.name,
      );
    } catch (_) {
      await loadAdminData();
      rethrow;
    }
  }

  Future<void> toggleMemberSuspension(String id) async {
    final index = _members.indexWhere((member) => member.id == id);
    if (index == -1) return;
    final member = _members[index];
    _members[index] = member.copyWith(suspended: !member.suspended);
    notifyListeners();
    if (!usesLiveAdminData) return;
    try {
      await AdminRepository.instance.setMemberStatus(
        memberId: id,
        suspended: !member.suspended,
      );
    } catch (_) {
      await loadAdminData();
      rethrow;
    }
  }

  Future<void> confirmPayment(String id) async {
    final index = _payments.indexWhere((payment) => payment.id == id);
    if (index == -1) return;
    _payments[index] = _payments[index].copyWith(confirmed: true);
    notifyListeners();
    if (!usesLiveAdminData) return;
    try {
      await AdminRepository.instance.confirmOrderPayment(id);
    } catch (_) {
      await loadAdminData();
      rethrow;
    }
  }

  static String _string(
    Map<String, dynamic> value,
    String key, [
    String fallback = '',
  ]) {
    final text = value[key]?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  static AdminApprovalStatus _approvalStatus(String value) => switch (value) {
    'approved' => AdminApprovalStatus.approved,
    'rejected' => AdminApprovalStatus.rejected,
    _ => AdminApprovalStatus.pending,
  };

  static String _titleCase(String value) => value.isEmpty
      ? 'Member'
      : '${value[0].toUpperCase()}${value.substring(1)}';

  static String _displayDate(String value) {
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) return value.isEmpty ? 'Recently' : value;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
