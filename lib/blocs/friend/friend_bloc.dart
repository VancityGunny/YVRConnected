import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yvrconnected/blocs/friend/index.dart';

import 'package:yvrconnected/common/global_object.dart' as globals;

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  @override
  FriendState get initialState => UninitFriendState();

  @override
  Stream<FriendState> mapEventToState(
    FriendEvent event,
  ) async* {
    try {
      yield* await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'FriendBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }

  Stream<DocumentSnapshot> getFriendsStream() {
    return Firestore.instance
        .collection('/users')
        .document(globals.currentUserId)
        .snapshots();
  }
}
