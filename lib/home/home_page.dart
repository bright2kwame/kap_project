import 'package:flutter/material.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/common/common_widget.dart';
import 'package:knowledge_access_power/events/event_check_in_page.dart';
import 'package:knowledge_access_power/model/module_event.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/popup/app_alert_dialog.dart';
import 'package:knowledge_access_power/popup/bottom_sheet_page.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_enum.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:knowledge_access_power/util/app_util.dart';
import 'package:knowledge_access_power/util/progress_indicator_bar.dart';
import 'package:map_launcher/map_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserItem user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loadingData = false;
  final List<ModuleEvent> _moduleEvents = [];
  final _nextPageThreshold = 5;
  final List<String> _loadedPages = [];
  String _nextUrl = "";

  @override
  void initState() {
    _getFeed(ApiUrl().myFeed(), true);

    super.initState();
  }

  void _getFeed(String url, bool isRefresh) {
    _loadedPages.add(url);
    Map<String, String> data = {};
    ApiService.get(widget.user.token).postData(url, data).then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        _nextUrl = ParseApiData().getJsonData(value, "next");
        if (isRefresh) {
          _moduleEvents.clear();
        }
        value["results"].forEach((item) {
          var dataCleaned = ParseApiData().parseEvent(item);
          _moduleEvents.add(dataCleaned);
        });
        setState(() {});
      }
    }).whenComplete(() {
      setState(() {
        _loadingData = false;
      });
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.bgColor,
      child: SingleChildScrollView(
        child: Column(children: [
          _loadingData
              ? ProgressIndicatorBar()
              : Container(
                  height: 4,
                ),
          _moduleEvents.isNotEmpty ? _moduleEventView(context) : Container()
        ]),
      ),
    );
  }

//MARK: event module view
  Widget _moduleEventView(BuildContext buildContext) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _moduleEvents.length,
      itemBuilder: (context, i) {
        if (i == _moduleEvents.length - _nextPageThreshold &&
            !_loadedPages.contains(_nextUrl)) {
          _getFeed(_nextUrl, false);
        }
        var eventModule = _moduleEvents[i];
        return GestureDetector(
          onTap: () {
            if (eventModule.actionType == HomeFeedType.EVENT.name) {
              _showEventActions(eventModule);
            } else {
              AppUtil().shareToSocialMedia(
                  "Hey! CheckOut My New Score", eventModule.title);
            }
          },
          child: eventModule.actionType == HomeFeedType.QUIZ.name
              ? CommonWidget().moduleEvent(
                  context,
                  eventModule,
                )
              : CommonWidget().eventFeedView(context, eventModule, true),
        );
      },
    );
  }

  void _showEventActions(ModuleEvent moduleEvent) {
    BottomSheetPage().showEventAction(context, moduleEvent, (result) {
      if (result == FeedActionType.EVENT_SCAN.name) {
        _navgateToQrScreen(moduleEvent);
      } else if (result == FeedActionType.EVENT_DIRECTION.name) {
        _navgateToDirection(moduleEvent);
      }
    });
  }

  //MARK: start map  to get direction
  _navgateToDirection(ModuleEvent moduleEvent) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(double.parse(moduleEvent.latitude),
          double.parse(moduleEvent.longitude)),
      title: moduleEvent.title,
      description: moduleEvent.title,
    );
  }

//MARK: start qr code scanner
  void _navgateToQrScreen(ModuleEvent moduleEvent) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const EventCheckInPage()))
        .then((value) {
      if (value != null) {
        _eventCheckIn(value, moduleEvent);
      }
    });
  }

//MARK: check  user in
  void _eventCheckIn(String qrCode, ModuleEvent moduleEvent) {
    setState(() {
      _loadingData = true;
    });
    Map<String, String> data = {};
    data.putIfAbsent("qr_string", () => qrCode);
    data.putIfAbsent("latitude", () => "1.224234");
    data.putIfAbsent("longitude", () => "3.039503");
    String title = "KAP Event CheckIn";
    ApiService.get(widget.user.token)
        .postData(ApiUrl().eventCheckIn(), data)
        .then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        var message = value["message"].toString();
        AppAlertDialog().showAlertDialog(context, title, message, () {});
      } else {
        var message = value["detail"].toString();
        AppAlertDialog().showAlertDialog(context, title, message, () {});
      }
    }).whenComplete(() {
      setState(() {
        _loadingData = false;
      });
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
