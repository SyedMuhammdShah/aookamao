enum RewardStatus {
  pending,
  approved,
  rejected,
}

RewardStatus? stringToRewardStatus(String status) {
  switch (status) {
    case 'pending':
      return RewardStatus.pending;
    case 'approved':
      return RewardStatus.approved;
    case 'rejected':
      return RewardStatus.rejected;
    default:
      return null;
  }
}

rewardStatusToString(RewardStatus status) {
  switch (status) {
    case RewardStatus.pending:
      return 'pending';
    case RewardStatus.approved:
      return 'approved';
    case RewardStatus.rejected:
      return 'rejected';
    default:
      return '';
  }
}