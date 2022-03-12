import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/common/common_widget.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/module_options.dart';
import 'package:knowledge_access_power/model/module_question.dart';
import 'package:knowledge_access_power/model/module_stage.dart';
import 'package:knowledge_access_power/model/study_module.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/popup/app_alert_dialog.dart';
import 'package:knowledge_access_power/resources/string_resource.dart';
import 'package:knowledge_access_power/sub_module/all_module_steps_page.dart';
import 'package:knowledge_access_power/util/app_bar_widget.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class ModuleQuestionPage extends StatefulWidget {
  const ModuleQuestionPage({
    Key? key,
    required this.moduleQuestions,
  }) : super(key: key);
  final List<ModuleQuestion> moduleQuestions;

  @override
  State<ModuleQuestionPage> createState() => _ModuleQuestionPageState();
}

class _ModuleQuestionPageState extends State<ModuleQuestionPage> {
  late ModuleQuestion _currentQuestion = ModuleQuestion(options: []);
  int _currentPosition = 0;
  String _selectedOptionId = "";

  @override
  void initState() {
    setState(() {
      _currentQuestion = widget.moduleQuestions[_currentPosition];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: AppBarWidget.primaryAppBar("Module Questions"),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: SafeArea(
                child: ProgressHUD(
                    child: Builder(
              builder: (context) => _buildMainContent(context),
            )))));
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      width: MediaQuery.of(context).size.width,
      color: AppColor.bgColor,
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //question numbers view
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (_currentPosition + 1).toString(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.semiBoldTextStyle(Colors.black, 16),
                  ),
                  Text(
                    " out of ",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.normalTextStyle(Colors.black, 10),
                  ),
                  Text(
                    widget.moduleQuestions.length.toString(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.semiBoldTextStyle(Colors.black, 16),
                  ),
                ],
              ),
              //question view
              _currentQuestion.id.isNotEmpty
                  ? _studyQuestionView(context)
                  : Container(),
              //question options view
              _currentQuestion.options.isNotEmpty
                  ? _studyQuestionOptionView(context)
                  : Container(),
              //action view
              widget.moduleQuestions.isNotEmpty
                  ? _nextQuestionButton(context)
                  : Container()
            ]),
      ),
    );
  }

  void _submitAnswers(BuildContext context) {
    Navigator.pop(context, widget.moduleQuestions);
  }

  Widget _nextQuestionButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      width: MediaQuery.of(context).size.width,
      child: TextButton(
          onPressed: () {
            _handleNextOrSubmitAction();
          },
          style: AppButtonStyle.squaredColoredEdgeButton,
          child: Text(widget.moduleQuestions.length == (_currentPosition + 1)
              ? "SUBMIT"
              : "NEXT QUESTION")),
    );
  }

  void _handleNextOrSubmitAction() {
    var activeQuestion = widget.moduleQuestions[_currentPosition];
    if (activeQuestion.selectedOption.isEmpty) {
      return;
    }
    if (widget.moduleQuestions.length == (_currentPosition + 1)) {
      //submit for marking
      _submitAnswers(context);
    } else {
      //move to next
      setState(() {
        _currentPosition++;
        _currentQuestion = widget.moduleQuestions[_currentPosition];
      });
    }
    //MARK: reset the current option
    _selectedOptionId = "";
  }

  //MARK: study question view
  Widget _studyQuestionView(BuildContext buildContext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          _currentQuestion.questionImage.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image(
                    image: CachedNetworkImageProvider(
                        _currentQuestion.questionImage),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              _currentQuestion.questionText,
              textAlign: TextAlign.center,
              style: AppTextStyle.semiBoldTextStyle(Colors.black, 20),
            ),
          )
        ],
      ),
    );
  }

//MARK: study question view
  Widget _studyQuestionOptionView(BuildContext buildContext) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List<Widget>.generate(_currentQuestion.options.length, (index) {
        ModuleOptions moduleOption = _currentQuestion.options[index];
        return SizedBox(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: GestureDetector(
              onTap: () {
                widget.moduleQuestions[_currentPosition].selectedOption =
                    moduleOption.id;
                setState(() {
                  _selectedOptionId = moduleOption.id;
                });
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: AppColor.secondaryColor,
                        width: _selectedOptionId == moduleOption.id ? 5 : 0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: AppColor.primaryColor,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        moduleOption.image.isNotEmpty
                            ? Image(
                                image: CachedNetworkImageProvider(
                                    moduleOption.image),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              )
                            : Container(),
                        Text(
                          moduleOption.label,
                          style:
                              AppTextStyle.semiBoldTextStyle(Colors.white, 16),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        );
      }),
    );
  }
}
