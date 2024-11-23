class OrderSalesModel{
  String month;
  int orders;
  OrderSalesModel({required this.month,required this.orders});


  toMap(){
    return {
      'month': month,
      'orders': orders
    };
  }
}