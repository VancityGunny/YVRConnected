import 'package:yvrconnected/blocs/security/index.dart';

class SecurityRepository {
  final SecurityProvider _securityProvider = SecurityProvider();

  SecurityRepository();

  void test(bool isError) {
    this._securityProvider.test(isError);
  }
}