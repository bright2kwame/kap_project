import 'package:flutter/material.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/common/common_widget.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/util/app_bar_widget.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/progress_indicator_bar.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  final List<UserItem> _users = [];
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
      _getBoard(ApiUrl().leaderBoard(), true);
    });
    super.initState();
  }

  void _getBoard(String url, bool isRefresh) {
    _loadedPages.add(url);
    ApiService.get(_user.token).getData(url).then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        _nextUrl = ParseApiData().getJsonData(value, "next");
        if (isRefresh) {
          _users.clear();
        }
        value["results"].forEach((item) {
          var dataCleaned = ParseApiData().parseUser(item);
          _users.add(dataCleaned);
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
      appBar: AppBarWidget.primaryAppBar("Leader Board"),
      body: SingleChildScrollView(
        child: Column(children: [
          _loadingData
              ? ProgressIndicatorBar()
              : Container(
                  height: 4,
                ),
          _users.isNotEmpty ? _leaderView(context) : Container()
        ]),
      ),
    );
  }

//MARK: leader view
  Widget _leaderView(BuildContext buildContext) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _users.length,
      itemBuilder: (context, i) {
        if (i == _users.length - _nextPageThreshold &&
            !_loadedPages.contains(_nextUrl)) {
          _getBoard(_nextUrl, false);
        }
        return CommonWidget().leaderBoardItemView(buildContext, _users[i]);
      },
    );
  }
}
