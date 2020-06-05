import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yvrconnected/blocs/friend/friend_stat_model.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/interaction/interaction_model.dart';
import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:yvrconnected/common/common_bloc.dart';
import 'package:yvrconnected/common/commonfunctions.dart';

// Widget to show all latest thoughts received
class HomeLatestWidget extends StatefulWidget {
  @override
  HomeLatestWidgetState createState() {
    // TODO: implement createState
    return HomeLatestWidgetState();
  }
}

class HomeLatestWidgetState extends State<HomeLatestWidget> {
  CommonBloc pageCommonBloc;
  List<FriendStatModel> topFiveFriends = List<FriendStatModel>();
  List<FlSpot> graphData = List<FlSpot>();
  List<FlSpot> graphInteractionsData = new List<FlSpot>();
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<Color> alternateGradientColors = [
    const Color(0xffe62256),
    const Color(0xffd4028a),
  ];
  int maxYAxis = 5;

  final RelativeRectTween relativeRectTween = RelativeRectTween(
    begin: RelativeRect.fromLTRB(0, 10, 0, 0),
    end: RelativeRect.fromLTRB(0, 0, 0, 0),
  );

  Animation<RelativeRect> headBobingAnimation;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //load latest thoughts
    ThoughtProvider thoughtProvider = ThoughtProvider();

