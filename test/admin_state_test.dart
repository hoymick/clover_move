import 'package:flutter_test/flutter_test.dart';

import 'package:clover_move/state/app_state.dart';

void main() {
  test('admin decisions update the queue and selected review item', () {
    final state = AppState();
    final first = state.pendingApprovals.first;

    state.selectApproval(first.id);
    expect(state.activeApproval?.id, first.id);

    state.decideApproval(first.id, AdminApprovalStatus.approved);
    expect(state.pendingApprovals, hasLength(2));
    expect(
      state.approvals.firstWhere((item) => item.id == first.id).status,
      AdminApprovalStatus.approved,
    );
  });

  test('admin account and payment actions update their records', () {
    final state = AppState();
    final member = state.members.first;
    final payment = state.payments.first;

    state.toggleMemberSuspension(member.id);
    state.confirmPayment(payment.id);

    expect(
      state.members.firstWhere((item) => item.id == member.id).suspended,
      isTrue,
    );
    expect(
      state.payments.firstWhere((item) => item.id == payment.id).confirmed,
      isTrue,
    );
  });
}
