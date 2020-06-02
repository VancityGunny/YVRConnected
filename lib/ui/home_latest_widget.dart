import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yvrconnected/blocs/friend/friend_stat_model.dart';
import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:yvrconnected/common/common_bloc.dart';

// Widget to show all latest thoughts received
class HomeLatestWidget extends StatefulWidget {
  @override
  HomeLatestWidgetState createState() {
    // TODO: implement createState
    return HomeLatestWidgetState();
  }
}

class HomeLatestWidgetState extends State<HomeLatestWidget> {
  List<FriendStatModel> topFiveFriends = List<FriendStatModel>();
  List<FlSpot> graphData = List<FlSpot>();
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
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
    var thoughtOptions = CommonBloc.of(context).thoughtOptions;

    return Column(
      children: <Widget>[
        Container(
            child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
              TextSpan(
                  text: 'Top Friends',
                  style: TextStyle(color: Colors.black, fontSize: 20))
            ]))),
        Expanded(
            child: Container(
                child: StreamBuilder(
          stream: CommonBloc.of(context).topFiveFriends.stream,
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
                  return Container(
                    width: 70.0,
                    child: Stack(children: <Widget>[
                      FlareActor(
                        "graphics/boybody.flr",
                        animation: 'idle',
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                          top: 0,
                          left: 12,
                          child: ClipOval(
                              child: Align(
                                  alignment: Alignment.center,
                                  widthFactor: 0.85,
                                  heightFactor: 1.0,
                                  child: (snapshot
                                              .data[index].friend.thumbnail ==
                                          null)
                                      ? Image.asset(
                                          'graphics/default_user_thumbnail.png',
                                          width: 50.0,
                                          height: 50.0,
                                        )
                                      : Image.network(
                                          snapshot.data[index].friend.thumbnail,
                                          width: 54.0,
                                          height: 50.0,
                                        )))),
                    ]),
                  );
                });
          },
        ))),
        AspectRatio(
            aspectRatio: 1.70,
            child: StreamBuilder(
                stream: CommonBloc.of(context).allSentThoughts.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var allFriendThoughts = snapshot.data;

                  var thoughtsByDay = groupBy(allFriendThoughts,
                      (t) => DateTime.now().difference(t.createdDate).inDays);
                  graphData = new List<FlSpot>();
                  for (int i = 0; i <= 14; i++) {
                    var value = thoughtsByDay.entries.firstWhere(
                        (element) => element.key == i,
                        orElse: () => null);
                    graphData.add(new FlSpot(i.toDouble(),
                        (value == null) ? 0.0 : value.value.length.toDouble()));
                    if (value != null) {
                      maxYAxis = (value.value.length > maxYAxis)
                          ? value.value.length + 3
                          : maxYAxis;
                    }
                  }
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 18.0, left: 12.0, top: 24, bottom: 12),
                      child: LineChart(
                        mainData(),
                      ),
                    ),
                  );
                })),
        Container(
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
                  stream: CommonBloc.of(context).allReceivedThoughts.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data.length == 0) {
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
                              children: <Widget>[
                                Container(
                                    child: Icon(Icons.email,
                                        size: 70,
                                        color: Color.fromARGB(15, 0, 0, 0))),
                                Positioned(
                                    child: CommonBloc.of(context)
                                        .thoughtOptions
                                        .firstWhere((element) =>
                                            element.code ==
                                            filteredSnapshot
                                                .elementAt(index)
                                                .thoughtOptionCode)
                                        .icon,
                                    left: 30,
                                    top: 30),
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
    var currentFriend = CommonBloc.of(context).allFriends.value.firstWhere(
        (element) => element.friendUserId == latestThought.fromUserId,
        orElse: () => null);
    // if sender is not currently friend
    if (currentFriend == null) {
      // lookup our sender collection
      currentFriend = CommonBloc.of(context).allSenders.value.firstWhere(
          (element) => element.friendUserId == latestThought.fromUserId,
          orElse: () => null);

      // if we haven't lookup this sender before then lookup now
      if (currentFriend == null) {
        var currentFriend = await CommonBloc.of(context)
            .friendProvider
            .lookupFriendById(latestThought.fromUserId);
        // now add him to allsenders list for next time
        CommonBloc.of(context)
            .friendProvider
            .addSender(latestThought.fromUserId, currentFriend, context);
      }
    }
    var selectedThoughtType = CommonBloc.of(context).thoughtOptions.firstWhere(
        (element) => latestThought.thoughtOptionCode == element.code,
        orElse: () => null);

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: new LayoutBuilder(builder: (context, constraint) {
                    return new Icon(selectedThoughtType.icon.icon, size: 100);
                  })),
                  Text(selectedThoughtType.caption, textScaleFactor: 2.0),
                  (latestThought.imageUrl != null)
                      ? Expanded(child: Image.network(latestThought.imageUrl))
                      : Text(''),
                  Container(
                    child: (currentFriend != null &&
                            currentFriend.thumbnail == null)
                        ? Image.asset('graphics/default_user_thumbnail.png',
                            width: 20, height: 20)
                        : Image.network(currentFriend.thumbnail,
                            width: 20, height: 20),
                  ),
                  Text(latestThought.createdDate.toString()),
                ],
              ));
        }).then((value) {
      // mark thoughts as read so we hide it
      CommonBloc.of(context).markThoughtAsRead(latestThought.thoughtId);
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
              fontSize: 16),
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
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'Sent';
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
      ],
    );
  }
}
