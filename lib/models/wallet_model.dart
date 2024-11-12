class WalletModel {
  final String walletId;
  final double balance;

  WalletModel({
    required this.walletId,
    required this.balance,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map){
    return WalletModel(
      walletId: map['walletId'],
      balance: map['balance'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'walletId': walletId,
      'balance': balance,
    };
  }
}
