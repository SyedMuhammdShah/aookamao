enum TransactionStatus {
  pending,
  approved,
  rejected
}

TransactionStatus? stringToTransactionStatus(String? status) {
  switch (status) {
    case 'pending':
      return TransactionStatus.pending;
    case 'approved':
      return TransactionStatus.approved;
    case 'rejected':
      return TransactionStatus.rejected;
    default:
      return null;
  }
}

transactionStatusToString(TransactionStatus? status) {
  switch (status) {
    case TransactionStatus.pending:
      return 'pending';
    case TransactionStatus.approved:
      return 'approved';
    case TransactionStatus.rejected:
      return 'rejected';
    default:
      return '';
  }
}