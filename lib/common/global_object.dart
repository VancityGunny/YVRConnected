library my_prj.globals;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:yvrfriends/blocs/user/user_model.dart';

UserModel loggedInUser;
String currentUserId;
FirebaseStorage storage = FirebaseStorage.instance;
bool includeImageFlag;
