enum PaymentType {
  jazzCash,
  easyPaisa,
  cod,
  meezanBank,
}

PaymentType? stringToPaymentType(String paymentType) {
  switch (paymentType) {
    case 'JazzCash':
      return PaymentType.jazzCash;
    case 'EasyPaisa':
      return PaymentType.easyPaisa;
    case 'cod':
      return PaymentType.cod;
    case 'Meezan Bank':
      return PaymentType.meezanBank;
    default:
      return null;
  }
}

String paymentTypeToString(PaymentType paymentType) {
  switch (paymentType) {
    case PaymentType.jazzCash:
      return 'JazzCash';
    case PaymentType.easyPaisa:
      return 'EasyPaisa';
    case PaymentType.cod:
      return 'cod';
    case PaymentType.meezanBank:
      return 'Meezan Bank';
    default:
      return '';
  }
}