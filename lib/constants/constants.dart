import '../enums/user_bank_type.dart';

class Constants {
  Constants._();

  static String get appName => "AAO KAMAO";

  //firebase project id
  static String get projectid => "aookamao-e3160";

  static String get androidchannelid => "aookamao_channel";
  static String get androidchanneltittle => "Aookamao App Notifications";
  static String get androidchanneldes =>
      "This channel is used for Aookamao App Notifications";

  //firebase send notification url
  static String get fcmSendNotificationUrl =>
      "https://fcm.googleapis.com/v1/projects/$projectid/messages:send";

  //fireStore collections
  static String get usersCollection => "user_details";
  static String get subscriptionsCollection => "subscription";
  static String get productsCollection => "products";
  static String get referralsCollection => "referrals";
  static String get transactionsCollection => "transactions";
  static String get walletCollection => "wallet";
  static String get ordersCollection => "orders";
  static String get rewardCollection => "rewards";
  static String get variousChargesCollection => "various_charges";
  static String get  subscriptionChargesDoc=> "subscription_doc";


  //reward amount
  static double get customerRewardAmount => 500;
  static double get retailerRewardAmount => 500;
  static double get referralUserRewardAmount => 500;

  //order cities
  static List<String> get orderCities => ["Karachi", "Lahore", "Hydrabad"];

  //user bank types
  static List<UserBankType> get userBankTypes => [
        UserBankType.EasyPaisa,
        UserBankType.SadaPay,
        UserBankType.Nayapay,
        UserBankType.JazzCash,
        UserBankType.MeezanBank,
        UserBankType.BankAlHabib,
        UserBankType.BankIslami,
        UserBankType.AlfalahBank,
        UserBankType.FaysalBank,
        UserBankType.HBL,
        UserBankType.MCB,
        UserBankType.UBL,
        UserBankType.AskariBank,
        UserBankType.BankAlfalah,
        UserBankType.BankIslamiPakistan,
        UserBankType.DubaiIslamicBank
      ];

  //WhatsApp Number for ScreenShots
  static String get whatsAppNumber => "03332906880";
}
