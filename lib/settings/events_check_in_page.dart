import 'package:flutter/material.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/common/common_widget.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/module_event.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/util/app_bar_widget.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/progress_indicator_bar.dart';

class EventsCheckInPage extends StatefulWidget {
  const EventsCheckInPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EventsCheckInPage> createState() => _EventsCheckInPageState();
}

class _EventsCheckInPageState extends State<EventsCheckInPage> {
  final List<ModuleEvent> _events = [];
  final _nextPageThreshold = 5;
  final List<String> _loadedPages = [];
  String _nextUrl = "";
  bool _loadingData = true;
  UserItem _user = UserItem();

  @override
  void initState() {
    DBOperations().getUser().then((value) {
      setState(() {
        _user = value;
      });
      _getEvents(ApiUrl().myCheckIns(), true);
    });
    super.initState();
  }

  void _getEvents(String url, bool isRefresh) {
    _loadedPages.add(url);
    Map<String, String> postData = {};
    postData.putIfAbsent("search_text", () => "");
    ApiService.get(_user.token).postData(url, postData).then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        _nextUrl = ParseApiData().getJsonData(value, "next");
        if (isRefresh) {
          _events.clear();
        }
        value["results"].forEach((item) {
          var dataCleaned = ParseApiData().parseEvent(item);
          _events.add(dataCleaned);
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
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBarWidget.primaryAppBar("My Check Ins"),
      body: SingleChildScrollView(
        child: Column(children: [
          _loadingData
              ? ProgressIndicatorBar()
              : Container(
                  height: 4,
                ),
          _events.isNotEmpty
              ? _eventView(context)
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: Text("No checkins recorded"),
                  ),
                )
        ]),
      ),
    );
  }

//MARK: leader view
  Widget _eventView(BuildContext buildContext) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _events.length,
      itemBuilder: (context, i) {
        if (i == _events.length - _nextPageThreshold &&
            !_loadedPages.contains(_nextUrl)) {
          _getEvents(_nextUrl, false);
        }
        return CommonWidget().eventFeedView(buildContext, _events[i], false);
      },
    );
  }
}
