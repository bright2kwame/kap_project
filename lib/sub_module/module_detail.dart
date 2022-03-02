import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/module_question.dart';
import 'package:knowledge_access_power/model/module_stage.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/popup/app_alert_dialog.dart';
import 'package:knowledge_access_power/popup/bottom_sheet_page.dart';
import 'package:knowledge_access_power/question/marking_scheme_page.dart';
import 'package:knowledge_access_power/question/module_question_page.dart';
import 'package:knowledge_access_power/resources/string_resource.dart';
import 'package:knowledge_access_power/util/app_bar_widget.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_enum.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class ModuleDetailPage extends StatefulWidget {
  const ModuleDetailPage({
    Key? key,
    required this.moduleStage,
  }) : super(key: key);
  final ModuleStage moduleStage;
  @override
  State<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> {
  UserItem _user = UserItem();
  late BuildContext buildContext;

  @override
  void initState() {
    DBOperations().getUser().then((value) {
      setState(() {
        _user = value;
      });
      _startSubModule();
    });

    super.initState();
  }

  void _startSubModule() {
    final List<ModuleQuestion> _preQuestions = [];
    String url = ApiUrl().startSubModule();
    Map<String, String> postData = {};
    postData.putIfAbsent("module_id", () => widget.moduleStage.moduleId);
    postData.putIfAbsent("sub_module_id", () => widget.moduleStage.id);

    ApiService.get(_user.token)
        .postData(url, postData)
        .then((value) {
          var statusCode = value["response_code"].toString();
          var message = value["message"].toString();
          if (statusCode == "100") {
            var results = value["results"];
            if (results != null) {
              results.forEach((question) {
                _preQuestions.add(_parseQuestion(question));
              });
              AppAlertDialog().showAlertDialog(
                  context, StringResource.dialogTitle, message, () {
                _presentQuestions(
                    _preQuestions, QuestionType.PRE_SUB_MODULE, buildContext);
              });
            }
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

  void _markModule(List<ModuleQuestion> data, QuestionType questionType,
      BuildContext context) {
    final progress = ProgressHUD.of(context);
    progress?.show();
    Map<String, String> postData = {};
    postData.putIfAbsent("module_id", () => widget.moduleStage.moduleId);
    postData.putIfAbsent("sub_module_id", () => widget.moduleStage.id);
    postData.putIfAbsent("quiz_type", () => questionType.name.toString());
    List<String> answers = [];
    for (var element in data) {
      String answerData = "${element.id}:${element.selectedOption}";
      answers.add(answerData);
    }
    postData.putIfAbsent("questions_and_answers",
        () => answers.toString().replaceAll("[", "").replaceAll("]", ""));
    ApiService.get(_user.token)
        .postData(ApiUrl().submitQuiz(), postData)
        .then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        String score = value["results"]["score"].toString();
        var response = value["results"]["quiz_responses"];
        String message = value["message"].toString();
        _presentResult(score, message, response, data, questionType);
      } else {
        String message = value["detail"].toString();
        AppAlertDialog().showAlertDialog(
            context, StringResource.dialogTitle, message, () {});
      }
    }).whenComplete(() {
      progress?.dismiss();
    }).onError((error, stackTrace) {
      AppAlertDialog().showAlertDialog(
          context, StringResource.dialogTitle, error.toString(), () {});
    });
  }

  //MARK: show exam results
  void _presentResult(String score, String message, var data,
      List<ModuleQuestion> questions, QuestionType questionType) {
    BottomSheetPage().showModuleExamsResult(context, score, message, (action) {
      if (action == AnswerResponseType.MARKING_SCHEME.name) {
        _showMarkingResult(data);
      } else if (action == AnswerResponseType.RETRY.name) {
        _presentQuestions(questions, questionType, context);
      }
    });
  }

  void _showMarkingResult(var data) {
    List<ModuleQuestion> questions = [];
    data.forEach((question) {
      var questionParsed = ParseApiData().parseSchemeQuestion(question);
      questions.add(questionParsed);
    });

    Navigator.of(buildContext)
        .push(MaterialPageRoute(
            builder: (context) => MarkingSchemePage(
                  moduleQuestions: questions,
                )))
        .then((data) => {if (data != null) {}});
  }

//MARK: present the questions
  _presentQuestions(List<ModuleQuestion> questions, QuestionType questionType,
      BuildContext buildContext) {
    if (questions.isEmpty) {
      Navigator.pop(context);
      return;
    }

    Navigator.of(buildContext)
        .push(MaterialPageRoute(
            builder: (context) => ModuleQuestionPage(
                  moduleQuestions: questions,
                )))
        .then((data) => {
              if (data != null)
                {_markModule(data, questionType, this.buildContext)}
            });
  }

//MARK: mark question as complete
  void _markModuleAsComplete(BuildContext context) {
    final List<ModuleQuestion> _postQuestions = [];
    final progress = ProgressHUD.of(context);
    progress?.show();
    String url = ApiUrl().markModuleAsComplete();
    Map<String, String> postData = {};
    postData.putIfAbsent("module_id", () => widget.moduleStage.moduleId);
    postData.putIfAbsent("sub_module_id", () => widget.moduleStage.id);

    ApiService.get(_user.token).postData(url, postData).then((value) {
      var statusCode = value["response_code"].toString();
      var message = value["message"].toString();
      if (statusCode == "100") {
        var results = value["results"];
        if (results != null) {
          results.forEach((question) {
            _postQuestions.add(_parseQuestion(question));
          });
          AppAlertDialog().showAlertDialog(
              context, StringResource.dialogTitle, message, () {
            _presentQuestions(
                _postQuestions, QuestionType.POST_SUB_MODULE, context);
          });
        }
      }
    }).whenComplete(() {
      progress?.dismiss();
    }).onError((error, stackTrace) {
      print(error);
    });
  }

//MARK: parse the question
  ModuleQuestion _parseQuestion(var data) {
    return ParseApiData().parseModuleQuestion(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget.primaryAppBar("Module Detail"),
        body: Container(
            color: Colors.white,
            child: SafeArea(
                child: ProgressHUD(
                    child: Builder(
              builder: (context) => _buildMainContent(context),
            )))));
  }

  Widget _buildMainContent(BuildContext buildContext) {
    this.buildContext = buildContext;
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(widget.moduleStage.title,
                  style: AppTextStyle.normalTextStyle(Colors.black, 16)),
            ),
            const SizedBox(
              height: 8,
              child: Divider(
                height: 1,
              ),
            ),
            widget.moduleStage.image.isEmpty
                ? Container()
                : Image(
                    image: CachedNetworkImageProvider(widget.moduleStage.image),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(widget.moduleStage.content,
                  style: AppTextStyle.normalTextStyle(Colors.black, 14)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  _markModuleAsComplete(buildContext);
                },
                child: Text(
                  "Mark  As Completed",
                  style: AppTextStyle.normalTextStyle(Colors.white, 12),
                ),
                style: AppButtonStyle.squaredSmallColoredEdgeButton,
              ),
            ),
          ]),
    );
  }
}
