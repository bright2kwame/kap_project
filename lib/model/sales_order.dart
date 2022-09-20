import 'package:knowledge_access_power/model/module_reproductive_kit.dart';

class SalesOrder {
  ReproductiveKitModule reproductiveKitModule;
  String quantity;
  String paymentPhone;
  String paymentNetwork;
  SalesOrder(
      {required this.quantity,
      required this.reproductiveKitModule,
      required this.paymentNetwork,
      required this.paymentPhone});
}
