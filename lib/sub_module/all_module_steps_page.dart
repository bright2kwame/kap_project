import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/module_stage.dart';
import 'package:knowledge_access_power/model/study_module.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/popup/app_alert_dialog.dart';
import 'package:knowledge_access_power/popup/bottom_sheet_page.dart';
import 'package:knowledge_access_power/resources/string_resource.dart';
import 'package:knowledge_access_power/sub_module/module_detail.dart';
import 'package:knowledge_access_power/util/app_bar_widget.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:knowledge_access_power/util/progress_indicator_bar.dart';

class AllModuleStepsPage extends StatefulWidget {
  const AllModuleStepsPage({
    Key? key,
    required this.studyModule,
  }) : super(key: key);
  final StudyModule studyModule;
  @override
  State<AllModuleStepsPage> createState() => _AllModuleStepsPageState();
}

class _AllModuleStepsPageState extends State<AllModuleStepsPage> {
  bool _loadingData = false;
  bool _subscribed = false;
  final List<ModuleStage> _moduleStages = [];
  final _nextPageThreshold = 5;
  final List<String> _loadedPages = [];
  String _nextUrl = "";
  UserItem _user = UserItem();

  @override
  void initState() {
    DBOperations().getUser().then((value) {
      setState(() {
        _user = value;
      });
      _getModuleStatus(ApiUrl().checkModuleStatus());
      _getModuleSteps(ApiUrl().moduleSteps(), true);
    });

    super.initState();
  }

  void _getModuleSteps(String url, bool isRefresh) {
    setState(() {
      _loadingData = true;
    });
    _loadedPages.add(url);
    Map<String, String> postData = {};
    postData.putIfAbsent("module_id", () => widget.studyModule.id);

    ApiService.get(_user.token).postData(url, postData).then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        var results = value["results"];
        _nextUrl = ParseApiData().getJsonData(value, "next");
        if (isRefresh) {
          _moduleStages.clear();
        }
        results.forEach((item) {
          item.putIfAbsent("module_id", () => widget.studyModule.id);
          var dataCleaned = ParseApiData().parseModuleStage(item);
          _moduleStages.add(dataCleaned);
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

  void _subscribeModule() {
    setState(() {
      _loadingData = true;
    });
    String url = ApiUrl().subscribeToModule();
    Map<String, String> postData = {};
    postData.putIfAbsent("module_id", () => widget.studyModule.id);

    ApiService.get(_user.token).postData(url, postData).then((value) {
      var statusCode = value["response_code"].toString();
      _subscribed = statusCode == "100";
      setState(() {});
    }).whenComplete(() {
      setState(() {
        _loadingData = false;
      });
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  void _getModuleStatus(String url) {
    setState(() {
      _loadingData = true;
    });
    Map<String, String> postData = {};
    postData.putIfAbsent("module_id", () => widget.studyModule.id);

    ApiService.get(_user.token)
        .postData(url, postData)
        .then((value) {
          var statusCode = value["response_code"].toString();
          print(url + " : " + statusCode);

          setState(() {
            _subscribed = statusCode == "100";
          });
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(url + " : " + error.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.studyModule.coverImage),
                fit: BoxFit.cover)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBarWidget.transparentAppBar("Sub Modules"),
            body: Container(
                color: Colors.white,
                child: SafeArea(
                    child: ProgressHUD(
                        child: Builder(
                  builder: (context) => _buildMainContent(context),
                ))))));
  }

  Widget _buildMainContent(BuildContext buildContext) {
    return Container(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.studyModule.title,
                  style: AppTextStyle.normalTextStyle(Colors.black, 16)),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.studyModule.summary,
                style: AppTextStyle.normalTextStyle(Colors.black, 12),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 0, right: 0, bottom: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 16,
                      child: Icon(
                        Icons.list_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                    Text(
                      " ${widget.studyModule.noOfStages} Module(s)",
                      style: AppTextStyle.normalTextStyle(
                          AppColor.primaryDarkColor, 12),
                    ),
                    Text(
                      " • ",
                      style: AppTextStyle.semiBoldTextStyle(Colors.grey, 16),
                    ),
                    const SizedBox(
                      width: 25,
                      child: Icon(
                        Icons.people_alt_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${widget.studyModule.noOfParticipants} Participant(s)",
                        style: AppTextStyle.normalTextStyle(
                            AppColor.primaryDarkColor, 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Modules:",
                      style: AppTextStyle.normalTextStyle(Colors.black, 14)),
                  _subscribed
                      ? Text(
                          "SUBSCRIBED",
                          style: AppTextStyle.normalTextStyle(Colors.black, 12),
                        )
                      : TextButton(
                          style: AppButtonStyle.squaredSmallColoredEdgeButton,
                          onPressed: () {
                            _subscribeModule();
                          },
                          child: const Text("SUBSCRIBE"))
                ],
              ),
              _loadingData
                  ? ProgressIndicatorBar()
                  : Container(
                      height: 4,
                    ),
              const SizedBox(
                height: 8,
                child: Divider(
                  height: 1,
                ),
              ),
              _studyModuleView(buildContext)
            ]),
      ),
    );
  }

  //MARK: study module stages view
  Widget _studyModuleView(BuildContext buildContext) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _moduleStages.length,
      itemBuilder: (context, i) {
        if (i == _moduleStages.length - _nextPageThreshold &&
            !_loadedPages.contains(_nextUrl)) {}
        var studyModuleStage = _moduleStages[i];
        return GestureDetector(
          onTap: () {
            _handleStepClick(studyModuleStage);
          },
          child: _moduleStageItemView(
            context,
            studyModuleStage,
          ),
        );
      },
    );
  }

  void _handleStepClick(ModuleStage moduleStage) {
    if (!_subscribed) {
      AppAlertDialog().showAlertDialog(
          context,
          StringResource.successDialogTitle,
          "You are currently not subscribed to the this module. Subscribe first",
          () {
        _subscribeModule();
      });
      return;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ModuleDetailPage(
                  moduleStage: moduleStage,
                )))
        .then((value) => {});
  }

  Widget _moduleStageItemView(
      BuildContext buildContext, ModuleStage moduleStage) {
    return Container(
        margin: const EdgeInsets.only(top: 8),
        height: 100,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image(
                image: CachedNetworkImageProvider(moduleStage.image),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                height: 100,
                color: Colors.black.withAlpha(100),
              ),
            ),
            Positioned(
                bottom: 4,
                right: 16,
                left: 16,
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: moduleStage.contentVideo.isEmpty
                          ? const Icon(
                              CupertinoIcons.book_circle,
                              color: Colors.white,
                              size: 24,
                            )
                          : const Icon(
                              CupertinoIcons.play_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            moduleStage.title,
                            style:
                                AppTextStyle.normalTextStyle(Colors.white, 14),
                          )),
                    ),
                    Text(
                      " • ",
                      style: AppTextStyle.semiBoldTextStyle(Colors.white, 16),
                    ),
                    Text(
                      "${moduleStage.noOfParticipants} Participated",
                      style: AppTextStyle.normalTextStyle(Colors.white, 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: moduleStage.hasCompleted
                          ? const Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: Colors.green,
                              size: 24,
                            )
                          : const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                    )
                  ],
                ))
          ],
        ));
  }
}
