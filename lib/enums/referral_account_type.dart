enum ReferralAccountType{
  USER,
  Retailer,
}

stringToReferralAccountType(String type){
  switch(type){
    case "USER":
      return ReferralAccountType.USER;
    case "Retailer":
      return ReferralAccountType.Retailer;
    default:
      return null;
  }
}

referralAccountTypeToString(ReferralAccountType type){
  switch(type){
    case ReferralAccountType.USER:
      return "USER";
    case ReferralAccountType.Retailer:
      return "Retailer";
    default:
      return "";
  }
}