
import 'package:yvrconnected/blocs/user/user_model.dart';
import 'package:yvrconnected/blocs/user/user_provider.dart';

class UserRepository {
  final UserProvider _userProvider = UserProvider();

  UserRepository();

  // Return new userId
  Future<String> AddUser(UserModel newUser){
    return this._userProvider.addUser(newUser);
  }
}