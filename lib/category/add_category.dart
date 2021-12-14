import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scanit/category/add_category_state.dart';
import 'package:scanit/services/bottom_sheet.dart';
import 'package:scanit/services/firestore.dart';
import 'package:scanit/services/models.dart';

class AddCatergory extends StatelessWidget {
  final List<UOM> uoms;
  final List<Category> categories;

  const AddCatergory({Key? key, required this.uoms, required this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddCategoryState>(
      create: (_) => AddCategoryState(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Category'),
        ),
        body: AddCategoryForm(
          uoms: uoms,
          categories: categories,
        ),
        floatingActionButton: AddCategoryButton(
          categories: categories,
        ),
      ),
    );
  }
}

class AddCategoryButton extends StatelessWidget {
  final List<Category> categories;

  const AddCategoryButton({
    Key? key,
    required this.categories,
  }) : super(key: key);

  _addCategory(String name, String defaultOum, List<Category> categories,
      Color color, BuildContext context) {
    name = name.trim();

    if (name.isEmpty) {
      BottomSheetModel().create(context, false,
          'You need to provide a name for the categpry.', false);
    } else if (categories.indexWhere(
            (element) => element.name.toLowerCase() == name.toLowerCase()) >
        -1) {
      BottomSheetModel()
          .create(context, false, 'That category already exists.', false);
    } else if (defaultOum.isEmpty) {
      BottomSheetModel().create(
          context,
          false,
          'You need to provide a default unit of measure for the category.',
          false);
    } else if (name == 'new category') {
      BottomSheetModel().create(context, false,
          'A category cannot have the name "New Categroy".', false);
    } else {
      String hexColor = '#' + color.value.toRadixString(16).substring(2);

      FirestoreService()
          .addCategory(name: name, defaultuom: defaultOum, color: hexColor)
          .then((value) {
        BottomSheetModel()
            .create(context, true, 'Category successfully added!', false, 2);
      }).catchError((error) {
        BottomSheetModel().create(context, false,
            'Oops. Something went wrong when creating the Category.', false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AddCategoryState state = Provider.of<AddCategoryState>(context);

    return FloatingActionButton(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(FontAwesomeIcons.save),
      ),
      onPressed: () {
        _addCategory(state.name, state.defaultoum, categories,
            state.selectedcolor, context);
      },
    );
  }
}

class AddCategoryForm extends StatelessWidget {
  final List<UOM> uoms;
  final List<Category> categories;

  const AddCategoryForm(
      {Key? key, required this.uoms, required this.categories})
      : super(key: key);

  void _pickColor(BuildContext context, AddCategoryState state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ColorPicker(
                  pickerColor: state.selectedcolor,
                  enableAlpha: false,
                  labelTypes: [],
                  onColorChanged: (color) => {state.selectedcolor = color}),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('SELECT', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AddCategoryState state = Provider.of<AddCategoryState>(context);

    uoms.retainWhere((element) => element.value != 'New UOM');

    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: state.name,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the name',
                labelText: 'Category'),
            onChanged: (value) => state.name = value,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<UOM>(
            value: state.selecteduom,
            hint: Text('Select a UOM'),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Unit of Measurement',
            ),
            items: uoms.map((uom) {
              return DropdownMenuItem(value: uom, child: Text(uom.value));
            }).toList(),
            onChanged: (uom) {
              state.defaultoum = uom!.value;
              state.selecteduom = uom;
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state.selectedcolor,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    child: RaisedButton(
                      onPressed: () {
                        _pickColor(context, state);
                      },
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      shape: CircleBorder(side: BorderSide.none),
                      child: Icon(FontAwesomeIcons.palette),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
