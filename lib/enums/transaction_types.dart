enum TransactionType {
  ReferralReward,
  Order,
  Subscription,
  Withdrawal
}

String transactionTypesToString(TransactionType transactionTypes) {
  switch (transactionTypes) {
    case TransactionType.ReferralReward:
      return 'Referral Reward';
    case TransactionType.Order:
      return 'Order';
    case TransactionType.Subscription:
      return 'Subscription';
    case TransactionType.Withdrawal:
      return 'Withdrawal';
    default:
      return '';
  }
}

TransactionType? transactionTypesFromString(String transactionTypes) {
  switch (transactionTypes) {
    case 'Referral Reward':
      return TransactionType.ReferralReward;
    case 'Order':
      return TransactionType.Order;
    case 'Subscription':
      return TransactionType.Subscription;
    case 'Withdrawal':
      return TransactionType.Withdrawal;
    default:
      return null;
  }
}