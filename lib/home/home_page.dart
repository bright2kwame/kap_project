import 'package:flutter/material.dart';
import 'package:knowledge_access_power/common/common_widget.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/module_event.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/util/app_bar_widget.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/progress_indicator_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loadingData = false;
  final List<ModuleEvent> _modules = [
    ModuleEvent(
        title: "You break a new record",
        message: "Hishest scored recored so far",
        image:
            "https://www.achievers.com/wp-content/uploads/2020/07/07-11-20-2.jpg"),
    ModuleEvent(
        title: "You break a new record",
        message: "Hishest scored recored so far",
        image:
            "https://www.achievers.com/wp-content/uploads/2020/07/07-11-20-2.jpg")
  ];
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
    });

    super.initState();
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
          _modules.isNotEmpty ? _moduleEventView(context) : Container()
        ]),
      ),
    );
  }

//MARK: event module view
  Widget _moduleEventView(BuildContext buildContext) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _modules.length,
      itemBuilder: (context, i) {
        if (i == _modules.length - _nextPageThreshold &&
            !_loadedPages.contains(_nextUrl)) {}
        var studyModule = _modules[i];
        return GestureDetector(
          onTap: () {},
          child: CommonWidget().moduleEvent(
            context,
            studyModule,
          ),
        );
      },
    );
  }
}
