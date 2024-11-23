enum OrderStatus {
  pending,
  confirmed,
  delivered,
  cancelled,
}

String orderStatusToString(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'Pending';
    case OrderStatus.confirmed:
      return 'Confirmed';
    case OrderStatus.delivered:
      return 'Delivered';
    case OrderStatus.cancelled:
      return 'Cancelled';
    default:
      return '';
  }
}

OrderStatus? orderStatusFromString(String status) {
  switch (status) {
    case 'Pending':
      return OrderStatus.pending;
    case 'Confirmed':
      return OrderStatus.confirmed;
    case 'Delivered':
      return OrderStatus.delivered;
    case 'Cancelled':
      return OrderStatus.cancelled;
    default:
      return null;
  }
}