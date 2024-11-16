class Constants{
  Constants._();

  //firebase project id
  static String get projectid => "aookamao-e3160";

    static String get androidchannelid => "aookamao_channel";
    static String get androidchanneltittle => "Aookamao App Notifications";
    static String get androidchanneldes => "This channel is used for Aookamao App Notifications";

    //firebase send notification url
    static String get fcmSendNotificationUrl => "https://fcm.googleapis.com/v1/projects/$projectid/messages:send";


    //fireStore collections
    static String get usersCollection => "user_details";
    static String get subscriptionsCollection => "subscription";
    static String get productsCollection => "products";
    static String get referralsCollection => "referrals";
    static String get transactionsCollection => "transactions";
    static String get walletCollection => "wallet";
    static String get ordersCollection => "orders";

    //reward amount
    static int get customerRewardAmount => 500;
    static int get retailerRewardAmount => 500;


}