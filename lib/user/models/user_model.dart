import 'package:aookamao/user/data/constants/app_assets.dart';

class UserModel {
  final String uid;
  final String user_name;
  final String email;
  final String address;
  final String role;

  UserModel({
    required this.uid,
    required this.user_name,
    required this.email,
    required this.address,
    required this.role,
  });
}


// UserModel dummyUser = UserModel(
//   uid: '1',
//   user_name: 'Jhone Arent',
//   email: '',
//   profilePic: AppAssets.kProfilePic,
//   location: 'Brooklyn',
// );
