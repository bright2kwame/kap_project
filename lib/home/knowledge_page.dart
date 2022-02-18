import 'package:flutter/material.dart';
import 'package:knowledge_access_power/model/study_module.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/progress_indicator_bar.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({
    Key? key,
  }) : super(key: key);

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  final List<StudyModule> _modules = [];
  final _nextPageThreshold = 5;
  final List<String> _loadedPages = [];
  final String _nextUrl = "";
  final bool _loadingData = false;

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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _modules.length,
            itemBuilder: (context, i) {
              if (i == _modules.length - _nextPageThreshold &&
                  !_loadedPages.contains(_nextUrl)) {}
              var item = _modules[i];
              return GestureDetector(
                onTap: () {},
                child: _studyModuleView(
                  context,
                  item,
                ),
              );
            },
          )
        ]),
      ),
    );
  }

  Widget _studyModuleView(BuildContext buildContext, StudyModule studyModule) {
    return Container();
  }
}
