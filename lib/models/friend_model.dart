class FriendModel {
  String name;
  String email;

  FriendModel(this.name, this.email);

  factory FriendModel.fromJson(dynamic json) {
    return FriendModel(json['name'] as String, json['email'] as String);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.email} }';
  }
}