    thoughtProvider.fetchTopFive(context).then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        topFiveFriends = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // *** Calculate the graph data for thoughts and interaction statistic ***//
    pageCommonBloc = CommonBloc.of(context);
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(10),
            child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                  TextSpan(
                      text: 'Active Friends',
                      style: TextStyle(color: Colors.black, fontSize: 20))
                ]))),
        Container(
            height: 100,
            child: StreamBuilder(
              stream: pageCommonBloc.topFiveFriends.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.length == 0) {
                  return Container(
                      alignment: Alignment.center,
                      child: FaIcon(FontAwesomeIcons.userPlus,
                          size: 100, color: Color.fromARGB(15, 0, 0, 0)));
                }
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      var random = new Random();
                      var isBoy = true;
                      if (random.nextInt(2) == 1) {
                        isBoy = false;
                      }

                      return Container(
                          width: 70.0,
                          child: Stack(children: <Widget>[
                            FlareActor(
                              (isBoy)
                                  ? "graphics/boybody.flr"
                                  : "graphics/girlbody.flr",
                              animation: (isBoy) ? 'idleboy' : 'idlegirl',
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                            ),
                            Container(
                                alignment: Alignment.topCenter,
                                // top: 10,
                                // left: 12,
                                child: ClipOval(
                                    child: Align(
                                        alignment: Alignment.center,
                                        widthFactor: 0.85,
                                        heightFactor: 1.0,
                                        child: Hero(
                                            tag: snapshot.data[index].friend
                                                .friendUserId,
                                            child: FadeInImage(
                                                width: 50.0,
                                                height: 50.0,
                                                placeholder: Image.asset(
                                                  'graphics/default_user_thumbnail.png',
                                                  width: 50.0,
                                                  height: 50.0,
                                                ).image,
                                                image: (snapshot.data[index]
                                                            .friend.thumbnail ==
                                                        null)
                                                    ? Image.asset(
                                                        'graphics/default_user_thumbnail.png',
                                                        width: 50.0,
                                                        height: 50.0,
                                                      ).image
                                                    : Image.network(
                                                        snapshot.data[index]
                                                            .friend.thumbnail,
                                                        width: 50.0,
                                                        height: 50.0,
                                                      ).image)))))
                          ]));
                    });
              },
            )),
        Container(
          alignment: Alignment.bottomRight,
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return BlocProvider(
                      create: (BuildContext context) => FriendBloc(),
                      child: FriendPage());
                }),
              );
            },
            child: Text(
              'See All Friends',
              style: TextStyle(color: Colors.lightBlue),
            ),
          ),
        ),
        Container(
            height: 120.0,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 12, bottom: 12),
              child: MultiProvider(
                  providers: [
                    StreamProvider<List<InteractionModel>>.value(value: pageCommonBloc.allSentInteractions.stream),
                    StreamProvider<List<ThoughtModel>>.value(value: pageCommonBloc.allSentThoughts.stream),                   
                  ],
                  child: Builder(
                    builder: (BuildContext context) {
                      List<InteractionModel> allFriendInteractions =
                          Provider.of<List<InteractionModel>>(context);
                      List<ThoughtModel> allFriendThoughts =
                          Provider.of<List<ThoughtModel>>(context);

                      if (allFriendInteractions == null ||
                          allFriendInteractions == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      graphData = new List<FlSpot>();
                      graphInteractionsData = new List<FlSpot>();
                      if (allFriendThoughts != null) {
                        var thoughtsByDay = groupBy(
                            allFriendThoughts,
                            (t) => DateTime.now()
                                .difference(t.createdDate)
                                .inDays);

                        for (int i = 0; i <= 14; i++) {
                          var value = thoughtsByDay.entries.firstWhere(
                              (element) => element.key == i,
                              orElse: () => null);
                          graphData.add(new FlSpot(
                              i.toDouble(),
                              (value == null)
                                  ? 0.0
                                  : value.value.length.toDouble()));
                          if (value != null) {
                            maxYAxis = (value.value.length > maxYAxis)
                                ? value.value.length + 3
                                : maxYAxis;
                          }
                        }
                      }
                      var maxY = 0.0;
                      if (allFriendInteractions != null) {
                        var interactionsByDay = groupBy(
                            allFriendInteractions,
                            (t) => DateTime.now()
                                .difference(t.createdDate)
                                .inDays);

                        for (int i = 0; i <= 14; i++) {
                          var value = interactionsByDay.entries.firstWhere(
                              (element) => element.key == i,
                              orElse: () => null);
                          var newSpot = new FlSpot(
                              i.toDouble(),
                              (value == null)
                                  ? 0.0
                                  : value.value.length.toDouble());
                          graphInteractionsData.add(newSpot);
                          maxY = (newSpot.y > maxY) ? newSpot.y : maxY;
                        }
                        // cap max Y at 30 for this graph
                        var capY = maxYAxis;
                        if (maxY > capY) {
                          List<FlSpot> newAdjustedGraph = new List<FlSpot>();
                          var divideBy = maxY / capY;
                          graphInteractionsData.forEach((element) {
                            newAdjustedGraph.add(
                                new FlSpot(element.x, element.y / divideBy));
                          });
                          graphInteractionsData = newAdjustedGraph;
                        }
                      }
                      return LineChart(
                        mainData(),
                      );
                    },
                  )),
            )),
        Container(
            padding: EdgeInsets.all(10),
            child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                  TextSpan(
                    text: 'Latest Messages',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )
                ]))),
        Expanded(
          child: Container(
              child: StreamBuilder(
                  stream: pageCommonBloc.allReceivedThoughts.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data
                            .where((f) => f.readFlag == false)
                            .length ==
                        0) {
                      return Container(
                          alignment: Alignment.center,
                          child: FaIcon(FontAwesomeIcons.folderPlus,
                              size: 100, color: Color.fromARGB(15, 0, 0, 0)));
                    }
                    //filter out read message
                    var filteredSnapshot =
                        snapshot.data.where((e) => e.readFlag == false);
                    return GridView.builder(
                      itemCount: filteredSnapshot.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              viewThought(filteredSnapshot.elementAt(index));
                            },
                            onLongPress: () {
                              //TODO: open the message
                            }, // open action option, miss, remind, grateful
                            onLongPressUp: () {
                              //TODO: selectActionOption, // long press release so select whatever was selected
                            },
                            child: Card(
                                child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Icon(Icons.email,
                                    size: 60,
                                    color: Color.fromARGB(15, 0, 0, 0)),
                                pageCommonBloc
                                    .thoughtOptions
                                    .firstWhere((element) =>
                                        element.code ==
                                        filteredSnapshot
                                            .elementAt(index)
                                            .thoughtOptionCode)
                                    .icon,
                              ],
                            )));
                      },
                    );
                  })),
        ),
      ],
    );
  }

  void viewThought(ThoughtModel latestThought) async {
    var currentFriend =pageCommonBloc.allFriends.value.firstWhere(
        (element) => element.friendUserId == latestThought.fromUserId,
        orElse: () => null);
    // if sender is not currently friend
    if (currentFriend == null) {
      // lookup our sender collection
      currentFriend = pageCommonBloc.allSenders.value.firstWhere(
          (element) => element.friendUserId == latestThought.fromUserId,
          orElse: () => null);

      // if we haven't lookup this sender before then lookup now
      if (currentFriend == null) {
        var currentFriend = await pageCommonBloc
            .friendProvider
            .lookupFriendById(latestThought.fromUserId);
        // now add him to allsenders list for next time
        pageCommonBloc
            .friendProvider
            .addSender(latestThought.fromUserId, currentFriend, context);
      }
    }
    var selectedThoughtType = pageCommonBloc.thoughtOptions.firstWhere(
        (element) => latestThought.thoughtOptionCode == element.code,
        orElse: () => null);

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: new Icon(selectedThoughtType.icon.icon,
                              size: 100))),
                  Text(selectedThoughtType.caption, textScaleFactor: 2.0),
                  (latestThought.imageUrl != null)
                      ? Expanded(child: Image.network(latestThought.imageUrl))
                      : Text(''),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    alignment: Alignment.bottomRight,
                    child: (currentFriend != null &&
                            currentFriend.thumbnail == null)
                        ? Image.asset('graphics/default_user_thumbnail.png',
                            width: 20, height: 20)
                        : Image.network(currentFriend.thumbnail,
                            width: 20, height: 20),
                  ),
                  Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 5),
                      child: Text(
                        CommonFunctions.formatPostDateForDisplay(
                            latestThought.createdDate),
                        textAlign: TextAlign.right,
                      )),
                ],
              ));
        }).then((value) {
      // mark thoughts as read so we hide it
      pageCommonBloc.markThoughtAsRead(latestThought.thoughtId);
    });
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
              fontSize: 12),
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
        rightTitles: SideTitles(
           showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xffe62256),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'Contact';
            }
            return '';
          },
          reservedSize: 28,
          margin: 15,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff23b6e6),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'Thought';
            }
            return '';
          },
          reservedSize: 28,
          margin: 15,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 14,
      minY: 0,
      maxY: maxYAxis.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: graphData,
          isCurved: false,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
        LineChartBarData(
          spots: graphInteractionsData,
          isCurved: false,
          colors: alternateGradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
