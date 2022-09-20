import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/common/common_widget.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:knowledge_access_power/util/product_util.dart';

import '../model/module_reproductive_kit.dart';
import '../popup/bottom_sheet_page.dart';
import '../util/app_bar_widget.dart';
import '../util/app_enum.dart';
import '../util/progress_indicator_bar.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({Key? key}) : super(key: key);

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  bool _loadingData = false;
  final int _nextPageThreshold = 5;
  final List<String> _loadedPages = [];
  String _nextUrl = "";
  final List<ReproductiveKitModule> _moduleReproductiveKits = [];
  UserItem _user = UserItem();
  final String _searchHint = "Search for product";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    DBOperations().getUser().then((value) {
      setState(() {
        _user = value;
      });
      _getKitsFeed(ApiUrl().filterProducts(), "", true);
    });
    super.initState();
  }

  //MARK: get kit data
  void _getKitsFeed(String url, String searchText, bool isRefresh) {
    if (isRefresh) {
      setState(() {
        _loadingData = true;
      });
    }
    _loadedPages.add(url);
    Map<String, String> data = {};
    data.putIfAbsent("search_text", () => searchText);
    ApiService.get(_user.token).postData(url, data).then((value) {
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
    return Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: AppBarWidget.primaryAppBar("Products"),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: SafeArea(
              child: _buildMainContent(context),
            )));
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColor.bgColor,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _loadingData
                  ? ProgressIndicatorBar()
                  : Container(
                      height: 4,
                    ),
              _searchBar(),
              _buildKitsContainer()
            ]),
      ),
    );
  }

  //MARK: ui component
  Widget _buildKitsContainer() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _moduleReproductiveKits.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        if (index == _moduleReproductiveKits.length - _nextPageThreshold) {
          _getKitsFeed(_nextUrl, "", false);
        }
        var eventKit = _moduleReproductiveKits[index];
        return CommonWidget().moduleReproductiveKit(context, eventKit, () {
          BottomSheetPage().showBuyingAction(context, eventKit, (callback) {
            if (callback == FeedActionType.BUY_KIT.name) {
              ProductUtil().showBuyingAction(context, eventKit, (salesOrder) {
                if (salesOrder != null) {
                  setState(() {
                    _loadingData = true;
                  });
                  ProductUtil().buyReproductiveKit(
                      context,
                      salesOrder.reproductiveKitModule,
                      _user.token,
                      salesOrder.quantity,
                      salesOrder.paymentPhone,
                      salesOrder.paymentNetwork, () {
                    setState(() {
                      _loadingData = false;
                    });
                  });
                }
              });
            } else if (callback == FeedActionType.KIT_SHOP_DIRECTION.name) {
              ProductUtil().navgateToDirection(
                  eventKit.shopName, eventKit.shopLat, eventKit.shopLon);
            }
          });
        });
      },
    );
  }

//MARK: search bar widget
  Widget _searchBar() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 5),
        height: 44,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Card(
              elevation: 0.5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.transparent, width: 0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: CupertinoSearchTextField(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                placeholder: _searchHint,
                placeholderStyle:
                    AppTextStyle.normalTextStyle(Colors.grey, 14.0),
                style: AppTextStyle.normalTextStyle(Colors.grey, 14.0),
                controller: _searchController,
                onChanged: (String text) {
                  _startSearch(text);
                },
                onSubmitted: (String text) {
                  _startSearch(text);
                },
              ),
            )));
  }

  void _startSearch(String text) {
    var url = ApiUrl().filterProducts();
    _getKitsFeed(url, text, true);
  }
}
