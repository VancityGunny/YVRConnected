import 'package:rxdart/rxdart.dart';
import 'package:yvrconnected/models/friend_model.dart';
import '../resources/repository.dart';

class ContactBloc {
  final _repository = Repository();
  final _friendsFetcher = PublishSubject<FriendModel>();

  Observable<FriendModel> get allFriends => _friendsFetcher.stream;

  fetchAllFriends() async {
    FriendModel friendModel = await _repository.fetchFriends();
    _friendsFetcher.sink.add(friendModel);
  }

  dispose() {
    _friendsFetcher.close();
  }
}

final bloc = ContactBloc();
