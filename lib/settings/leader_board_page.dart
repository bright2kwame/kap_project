import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/util/app_bar_widget.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
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
    setState(() {
      _loadingData = true;
    });
    _loadedPages.add(url);
    ApiService.get(_user.token).getData(url).then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        var results = value["results"];
        _nextUrl = ParseApiData().getJsonData(value, "next");
        if (isRefresh) {
          _users.clear();
        }
        results.forEach((item) {
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
        body: Container(
          color: AppColor.bgColor,
          child: SingleChildScrollView(
            child: Column(children: [
              _loadingData
                  ? ProgressIndicatorBar()
                  : Container(
                      height: 4,
                    ),
              _users.isNotEmpty ? _leaderView(context) : Container()
            ]),
          ),
        ));
  }

//MARK: study module view
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
        var item = _users[i];
        return _leaderItemView(
          context,
          item,
        );
      },
    );
  }

  //MARK: leader item
  Widget _leaderItemView(BuildContext buildContext, UserItem userItem) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListTile(
        title: Text(
          userItem.username,
          style: AppTextStyle.semiBoldTextStyle(AppColor.primaryColor, 14),
        ),
        subtitle: Text(
          "${userItem.points} Points",
          style: AppTextStyle.semiBoldTextStyle(Colors.black, 12),
        ),
        leading: ClipOval(
          child: userItem.avatar.isNotEmpty
              ? Image(
                  image: CachedNetworkImageProvider(userItem.avatar),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                )
              : Container(),
        ),
      ),
    );
  }
}
