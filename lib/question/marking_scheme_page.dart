import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledge_access_power/model/module_options.dart';
import 'package:knowledge_access_power/model/module_question.dart';
import 'package:knowledge_access_power/util/app_bar_widget.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class MarkingSchemePage extends StatefulWidget {
  const MarkingSchemePage({
    Key? key,
    required this.moduleQuestions,
  }) : super(key: key);
  final List<ModuleQuestion> moduleQuestions;

  @override
  State<MarkingSchemePage> createState() => _MarkingSchemePageState();
}

class _MarkingSchemePageState extends State<MarkingSchemePage> {
  late ModuleQuestion _currentQuestion = widget.moduleQuestions[0];
  int _currentPosition = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: AppBarWidget.primaryAppBar("Marking Scheme"),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: SafeArea(
              child: _buildMainContent(context),
            )));
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
                    " OUT OF ",
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

  void _handleDone() {
    Navigator.pop(context, widget.moduleQuestions);
  }

  Widget _nextQuestionButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
              child: Container(
                  color: AppColor.primaryColor,
                  child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        _handlePrevAction();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 16,
                      )))),
          TextButton(
              onPressed: () {
                _handleDone();
              },
              child: Text(
                "DONE",
                style: AppTextStyle.boldTextStyle(AppColor.primaryColor, 14),
              )),
          ClipOval(
            child: Container(
              color: AppColor.primaryColor,
              child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    _handleNextAction();
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  )),
            ),
          )
        ],
      ),
    );
  }

  void _handlePrevAction() {
    if (_currentPosition > 0) {
      //move to back
      setState(() {
        _currentPosition--;
        _currentQuestion = widget.moduleQuestions[_currentPosition];
      });
    }
  }

  void _handleNextAction() {
    if (_currentPosition < widget.moduleQuestions.length - 1) {
      //move to next
      setState(() {
        _currentPosition++;
        _currentQuestion = widget.moduleQuestions[_currentPosition];
      });
    }
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
        bool isSelectedAnswer =
            _currentQuestion.selectedOption == moduleOption.id;
        return SizedBox(
            child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: AppColor.secondaryColor,
                        width: moduleOption.isCorrect ? 5 : 0),
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
              Positioned(
                child: isSelectedAnswer
                    ? Text(
                        "YOUR ANSWER",
                        style: AppTextStyle.normalTextStyle(Colors.white, 8),
                      )
                    : Container(),
                left: 12,
                top: 12,
              )
            ],
          ),
        ));
      }),
    );
  }
}
