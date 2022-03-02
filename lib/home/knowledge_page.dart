import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/common/common_widget.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/module_category.dart';
import 'package:knowledge_access_power/model/study_module.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/resources/image_resource.dart';
import 'package:knowledge_access_power/sub_module/all_module_steps_page.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:knowledge_access_power/util/progress_indicator_bar.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserItem user;

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  final List<StudyModule> _modules = [];
  final List<ModuleCategory> _moduleCategories = [];
  final _nextPageThreshold = 5;
  final List<String> _loadedPages = [];
  String _nextUrl = "";
  bool _loadingData = true;
  String _currentCategory = "";

  @override
  void initState() {
    _getModuleCategories(ApiUrl().filterModuleCategory());
    _getModules(ApiUrl().filterModules(), true);

    super.initState();
  }

  void _getModuleCategories(String url) {
    _loadedPages.add(url);
    Map<String, String> postData = {};
    ApiService.get(widget.user.token)
        .postData(url, postData)
        .then((value) {
          var statusCode = value["response_code"].toString();
          if (statusCode == "100") {
            var results = value["results"];
            _moduleCategories.add(ModuleCategory(id: "", title: "ALL"));
            results.forEach((item) {
              var dataCleaned = ParseApiData().parseModuleCategory(item);
              _moduleCategories.add(dataCleaned);
            });
            setState(() {});
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

  void _getModules(String url, bool isRefresh) {
    setState(() {
      _loadingData = true;
    });
    _loadedPages.add(url);
    Map<String, String> postData = {};
    postData.putIfAbsent("search_text", () => "");
    postData.putIfAbsent("category", () => _currentCategory);
    ApiService.get(widget.user.token).postData(url, postData).then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        var results = value["results"];
        _nextUrl = ParseApiData().getJsonData(value, "next");
        if (isRefresh) {
          _modules.clear();
        }
        results.forEach((item) {
          var dataCleaned = ParseApiData().parseModule(item);
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
    return Container(
      color: AppColor.bgColor,
      child: SingleChildScrollView(
        child: Column(children: [
          _moduleCategories.isNotEmpty
              ? _studyModuleCategories(context)
              : Container(),
          _loadingData
              ? ProgressIndicatorBar()
              : Container(
                  height: 4,
                ),
          _modules.isNotEmpty ? _studyModuleView(context) : Container()
        ]),
      ),
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

//MARK: filter module view
  Widget _studyModuleCategories(BuildContext buildContext) {
    return Container(
      color: AppColor.primaryColor,
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _moduleCategories.length,
        itemBuilder: (context, i) {
          var item = _moduleCategories[i];
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentCategory = item.id;
                _loadingData = true;
              });
              _getModules(ApiUrl().filterModules(), true);
            },
            child: _filterItemView(
              context,
              item,
            ),
          );
        },
      ),
    );
  }

  //MARK: module filter item view
  Widget _filterItemView(
      BuildContext buildContext, ModuleCategory moduleCategory) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      child: Container(
        margin: const EdgeInsets.only(left: 8, bottom: 4, top: 4),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.primaryDarkColor,
            ),
            color: AppColor.primaryDarkColor,
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        child: Center(
          child: Text(
            moduleCategory.title,
            textAlign: TextAlign.center,
            style: AppTextStyle.normalTextStyle(Colors.white, 12.0),
          ),
        ),
      ),
    );
  }
}
