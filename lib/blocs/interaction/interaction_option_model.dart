import 'package:equatable/equatable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InteractionOptionModel extends Equatable {
  final String code;
  final String caption;
  final FaIcon icon;

  InteractionOptionModel(this.code, this.caption, this.icon);

  @override
  List<Object> get props => [code, caption, icon];
  
}
