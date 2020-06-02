import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/interaction/interaction_model.dart';
import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:yvrconnected/common/common_bloc.dart';
import 'package:yvrconnected/common/global_object.dart' as globals;

class FriendDetailPage extends StatefulWidget {
  static const String routeName = '/friendDetail';
  final FriendModel currentFriend;

  @override
  FriendDetailPage(this.currentFriend);

  @override
  FriendDetailPageState createState() => FriendDetailPageState();
}

class FriendDetailPageState extends State<FriendDetailPage> {
  var isRecent = true;
  List<List<FlSpot>> graphData = List<List<FlSpot>>();
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  Widget build(BuildContext context) {
    var thoughtOptions = CommonBloc.of(context).thoughtOptions;
    var allFriendThoughts = CommonBloc.of(context).allSentThoughts.value.where(
        (element) => element.toUserId == widget.currentFriend.friendUserId);

    var optionIndex = 0;
    thoughtOptions.forEach((option) {
      var thoughtsByDay = groupBy(
          allFriendThoughts
              .where((element) => element.thoughtOptionCode == option.code),
          (t) => DateTime.now().difference(t.createdDate).inDays);
      // modifier to stack the graph,
      var optionModifier = 2 * optionIndex;
      // create new graphdata first
      graphData.add(new List<FlSpot>());
      for (int i = 0; i <= 14; i++) {
        var value = thoughtsByDay.entries
            .firstWhere((element) => element.key == i, orElse: () => null);
        graphData[optionIndex].add(new FlSpot(i.toDouble(),
            (value == null) ? 0.0 + optionModifier : 1.0 + optionModifier));
      }
      optionIndex++;
    });

    BoxDecoration friendDecoration = BoxDecoration();
    if (widget.currentFriend.lastThoughtSentDate == null ||
        widget.currentFriend.lastThoughtSentDate
                .add(new Duration(hours: 24))
                .compareTo(DateTime.now()) <
            0) {
      isRecent = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.currentFriend.displayName),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(10.0),
                            child: (widget.currentFriend.thumbnail == null)
                                ? Image.asset(
                                    'graphics/default_user_thumbnail.png',
                                    width: 200)
                                : Image.network(widget.currentFriend.thumbnail,
                                    width: 200)),
                        // RichText(
                        //     overflow: TextOverflow.ellipsis,
                        //     text: TextSpan(
                        //         style: TextStyle(
                        //             color: Colors.black, fontSize: 16),
                        //         children: [
                        //           TextSpan(
                        //               text: widget.currentFriend.displayName)
                        //         ])),
                      ],
                    )),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Last heard:'),
                      Text('          3 days ago'),
                      Text('Last seen:'),
                      Text('          7 days ago'),
                      Text('Last meet:'),
                      Text('          21 days ago'),
                    ],
                  ),
                )
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    CommonBloc.of(context).interactionOptions.map((intOpt) {
                  return Container(
                      margin: EdgeInsets.all(10),
                      child: OutlineButton(
                        onPressed: () {
                          sendInteraction(intOpt.code);
                        },
                        child: intOpt.icon,
                      ));
                }).toList()
                // <Widget>[
                //   Container(
                //     margin: EdgeInsets.all(10),
                //     child: OutlineButton(
                //       onPressed: () {},
                //       child: FaIcon(FontAwesomeIcons.headphones),
                //     ),
                //   ),
                //   Container(
                //     margin: EdgeInsets.all(10),
                //     child: OutlineButton(
                //       onPressed: () {},
                //       child: FaIcon(FontAwesomeIcons.eye),
                //     ),
                //   ),
                //   Container(
                //     margin: EdgeInsets.all(10),
                //     child: OutlineButton(
                //       onPressed: () {},
                //       child: FaIcon(FontAwesomeIcons.userFriends),
                //     ),
                //   ),
                // ],
                ),
            Expanded(
              child: Column(
                children: <Widget>[
                  (isRecent == true)
                      ? Text('Current Status: ' +
                          CommonBloc.of(context)
                              .thoughtOptions
                              .firstWhere((element) =>
                                  element.code ==
                                  widget.currentFriend.lastThoughtSentOption)
                              .caption)
                      : Container(
                          child: RaisedButton(
                              child: Text('Thinking of You'),
                              onPressed: () {
                                openActionOptions(widget.currentFriend);
                              })),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.70,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 18.0, left: 12.0, top: 24, bottom: 12),
                          child: LineChart(
                            mainData(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      // confirm before sign out
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text(
                                  'Do you really want to delete this friend?'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    deleteFriend();
                                    Navigator.of(context)
                                        .pop(); // pop out of dialog
                                    Navigator.of(context)
                                        .pop(); // pop out of friend detail page
                                  },
                                  child: Text('Yes'),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No'),
                                ),
                              ],
                            );
                          },
                          barrierDismissible: false);
                    },
                    child: Text('DELETE FRIEND'),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void openActionOptions(FriendModel friend) async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: Text("Send Thought"),
              children: <Widget>[new FriendOptionsDialog(friend)]);
        });
    if (result != null) {
      Navigator.of(context)
          .pop(); // pop out of friend detail page, if we select something
    }
  }

  deleteFriend() {
    CommonBloc.of(context)
        .friendProvider
        .removeFriend(widget.currentFriend.friendUserId, context);
  }

  LineChartData mainData() {
    return LineChartData(
        lineTouchData: LineTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            textStyle: const TextStyle(
                color: Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 10),
            getTitles: (value) {
              switch (value.toInt()) {
                case 3:
                  return '3';
                case 6:
                  return '6';
                case 9:
                  return '9';
                case 12:
                  return 'days ago';
              }
              return '';
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            textStyle: const TextStyle(
              color: Color(0xff67727d),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return 'Miss';
                case 3:
                  return 'Wish';
                case 5:
                  return 'Oldtime';
                case 7:
                  return 'Grateful';
              }
              return '';
            },
            reservedSize: 28,
            margin: 12,
          ),
        ),
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1)),
        minX: 0,
        maxX: 14,
        minY: 0,
        maxY: 8,
        lineBarsData: graphData.map<LineChartBarData>((graphItem) {
          return LineChartBarData(
            spots: graphItem,
            isCurved: false,
            colors: gradientColors,
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          );
        }).toList());
  }

  void sendInteraction(String code) async {
    await CommonBloc.of(context).thoughtRepository.addInteraction(
        new InteractionModel(globals.currentUserId,
            widget.currentFriend.friendUserId, code, DateTime.now(), null),
        context);
  }
}
