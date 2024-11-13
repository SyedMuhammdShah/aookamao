enum ReferralAccountType{
  USER,
  RETAILER,
}

stringToReferralAccountType(String type){
  switch(type){
    case "USER":
      return ReferralAccountType.USER;
    case "RETAILER":
      return ReferralAccountType.RETAILER;
    default:
      return null;
  }
}

referralAccountTypeToString(ReferralAccountType type){
  switch(type){
    case ReferralAccountType.USER:
      return "USER";
    case ReferralAccountType.RETAILER:
      return "RETAILER";
    default:
      return "";
  }
}