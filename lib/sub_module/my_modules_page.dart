import 'package:flutter/material.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/common/common_widget.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/study_module.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/sub_module/all_module_steps_page.dart';
import 'package:knowledge_access_power/util/app_bar_widget.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/progress_indicator_bar.dart';

class MyModulesPage extends StatefulWidget {
  const MyModulesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyModulesPage> createState() => _MyModulesPageState();
}

class _MyModulesPageState extends State<MyModulesPage> {
  final List<StudyModule> _modules = [];
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
      _getModules(ApiUrl().myModules(), true);
    });

    super.initState();
  }

  void _getModules(String url, bool isRefresh) {
    setState(() {
      _loadingData = true;
    });
    _loadedPages.add(url);
    Map<String, String> postData = {};
    postData.putIfAbsent("search_text", () => "");
    postData.putIfAbsent("category", () => "");

    ApiService.get(_user.token).postData(url, postData).then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        var results = value["results"];
        _nextUrl = ParseApiData().getJsonData(value, "next");
        if (isRefresh) {
          _modules.clear();
        }
        results.forEach((item) {
          var dataCleaned = ParseApiData().parseModule(item["module"]);
          _modules.add(dataCleaned);
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
      appBar: AppBarWidget.primaryAppBar("My Modules"),
      body: Container(
          color: AppColor.bgColor,
          child: SingleChildScrollView(
            child: Column(children: [
              _loadingData
                  ? ProgressIndicatorBar()
                  : Container(
                      height: 4,
                    ),
              _modules.isNotEmpty ? _studyModuleView(context) : Container()
            ]),
          )),
    );
  }

//MARK: study module view
  Widget _studyModuleView(BuildContext buildContext) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _modules.length,
      itemBuilder: (context, i) {
        if (i == _modules.length - _nextPageThreshold &&
            !_loadedPages.contains(_nextUrl)) {}
        var studyModule = _modules[i];
        return GestureDetector(
          onTap: () {
            _startDetailPage(studyModule);
          },
          child: CommonWidget().studyModuleItemView(
            context,
            studyModule,
          ),
        );
      },
    );
  }

  void _startDetailPage(StudyModule studyModule) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => AllModuleStepsPage(
                  studyModule: studyModule,
                )))
        .then((value) {});
  }
}
