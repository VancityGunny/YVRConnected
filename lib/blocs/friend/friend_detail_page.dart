import 'package:collection/collection.dart';
import 'package:customgauge/customgauge.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yvrfriends/blocs/friend/index.dart';
import 'package:yvrfriends/blocs/interaction/interaction_model.dart';
import 'package:yvrfriends/common/common_bloc.dart';
import 'package:yvrfriends/common/commonfunctions.dart';
import 'package:yvrfriends/common/global_object.dart' as globals;
import 'package:yvrfriends/generated/l10n.dart';

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
  double interactionGaugeValue = 0;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  CommonBloc pageCommonBloc;
  var interactionStream;
  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
    pageCommonBloc = CommonBloc.of(context);
    interactionStream = pageCommonBloc.allSentInteractions.stream;
    var thoughtOptions = pageCommonBloc.thoughtOptions;
    var allFriendThoughts = pageCommonBloc.allSentThoughts.value.where(
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

    if (widget.currentFriend.lastThoughtSentDate == null ||
        widget.currentFriend.lastThoughtSentDate
                .add(new Duration(hours: 2))
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
                            child: Hero(
                                tag: widget.currentFriend.friendUserId,
                                child: (widget.currentFriend.thumbnail == null)
                                    ? Image.asset(
                                        'graphics/default_user_thumbnail.png',
                                        width: 200)
                                    : Image.network(
                                        widget.currentFriend.thumbnail,
                                        width: 200))),
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
                    child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        child: StreamBuilder(
                            stream: interactionStream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              // Calculate gauge value
                              // get interaction from last 14 days
                              var allFriendInteractions = snapshot.data.where(
                                  (element) =>
                                      element.toUserId ==
                                          widget.currentFriend.friendUserId &&
                                      DateTime.now()
                                              .difference(element.createdDate)
                                              .inDays <=
                                          14);
                              interactionGaugeValue = allFriendInteractions
                                  .fold(0.0, (previousValue, currentItem) {
                                switch (currentItem.interactionOptionCode) {
                                  case 'CALL':
                                    return previousValue + 1;
                                  case 'VIDEO':
                                    return previousValue + 2;
                                  case 'IRL':
                                    return previousValue + 4;
                                }
                                return previousValue + 1;
                              });
                              return CustomGauge(
                                maxValue: 10,
                                minValue: 0,
                                gaugeSize: 100,
                                segments: [
                                  GaugeSegment('Low', 2, Colors.red),
                                  GaugeSegment('Medium', 2, Colors.orange),
                                  GaugeSegment('High', 6, Colors.green),
                                ],
                                currentValue: interactionGaugeValue,
                                displayWidget: Text(delegate.friendshipLabel,
                                    style: TextStyle(fontSize: 8)),
                              );
                            })))
              ],
            ),
            StreamBuilder(
                stream: interactionStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // check isrecent for each button, if sent within 1 day
                  var recentInteractions = snapshot.data.where((interaction) =>
                      interaction.toUserId ==
                          widget.currentFriend.friendUserId &&
                      DateTime.now()
                              .difference(interaction.createdDate)
                              .inHours <
                          24);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: pageCommonBloc.interactionOptions.map((intOpt) {
                      var isRecentInteraction = false;
                      var lastSentInteractionTime;
                      var lastSentInteraction = recentInteractions
                          .toList()
                          .firstWhere(
                              (f) => f.interactionOptionCode == intOpt.code,
                              orElse: () => null);

                      if (lastSentInteraction != null) {
                        isRecentInteraction = true;
                        lastSentInteractionTime =
                            CommonFunctions.formatPostDateForDisplay(
                                lastSentInteraction.createdDate, context);
                      }

                      return Container(
                          child: (isRecentInteraction)
                              ? Wrap(
                                  children: <Widget>[
                                    Wrap(
                                      spacing: 10.0,
                                      children: <Widget>[
                                        Icon(intOpt.icon.icon,
                                            color: Colors.green, size: 18.0),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              'daily contact',
                                              style: TextStyle(fontSize: 10.0),
                                            ),
                                            Text(
                                              lastSentInteractionTime,
                                              style: TextStyle(fontSize: 10.0),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )
                              : RaisedButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    sendInteraction(intOpt.code);
                                  },
                                  child: Icon(intOpt.icon.icon,
                                      color: Colors.black),
                                ));
                    }).toList(),
                  );
                }),
            Expanded(
              child: Column(
                children: <Widget>[
                  (isRecent == true)
                      ? Text(delegate.currentStatusLabel +
                          ': ' +
                          pageCommonBloc.thoughtOptions
                              .firstWhere((element) =>
                                  element.code ==
                                  widget.currentFriend.lastThoughtSentOption)
                              .description)
                      : Container(
                          child: RaisedButton(
                              color: Colors.white,
                              child: Text(delegate.sendThoughtButton),
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
                            thoughtSentData(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.white,
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
                                  child: Text(delegate.yesButton),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(delegate.noButton),
                                ),
                              ],
                            );
                          },
                          barrierDismissible: false);
                    },
                    child: Text(delegate.deleteFriendButton),
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
    pageCommonBloc.friendProvider
        .removeFriend(widget.currentFriend.friendUserId, context);
  }

  LineChartData thoughtSentData() {
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
    await pageCommonBloc.thoughtRepository.addInteraction(
        new InteractionModel(globals.currentUserId,
            widget.currentFriend.friendUserId, code, DateTime.now(), null),
        context);
  }
}
