import 'package:flutter/material.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/common/common_widget.dart';
import 'package:knowledge_access_power/events/event_check_in_page.dart';
import 'package:knowledge_access_power/model/module_event.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/model/module_reproductive_kit.dart';
import 'package:knowledge_access_power/popup/app_alert_dialog.dart';
import 'package:knowledge_access_power/popup/bottom_sheet_page.dart';
import 'package:knowledge_access_power/products/all_products_page.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_enum.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:knowledge_access_power/util/app_util.dart';
import 'package:knowledge_access_power/util/progress_indicator_bar.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:knowledge_access_power/util/app_input_decorator.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';

import '../util/product_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserItem user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loadingData = false;
  final List<ModuleEvent> _moduleEvents = [];
  final _nextPageThreshold = 5;
  final List<String> _loadedPages = [];
  String _nextUrl = "";
  final List<ReproductiveKitModule> _moduleReproductiveKits = [];
  static final TextEditingController _quantityController =
      TextEditingController();
  static final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    _getFeed(ApiUrl().myFeed(), true);
    _getKitsFeed(ApiUrl().filterProducts(), true);
    super.initState();
  }

  //MARK: get kit data
  void _getKitsFeed(String url, bool isRefresh) {
    _loadedPages.add(url);
    Map<String, String> data = {};
    ApiService.get(widget.user.token)
        .postData(url, data)
        .then((value) {
          var statusCode = value["response_code"].toString();
          if (statusCode == "100") {
            _nextUrl = ParseApiData().getJsonData(value, "next");
            if (isRefresh) {
              _moduleReproductiveKits.clear();
            }
            value["results"].forEach((item) {
              var dataCleaned = ParseApiData().parseKit(item);
              _moduleReproductiveKits.add(dataCleaned);
            });
            setState(() {});
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

  void _getFeed(String url, bool isRefresh) {
    _loadedPages.add(url);
    Map<String, String> data = {};
    ApiService.get(widget.user.token).postData(url, data).then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        _nextUrl = ParseApiData().getJsonData(value, "next");
        if (isRefresh) {
          _moduleEvents.clear();
        }
        value["results"].forEach((item) {
          var dataCleaned = ParseApiData().parseEvent(item);
          _moduleEvents.add(dataCleaned);
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
          _loadingData
              ? ProgressIndicatorBar()
              : Container(
                  height: 4,
                ),
          SizedBox(
              child: Column(children: [
                Row(
                  children: [
                    const Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      child: Text("Available Products"),
                    )),
                    TextButton(
                        onPressed: () {
                          _navgateToProductsScreen();
                        },
                        child: Text("SEE ALL",
                            style: AppTextStyle.normalTextStyle(
                                Colors.grey, 12.0)))
                  ],
                ),
                SizedBox(
                  height: 170,
                  child: _moduleReproductiveProductive(context),
                )
              ]),
              height: 220),
          _moduleEvents.isNotEmpty ? _moduleEventView(context) : Container()
        ]),
      ),
    );
  }

  Widget _moduleReproductiveProductive(BuildContext buildContext) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _moduleReproductiveKits.length,
      itemBuilder: (context, i) {
        var eventKit = _moduleReproductiveKits[i];
        return CommonWidget().moduleReproductiveKit(buildContext, eventKit, () {
          BottomSheetPage().showBuyingAction(buildContext, eventKit,
              (callback) {
            if (callback == FeedActionType.BUY_KIT.name) {
              _showBuyingAction(buildContext, eventKit);
            } else if (callback == FeedActionType.KIT_SHOP_DIRECTION.name) {
              ProductUtil().navgateToDirection(
                  eventKit.shopName, eventKit.shopLat, eventKit.shopLon);
            }
          });
        });
      },
    );
  }

  //MARK: start withdrawal action
  _showBuyingAction(BuildContext buildContext, ReproductiveKitModule kit) {
    ProductUtil().showBuyingAction(context, kit, (salesOrder) {
      if (salesOrder != null) {
        setState(() {
          _loadingData = true;
        });
        ProductUtil().buyReproductiveKit(
            context,
            salesOrder.reproductiveKitModule,
            widget.user.token,
            salesOrder.quantity,
            salesOrder.paymentPhone,
            salesOrder.paymentNetwork, () {
          setState(() {
            _loadingData = false;
          });
        });
      }
    });
  }

//MARK: event module view
  Widget _moduleEventView(BuildContext buildContext) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _moduleEvents.length,
      itemBuilder: (context, i) {
        if (i == _moduleEvents.length - _nextPageThreshold &&
            !_loadedPages.contains(_nextUrl)) {
          _getFeed(_nextUrl, false);
        }
        var eventModule = _moduleEvents[i];
        return GestureDetector(
          onTap: () {
            if (eventModule.actionType == HomeFeedType.EVENT.name) {
              _showEventActions(eventModule);
            } else {
              AppUtil().shareToSocialMedia(
                  "Hey! CheckOut My New Score", eventModule.title);
            }
          },
          child: eventModule.actionType == HomeFeedType.QUIZ.name
              ? CommonWidget().moduleEvent(
                  context,
                  eventModule,
                )
              : CommonWidget().eventFeedView(context, eventModule, true),
        );
      },
    );
  }

  void _showEventActions(ModuleEvent moduleEvent) {
    BottomSheetPage().showEventAction(context, moduleEvent, (result) {
      if (result == FeedActionType.EVENT_SCAN.name) {
        _navgateToQrScreen(moduleEvent);
      } else if (result == FeedActionType.EVENT_DIRECTION.name) {
        ProductUtil().navgateToDirection(
            moduleEvent.title, moduleEvent.latitude, moduleEvent.longitude);
      }
    });
  }

  //MARK: start all products page
  void _navgateToProductsScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AllProductsPage()))
        .then((value) {});
  }

//MARK: start qr code scanner
  void _navgateToQrScreen(ModuleEvent moduleEvent) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const EventCheckInPage()))
        .then((value) {
      if (value != null) {
        _eventCheckIn(value, moduleEvent);
      }
    });
  }

//MARK: check  user in
  void _eventCheckIn(String qrCode, ModuleEvent moduleEvent) {
    setState(() {
      _loadingData = true;
    });
    Map<String, String> data = {};
    data.putIfAbsent("qr_string", () => qrCode);
    data.putIfAbsent("latitude", () => moduleEvent.latitude.toString());
    data.putIfAbsent("longitude", () => moduleEvent.longitude.toString());
    String title = "KAP Event CheckIn";
    ApiService.get(widget.user.token)
        .postData(ApiUrl().eventCheckIn(), data)
        .then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        var message = value["message"].toString();
        AppAlertDialog().showAlertDialog(context, title, message, () {});
      } else {
        var message = value["detail"].toString();
        AppAlertDialog().showAlertDialog(context, title, message, () {});
      }
    }).whenComplete(() {
      setState(() {
        _loadingData = false;
      });
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
