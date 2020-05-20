import 'package:equatable/equatable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThoughtOptionModel extends Equatable {
  final String code;
  final String caption;
  final FaIcon icon;

  ThoughtOptionModel(this.code, this.caption, this.icon);

  @override
  List<Object> get props => [code, caption, icon];
  
}
