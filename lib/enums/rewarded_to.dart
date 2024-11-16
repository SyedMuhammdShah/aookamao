enum RewardedTo {
USER,
RETAILER,
}

RewardedTo? stringToRewardedTo(String type){
  switch(type){
    case "USER":
      return RewardedTo.USER;
    case "RETAILER":
      return RewardedTo.RETAILER;
    default:
      return null;
  }
}

String rewardedToToString(RewardedTo type){
  switch(type){
    case RewardedTo.USER:
      return "USER";
    case RewardedTo.RETAILER:
      return "RETAILER";
    default:
      return "";
  }
}
