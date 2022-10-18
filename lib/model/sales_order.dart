import 'package:knowledge_access_power/model/module_reproductive_kit.dart';

//MARK: an object to hold the order placed by user
class SalesOrder {
  ReproductiveKitModule reproductiveKitModule;
  //item quantity
  String quantity;
  //phone number to make payment
  String paymentPhone;
  //network to use for the momo
  String paymentNetwork;
  //the payment token
  String payToken;
  SalesOrder(
      {required this.quantity,
      required this.reproductiveKitModule,
      required this.paymentNetwork,
      required this.paymentPhone,
      required this.payToken});
}
