import 'dart:io';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class EventCheckInPage extends StatefulWidget {
  const EventCheckInPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EventCheckInPage> createState() => _EventCheckInPageState();
}

class _EventCheckInPageState extends State<EventCheckInPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(
            borderColor: AppColor.primaryDarkColor,
            borderWidth: 2.0,
            borderLength: 100),
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        _scannedResult(scanData);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _scannedResult(Barcode result) {
    controller?.dispose();
    Navigator.of(context).pop(result.code);
  }
}
