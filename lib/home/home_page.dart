import 'package:flutter/material.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/common/common_widget.dart';
import 'package:knowledge_access_power/model/module_event.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_enum.dart';
import 'package:knowledge_access_power/util/progress_indicator_bar.dart';

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
          onTap: () {},
          child: eventModule.actionType == HomeFeedType.QUIZ.name
              ? CommonWidget().moduleEvent(
                  context,
                  eventModule,
                )
              : CommonWidget().eventFeedView(
                  context,
                  eventModule,
                ),
        );
      },
    );
  }
}
