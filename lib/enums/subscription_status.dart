enum SubscriptionStatus {
  none,
  active,
  canceled,
  pending,
}

String subscriptionStatusToString(SubscriptionStatus status) {
  switch (status) {
    case SubscriptionStatus.none:
      return 'none';
    case SubscriptionStatus.active:
      return 'active';
    case SubscriptionStatus.canceled:
      return 'canceled';
    case SubscriptionStatus.pending:
      return 'pending';
    default:
      return 'none';
  }
}

SubscriptionStatus stringToSubscriptionStatus(String status) {
  switch (status) {
    case 'none':
      return SubscriptionStatus.none;
    case 'active':
      return SubscriptionStatus.active;
    case 'canceled':
      return SubscriptionStatus.canceled;
    case 'pending':
      return SubscriptionStatus.pending;
    default:
      return SubscriptionStatus.none;
  }
}