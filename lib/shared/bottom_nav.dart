import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanit/item/item.dart';
import 'package:scanit/services/bottom_sheet.dart';
import 'package:scanit/services/firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  Future<void> scanBarcodeNormal(BuildContext context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      await FirestoreService().getItem(barcodeScanRes).then(
        (value) {
          print(value.toJson());

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ItemScreen(
                item: value,
              ),
            ),
          );
        },
      ).catchError(
        (error) {
          BottomSheetModel().create(
              context, false, 'Oops. Could not find the barcore', false);
        },
      );
    } on PlatformException {
      Navigator.of(context).pop();
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: ElevatedButton(
            child: Text('Reset'),
            onPressed: () {
              FirestoreService()
                  .resetSession()
                  .then((value) => BottomSheetModel()
                      .create(context, true, 'List has been reset!', true))
                  .catchError(
                    (error) => BottomSheetModel().create(
                        context,
                        false,
                        'Oops. Something went wrong when reseting your list.',
                        false),
                  );
            },
          ),
        ),
        Flexible(
          child: ElevatedButton(
            child: Text('Item '),
            onPressed: () => scanBarcodeNormal(context),
          ),
        ),
      ],
    );
  }
}
