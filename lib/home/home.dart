import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scanit/item/item.dart';
import 'package:scanit/services/bottom_sheet.dart';
import 'package:scanit/services/firestore.dart';
import 'package:scanit/services/models.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _processItem(BuildContext context, String barcode) async {
    return await FirestoreService().getItem(barcode).then(
      (value) {
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
        BottomSheetModel()
            .create(context, false, 'Oops. Could not find the item.', false);
      },
    );
  }

  Future<void> _scanBarcodeNormal(BuildContext context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      if (barcodeScanRes.length >= 5) {
        await _processItem(context, barcodeScanRes);
      }
    } on PlatformException {
      Navigator.of(context).pop();
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  _createColorObjectFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length <= 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    List<Session> sessions = Provider.of<List<Session>>(context);

    int cheapestIndex = 0;
    double cheapestValue = sessions.isEmpty ? 0.0 : sessions[0].priceperoum;
    int luxuriousIndex = 0;
    double luxuriousValue = sessions.isEmpty ? 0.0 : sessions[0].priceperoum;

    for (int k = 0; k < sessions.length; k++) {
      double currentPricePerUom = sessions[k].priceperoum;

      if (currentPricePerUom > luxuriousValue) {
        luxuriousValue = currentPricePerUom;
        luxuriousIndex = k;
      }

      if (currentPricePerUom < cheapestValue) {
        cheapestValue = currentPricePerUom;
        cheapestIndex = k;
      }
    }

    print('index: $cheapestIndex, Value: $cheapestValue');
    print('index: $luxuriousIndex, Value: $luxuriousValue');

    return Scaffold(
      appBar: AppBar(
        title: Text('${sessions.length} items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            Session currentSessionItem = sessions[index];

            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    _processItem(context, currentSessionItem.barcode);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: _createColorObjectFromHex(
                                    currentSessionItem.color),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  currentSessionItem.category,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              currentSessionItem.name,
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                  '${currentSessionItem.units.toString()} ${currentSessionItem.uom}'),
                            ),
                            Flexible(
                                child: Text(
                                    'R${currentSessionItem.price.toString()}')),
                            Flexible(
                              child: Text(
                                'R${(currentSessionItem.priceperoum).toStringAsFixed(2)} / ${currentSessionItem.uom}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (cheapestIndex == index
                                      ? Colors.green.shade400
                                      : (luxuriousIndex == index
                                          ? Colors.red.shade400
                                          : Colors.black)),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: sessions.length,
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 30),
        backgroundColor: Theme.of(context).primaryColor,
        spacing: 10,
        spaceBetweenChildren: 10,
        animationSpeed: 500,
        visible: true,
        renderOverlay: false,
        overlayOpacity: 0,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(
                FontAwesomeIcons.barcode,
                color: Colors.white,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              onTap: () {
                _scanBarcodeNormal(context);
              },
              label: 'Scan Item',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Theme.of(context).primaryColor),
          SpeedDialChild(
              child: Icon(FontAwesomeIcons.redo, color: Colors.white),
              backgroundColor: Theme.of(context).primaryColor,
              onTap: () {
                FirestoreService()
                    .resetSession()
                    .then((value) => BottomSheetModel().create(
                        context, true, 'List has been reset!', false, 1))
                    .catchError(
                      (error) => BottomSheetModel().create(
                          context,
                          false,
                          'Oops. Something went wrong when reseting your list.',
                          false),
                    );
              },
              label: 'Reset List',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Theme.of(context).primaryColor)
        ],
      ),
    );
  }
}
