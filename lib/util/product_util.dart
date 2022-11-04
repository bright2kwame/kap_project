import 'package:flutter/material.dart';
import 'package:knowledge_access_power/model/sales_order.dart';
import 'package:map_launcher/map_launcher.dart';
import '../api/api_service.dart';
import '../api/api_url.dart';
import '../model/module_reproductive_kit.dart';
import '../popup/app_alert_dialog.dart';
import 'app_button_style.dart';
import 'app_input_decorator.dart';
import 'app_text_style.dart';

class ProductUtil {
  //MARK: perform action of buying
  void verifyReproductiveKit(
      BuildContext context,
      ReproductiveKitModule kit,
      String authToken,
      String quantity,
      String phone,
      String mobileNetwork,
      String otp,
      Function actionCompleted) {
    if (quantity.isEmpty) {
      AppAlertDialog().showAlertDialog(context, "KAP Purchase",
          "Provide the qunatity of item to buy", () {});
      return;
    }
    if (phone.isEmpty) {
      AppAlertDialog().showAlertDialog(
          context, "KAP Purchase", "Provide a payment phone number", () {});
      return;
    }

    if (mobileNetwork.isEmpty) {
      AppAlertDialog().showAlertDialog(
          context, "KAP Purchase", "Select a network and proceed", () {});
      return;
    }

    String totalCost =
        (double.parse(quantity) * double.parse(kit.amount)).toString();
    Map<String, String> data = {};
    data.putIfAbsent("unique_code", () => otp);
    data.putIfAbsent("currency", () => kit.currency);
    data.putIfAbsent("total_amount", () => totalCost);
    data.putIfAbsent("discount", () => "0.0");
    data.putIfAbsent("service_charge", () => "0.0");
    data.putIfAbsent("grand_total", () => totalCost);
    data.putIfAbsent(
        "order_items", () => "${kit.id}:$quantity:${kit.amount}:$totalCost");
    data.putIfAbsent("payment_method", () => "MOMO");
    data.putIfAbsent("sender_wallet_number", () => phone);
    data.putIfAbsent("phone_number", () => phone);
    data.putIfAbsent("sender_wallet_network", () => mobileNetwork);

    ApiService.get(authToken)
        .postData(ApiUrl().verifyPaymentNumberOrder(), data)
        .then((value) {
          var statusCode = value["response_code"].toString();
          if (statusCode == "100") {
            actionCompleted(true);
          } else {
            print(value.toString());
            actionCompleted(false);
            var message = value["detail"].toString();
            AppAlertDialog()
                .showAlertDialog(context, kit.title, message, () {});
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          actionCompleted(false);
          AppAlertDialog()
              .showAlertDialog(context, kit.title, error.toString(), () {});
        });
  }

  //MARK: perform action of buying
  void buyReproductiveKit(
      BuildContext context,
      ReproductiveKitModule kit,
      String authToken,
      String quantity,
      String phone,
      String mobileNetwork,
      String otp,
      Function actionCompleted) {
    if (quantity.isEmpty) {
      AppAlertDialog().showAlertDialog(context, "KAP Purchase",
          "Provide the qunatity of item to buy", () {});
      return;
    }
    if (phone.isEmpty) {
      AppAlertDialog().showAlertDialog(
          context, "KAP Purchase", "Provide a payment phone number", () {});
      return;
    }

    if (mobileNetwork.isEmpty) {
      AppAlertDialog().showAlertDialog(
          context, "KAP Purchase", "Select a network and proceed", () {});
      return;
    }

    String totalCost =
        (double.parse(quantity) * double.parse(kit.amount)).toString();
    Map<String, String> data = {};
    data.putIfAbsent("unique_code", () => otp);
    data.putIfAbsent("currency", () => kit.currency);
    data.putIfAbsent("total_amount", () => totalCost);
    data.putIfAbsent("discount", () => "0.0");
    data.putIfAbsent("service_charge", () => "0.0");
    data.putIfAbsent("grand_total", () => totalCost);
    data.putIfAbsent(
        "order_items", () => "${kit.id}:$quantity:${kit.amount}:$totalCost");
    data.putIfAbsent("payment_method", () => "MOMO");
    data.putIfAbsent("sender_wallet_number", () => phone);
    data.putIfAbsent("sender_wallet_network", () => mobileNetwork);
    ApiService.get(authToken)
        .postData(ApiUrl().placeOrder(), data)
        .then((value) {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        var message = value["message"].toString();
        AppAlertDialog().showAlertDialog(context, kit.title, message, () {});
      } else {
        var message = value["detail"].toString();
        AppAlertDialog().showAlertDialog(context, kit.title, message, () {});
      }
    }).whenComplete(() {
      actionCompleted();
    }).onError((error, stackTrace) {
      AppAlertDialog()
          .showAlertDialog(context, kit.title, error.toString(), () {});
    });
  }

