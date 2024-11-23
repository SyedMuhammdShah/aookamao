enum RewardedTo {
Customer,
RETAILER,
  REFFERAL_USER
}

RewardedTo? stringToRewardedTo(String type){
  switch(type){
    case "USER":
      return RewardedTo.Customer;
    case "RETAILER":
      return RewardedTo.RETAILER;
      case "REFFERAL_USER":
      return RewardedTo.REFFERAL_USER;
    default:
      return null;
  }
}

String rewardedToToString(RewardedTo type){
  switch(type){
    case RewardedTo.Customer:
      return "USER";
    case RewardedTo.RETAILER:
      return "RETAILER";
      case RewardedTo.REFFERAL_USER:
      return "REFFERAL_USER";
    default:
      return "";
  }
}
