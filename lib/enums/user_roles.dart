enum UserRoles {
  admin,
  user,
  retailer,
}

String userRoleToString(UserRoles role) {
  switch (role) {
    case UserRoles.admin:
      return 'admin';
    case UserRoles.user:
      return 'user';
    case UserRoles.retailer:
      return 'retailer';
    default:
      return 'user';
  }
}

UserRoles stringToUserRole(String role) {
  switch (role) {
    case 'admin':
      return UserRoles.admin;
    case 'user':
      return UserRoles.user;
    case 'retailer':
      return UserRoles.retailer;
    default:
      return UserRoles.user;
  }
}
