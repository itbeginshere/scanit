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

  @override
  Widget build(BuildContext context) {
    List<Session> sessions = Provider.of<List<Session>>(context);

    Future<void> _processItem(String barcode) async {
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
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE);

        if (barcodeScanRes != '-1') {
          await _processItem(barcodeScanRes);
        }
      } on PlatformException {
        Navigator.of(context).pop();
        barcodeScanRes = 'Failed to get platform version.';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('List: ${sessions.length} items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            Session currentSessionItem = sessions[index];

            return Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  _processItem(currentSessionItem.barcode);
                },
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentSessionItem.category,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(currentSessionItem.name)),
                            Flexible(
                              child: Text(
                                  '${currentSessionItem.units.toString()} ${currentSessionItem.uom}'),
                            ),
                            Flexible(
                                child: Text(
                                    'R${currentSessionItem.price.toString()}')),
                            Flexible(
                              child: Text(
                                  'R${(currentSessionItem.price / currentSessionItem.units).toStringAsFixed(2)} / ${currentSessionItem.uom}'),
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
