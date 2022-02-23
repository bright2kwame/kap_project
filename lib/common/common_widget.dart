import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/model/module_event.dart';
import 'package:knowledge_access_power/model/study_module.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class CommonWidget {
//MARK: event module item view
  Widget moduleEvent(BuildContext buildContext, ModuleEvent moduleEvent) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(2.0),
            child: Card(
                elevation: 0.5,
                child: ListTile(
                  title: Text(moduleEvent.title),
                  subtitle: Text(
                    moduleEvent.message,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: ClipRRect(
                    child: Image(
                      image: CachedNetworkImageProvider(moduleEvent.image),
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                ))));
  }

//MARK: study module item view
  Widget studyModuleItemView(
      BuildContext buildContext, StudyModule studyModule) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.0),
        child: Card(
            elevation: 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: CachedNetworkImageProvider(studyModule.coverImage),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    studyModule.title,
                    style: AppTextStyle.normalTextStyle(Colors.black, 14),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Text(
                    studyModule.summary,
                    maxLines: 3,
                    style: AppTextStyle.normalTextStyle(Colors.grey, 12),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Row(
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
                        " ${studyModule.noOfStages} Module(s)",
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
                          "${studyModule.noOfParticipants} Participant(s)",
                          style: AppTextStyle.normalTextStyle(
                              AppColor.primaryDarkColor, 12),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                )
              ],
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(2),
            )),
      ),
    );
  }
}
