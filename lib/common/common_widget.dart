import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/model/module_event.dart';
import 'package:knowledge_access_power/model/study_module.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:knowledge_access_power/model/module_reproductive_kit.dart';

class CommonWidget {
  //MARK: reproductive kit module item view
  Widget moduleReproductiveKit(BuildContext buildContext,
      ReproductiveKitModule reproductiveKitModule, Function() callback) {
    return Container(
        color: Colors.white,
        width: 250,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(2.0),
            child: Card(
                elevation: 0.5,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.0),
                              child: Image(
                                image: CachedNetworkImageProvider(
                                    reproductiveKitModule.image),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(reproductiveKitModule.title, maxLines: 2),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.shop,
                              size: 12,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(reproductiveKitModule.shopName,
                                maxLines: 1),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8.0),
                              child: Text(
                                "${reproductiveKitModule.currency} ${reproductiveKitModule.amount}",
                                maxLines: 1,
                                style: AppTextStyle.normalTextStyle(
                                    AppColor.primaryColor, 16),
                              )),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              callback();
                            },
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8.0),
                                child: Text(
                                  "Buy",
                                  style: AppTextStyle.normalTextStyle(
                                      AppColor.primaryColor, 16),
                                )),
                          )
                        ],
                      )
                    ]))));
  }

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
                  title: Text(
                    moduleEvent.title,
                    maxLines: 1,
                    style:
                        AppTextStyle.normalTextStyle(AppColor.primaryColor, 16),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                        ),
                        child: Text(
                          moduleEvent.message,
                          maxLines: 3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          moduleEvent.dateCreated,
                          maxLines: 1,
                          style: AppTextStyle.normalTextStyle(Colors.grey, 10),
                        ),
                      )
                    ],
                  ),
                  trailing: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                  leading: SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      child: moduleEvent.image.isEmpty
                          ? const Icon(
                              Icons.abc,
                              size: 80,
                            )
                          : Image(
                              image:
                                  CachedNetworkImageProvider(moduleEvent.image),
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
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
                studyModule.coverImage.isEmpty
                    ? Container()
                    : Image(
                        image:
                            CachedNetworkImageProvider(studyModule.coverImage),
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

  Widget leaderBoardItemView(BuildContext buildContext, UserItem userItem) {
    return Container(
      color: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.0),
        child: Card(
            elevation: 0.5,
            child: ListTile(
              leading: ClipOval(
                child: Container(
                  child: Center(
                    child: Text(
                      userItem.username.isNotEmpty
                          ? userItem.username.characters
                              .toUpperCase()
                              .characterAt(0)
                              .toString()
                          : "KAP",
                      style: AppTextStyle.boldTextStyle(Colors.white, 16),
                    ),
                  ),
                  width: 50,
                  height: 50,
                  color: AppColor.primaryColor,
                ),
              ),
              title: Text(
                userItem.username.isNotEmpty ? userItem.username : "KAP",
                style:
                    AppTextStyle.semiBoldTextStyle(AppColor.primaryColor, 14),
              ),
              subtitle: Text(
                "${userItem.points.toString()} Points",
                style: AppTextStyle.semiBoldTextStyle(Colors.black, 14),
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(2),
            )),
      ),
    );
  }

  Widget eventFeedView(
      BuildContext buildContext, ModuleEvent moduleEvent, bool hasMore) {
    return Container(
      color: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.0),
        child: Card(
            elevation: 0.5,
            child: SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image(
                        image: CachedNetworkImageProvider(moduleEvent.image),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        height: 180,
                        color: Colors.black.withAlpha(100),
                      ),
                    ),
                    Positioned(
                        bottom: 4,
                        right: 8,
                        left: 8,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    moduleEvent.title,
                                    style: AppTextStyle.normalTextStyle(
                                        Colors.white, 14),
                                  )),
                            ),
                            Text(
                              moduleEvent.startDate,
                              style: AppTextStyle.normalTextStyle(
                                  Colors.white, 10),
                            ),
                            Text(
                              " • ",
                              style: AppTextStyle.semiBoldTextStyle(
                                  Colors.white, 16),
                            ),
                            Text(
                              moduleEvent.endDate,
                              style: AppTextStyle.normalTextStyle(
                                  Colors.white, 10),
                            ),
                            hasMore
                                ? const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  )
                                : Container()
                          ],
                        ))
                  ],
                )),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(2),
            )),
      ),
    );
  }
}
