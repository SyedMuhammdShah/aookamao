enum PaymentType {
  creditCard,
  debitCard,
  cod,
  bankTransfer,
}

PaymentType? stringToPaymentType(String paymentType) {
  switch (paymentType) {
    case 'creditCard':
      return PaymentType.creditCard;
    case 'debitCard':
      return PaymentType.debitCard;
    case 'cod':
      return PaymentType.cod;
    case 'bankTransfer':
      return PaymentType.bankTransfer;
    default:
      return null;
  }
}

String paymentTypeToString(PaymentType paymentType) {
  switch (paymentType) {
    case PaymentType.creditCard:
      return 'creditCard';
    case PaymentType.debitCard:
      return 'debitCard';
    case PaymentType.cod:
      return 'cod';
    case PaymentType.bankTransfer:
      return 'bankTransfer';
    default:
      return '';
  }
}