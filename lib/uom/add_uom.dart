import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scanit/services/bottom_sheet.dart';
import 'package:scanit/services/firestore.dart';
import 'package:scanit/services/models.dart';
import 'package:scanit/uom/add_uom_state.dart';

class AddUOM extends StatelessWidget {
  final List<UOM> uoms;

  const AddUOM({Key? key, required this.uoms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddUOMState>(
      create: (_) => AddUOMState(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Unit of Measurement'),
        ),
        body: AddUOMForm(uoms: uoms),
        floatingActionButton: AddUOMButton(uoms: uoms),
      ),
    );
  }
}

class AddUOMButton extends StatelessWidget {
  final List<UOM> uoms;

  const AddUOMButton({Key? key, required this.uoms}) : super(key: key);

  _addUnitOfMeasure(String uom, List<UOM> uoms, BuildContext context) {
    uom = uom.trim();

    if (uom.isEmpty) {
      BottomSheetModel().create(context, false,
          'You need to provide a value for the unit of measurement.', false);
    } else if (uoms.indexWhere(
            (element) => element.value.toLowerCase() == uom.toLowerCase()) >
        -1) {
      BottomSheetModel().create(
          context, false, 'That unit of measurement already exists.', false);
    } else if (uom == 'new uom') {
      BottomSheetModel().create(context, false,
          'A unit of measurement cannot have the name "New UOM".', false);
    } else {
      FirestoreService().addUnitOfMeasurement(value: uom).then((value) {
        BottomSheetModel().create(
            context, true, 'Unit of Measurement successfully added!', false, 2);
      }).catchError((error) {
        BottomSheetModel().create(
            context,
            false,
            'Oops. Something went wrong when creating the Unit of Measurement.',
            false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AddUOMState state = Provider.of<AddUOMState>(context);

    return FloatingActionButton(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(FontAwesomeIcons.save),
      ),
      onPressed: () {
        _addUnitOfMeasure(state.value, uoms, context);
      },
    );
  }
}

class AddUOMForm extends StatelessWidget {
  final List<UOM> uoms;

  const AddUOMForm({Key? key, required this.uoms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddUOMState state = Provider.of<AddUOMState>(context);

    return Padding(
      padding: const EdgeInsets.all(25),
      child: TextFormField(
        initialValue: state.value,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter the value',
            labelText: 'Unit of Measurement'),
        onChanged: (value) => state.value = value,
        keyboardType: TextInputType.text,
      ),
    );
  }
}
