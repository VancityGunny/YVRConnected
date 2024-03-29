import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yvrfriends/blocs/friend/friend_stat_model.dart';
import 'package:yvrfriends/blocs/friend/index.dart';
import 'package:yvrfriends/blocs/interaction/interaction_model.dart';
import 'package:yvrfriends/blocs/thought/index.dart';
import 'package:yvrfriends/common/common_bloc.dart';
import 'package:yvrfriends/common/commonfunctions.dart';
import 'package:yvrfriends/generated/l10n.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
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
                      text: delegate.activeFriendsTitle,
                      style: TextStyle(color: Colors.black, fontSize: 20))
                ]))),
        Container(
            height: 110,
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
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      var random = new Random();
                      var isBoy = true;
                      if (random.nextInt(2) == 1) {
                        isBoy = false;
                      }

                      return Container(
                        width: 80.0,
                        child: Column(
                          children: <Widget>[
                            Hero(
                                tag: snapshot.data[index].friend.friendUserId,
                                child: Container(
                                    //foregroundDecoration: friendDecoration,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          image: FadeInImage(
                                            width: 70.0,
                                            height: 70.0,
                                            placeholder: Image.asset(
                                                    'graphics/default_user_thumbnail.png')
                                                .image,
                                            image: (snapshot.data[index].friend
                                                        .thumbnail ==
                                                    null)
                                                ? Image.asset(
                                                        'graphics/default_user_thumbnail.png')
                                                    .image
                                                : Image.network(snapshot
                                                        .data[index]
                                                        .friend
                                                        .thumbnail)
                                                    .image,
                                          ).image,
                                          fit: BoxFit.cover),
                                    ),
                                    width: 70,
                                    height: 70)),
                            Container(
                              child: Flexible(
                                child: Align(
                                    child: Text(
                                        snapshot.data[index].friend.displayName,
                                        style: TextStyle(
                                            color: Colors.deepPurple)),
                                    alignment: Alignment.center),
                              ),
                            )
                          ],
                        ),
                      );
                    });
              },
            )),
        Container(
            padding: EdgeInsets.all(10),
            child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                  TextSpan(
                      text: delegate.needyFriendsTitle,
                      style: TextStyle(color: Colors.black, fontSize: 20))
                ]))),
        Container(
            height: 110,
            child: StreamBuilder(
              stream: pageCommonBloc.needAttentionFriends.stream,
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
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      var random = new Random();
                      var isBoy = true;
                      if (random.nextInt(2) == 1) {
                        isBoy = false;
                      }

                      return Container(
                        width: 80.0,
                        child: Column(
                          children: <Widget>[
                            Container(
                                foregroundDecoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                  backgroundBlendMode: BlendMode.saturation,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      image: FadeInImage(
                                        width: 70.0,
                                        height: 70.0,
                                        placeholder: Image.asset(
                                                'graphics/default_user_thumbnail.png')
                                            .image,
                                        image: (snapshot.data[index].friend
                                                    .thumbnail ==
                                                null)
                                            ? Image.asset(
                                                    'graphics/default_user_thumbnail.png')
                                                .image
                                            : Image.network(snapshot.data[index]
                                                    .friend.thumbnail)
                                                .image,
                                      ).image,
                                      fit: BoxFit.cover),
                                ),
                                width: 70,
                                height: 70),
                            Container(
                              child: Flexible(
                                child: Align(
                                    child: Text(
                                        snapshot.data[index].friend.displayName,
                                        style: TextStyle(
                                            color: Colors.deepPurple)),
                                    alignment: Alignment.center),
                              ),
                            )
                          ],
                        ),
                      );
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
              delegate.seeAllFriendsButton,
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
                    StreamProvider<List<InteractionModel>>.value(
                        value: pageCommonBloc.allSentInteractions.stream),
                    StreamProvider<List<ThoughtModel>>.value(
                        value: pageCommonBloc.allSentThoughts.stream),
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
                    text: delegate.incomingMessagesTitle,
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
                                CommonBloc.thoughtOptions
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
    var currentFriend = pageCommonBloc.allFriends.value.firstWhere(
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
        var currentFriend = await pageCommonBloc.friendProvider
            .lookupFriendById(latestThought.fromUserId);
        // now add him to allsenders list for next time
        pageCommonBloc.friendProvider
            .addSender(latestThought.fromUserId, currentFriend, context);
      }
    }
    var selectedThoughtType = CommonBloc.thoughtOptions.firstWhere(
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
                      child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.none,
                          child: new Icon(selectedThoughtType.icon.icon,
                              size: 70.0))),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(selectedThoughtType.description,
                          textScaleFactor: 2.0)),
                  (latestThought.imageUrl != null)
                      ? Expanded(child: Image.network(latestThought.imageUrl))
                      : Expanded(
                          child: Container(
                          height: 150.0,
                          child: Text(''),
                        )),
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
                            latestThought.createdDate, context),
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
    final delegate = S.of(context);
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
                return delegate.daysAgoSuffix;
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
                return delegate.contactLabel;
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
                return delegate.thoughtLabel;
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