  //MARK: buying verification action
  void showBuyingVerifyAction(BuildContext context, SalesOrder salesOrder,
      ReproductiveKitModule kit, Function actionCompleted) {
    TextEditingController otpController = TextEditingController();
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0), topRight: Radius.circular(0.0)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
                child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 16),
                          child: Text(
                            "MAKE PAYMENT - ${kit.title}",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                          ),
                        ),
                        const Divider(
                          height: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: Text(
                            "Provide information below and proceed to make payment of ${kit.currency} ${kit.amount}",
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 12.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: otpController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter verification code"),
                          ),
                        ),
                        Container(
                          height: 44,
                          width: MediaQuery.of(context).size.width - 32,
                          margin: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              actionCompleted(otpController.text);
                            },
                            child: Text(
                              "MAKE PAYMENT",
                              style: AppTextStyle.normalTextStyle(
                                  Colors.white, 14),
                            ),
                            style: AppButtonStyle.squaredSmallColoredEdgeButton,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    )));
          });
        });
  }

  void showBuyingAction(BuildContext context, ReproductiveKitModule kit,
      Function actionCompleted) {
    final _networkTypes = [
      "Airtel Tigo",
      "MTN",
      "Vodafone",
    ];
    List<String> networkCodes = ["AIR", "MTN", "VOD"];
    String networkSelected = "MTN";
    String networkValue = "MTN";
    TextEditingController quantityController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0), topRight: Radius.circular(0.0)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
                child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 16),
                          child: Text(
                            "MAKE PAYMENT - ${kit.title}",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                          ),
                        ),
                        const Divider(
                          height: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: Text(
                            "Provide information below and proceed to make payment of ${kit.currency} ${kit.amount}",
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 12.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: quantityController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Quantity to buy"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: phoneController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter phone number"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 16),
                          child: DropdownButton<String>(
                            value: networkSelected,
                            isExpanded: true,
                            hint: const Text('Choose Network'),
                            items: _networkTypes.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                networkSelected = value.toString();
                                networkValue = networkCodes[
                                    _networkTypes.indexOf(networkSelected)];
                              });
                            },
                          ),
                        ),
                        Container(
                          height: 44,
                          width: MediaQuery.of(context).size.width - 32,
                          margin: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              actionCompleted(SalesOrder(
                                  quantity: quantityController.text,
                                  reproductiveKitModule: kit,
                                  paymentNetwork: networkValue,
                                  paymentPhone: phoneController.text,
                                  payToken: ""));
                            },
                            child: Text(
                              "MAKE PAYMENT",
                              style: AppTextStyle.normalTextStyle(
                                  Colors.white, 14),
                            ),
                            style: AppButtonStyle.squaredSmallColoredEdgeButton,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    )));
          });
        });
  }

  //MARK: start map  to get direction
  void navgateToDirection(String title, String lat, String lon) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(double.parse(lat), double.parse(lon)),
      title: title,
      description: title,
    );
  }
}
