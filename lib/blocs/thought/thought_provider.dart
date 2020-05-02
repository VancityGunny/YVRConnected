import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:yvrconnected/blocs/thought/thought_model.dart';

class ThoughtProvider {
  
  static final _firestore = Firestore.instance;
  
  Future<void> loadAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> saveAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  void test(bool isError) {
    if (isError == true){
      throw Exception('manual error');
    }
  }
  Future<List<String>> getThoughtOptions() async{
    
  }
  Future<bool> addThought(ThoughtModel newThought) async {
     final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'addThought',
    );
    // try {
    //   await _firestore.collection('/posts').add(newPost.toMap());
    //   return true;
    // } catch (e) {
    //   return e.toString();
    // }
    //TODO: to be implement
    return true;
  }
}

