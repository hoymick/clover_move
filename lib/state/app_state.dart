import 'package:flutter/foundation.dart';

import '../models/app_language.dart';
import '../models/leaf_category.dart';

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
  final List<AdminApproval> _approvals = [
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
  final List<AdminMember> _members = [
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
  final List<AdminPayment> _payments = [
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

  /// Opens the local admin workspace. This is a development-only access gate;
  /// production credentials must be checked by a backend identity provider.
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

  void decideApproval(String id, AdminApprovalStatus status) {
    final index = _approvals.indexWhere((item) => item.id == id);
    if (index == -1) return;
    _approvals[index] = _approvals[index].copyWith(status: status);
    _activeApprovalId = null;
    notifyListeners();
  }

  void toggleMemberSuspension(String id) {
    final index = _members.indexWhere((member) => member.id == id);
    if (index == -1) return;
    final member = _members[index];
    _members[index] = member.copyWith(suspended: !member.suspended);
    notifyListeners();
  }

  void confirmPayment(String id) {
    final index = _payments.indexWhere((payment) => payment.id == id);
    if (index == -1) return;
    _payments[index] = _payments[index].copyWith(confirmed: true);
    notifyListeners();
  }
}
