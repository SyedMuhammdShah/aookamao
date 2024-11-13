enum ReferredBy {
 Retailer, User
}

stringToReferredBy(String? value) {
  if (value == 'Retailer') {
    return ReferredBy.Retailer;
  } else if (value == 'User') {
    return ReferredBy.User;
  } else {
    return null;
  }
}

referredByToString(ReferredBy? referredBy) {
  if (referredBy == ReferredBy.Retailer) {
    return 'Retailer';
  } else if (referredBy == ReferredBy.User) {
    return 'User';
  } else {
    return null;
  }
}