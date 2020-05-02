import 'package:yvrconnected/blocs/thought/index.dart';

class ThoughtRepository {
  final ThoughtProvider _thoughtProvider = ThoughtProvider();

  ThoughtRepository();

  void test(bool isError) {
    this._thoughtProvider.test(isError);
  }

  Future<bool> AddThought(ThoughtModel newThought) {
    return this._thoughtProvider.addThought(newThought);
  }
}
