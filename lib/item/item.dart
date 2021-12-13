import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scanit/category/add_category.dart';
import 'package:scanit/item/item_state.dart';
import 'package:scanit/services/bottom_sheet.dart';
import 'package:scanit/services/firestore.dart';
import 'package:scanit/services/models.dart';
import 'package:scanit/uom/add_uom.dart';

class ItemScreen extends StatelessWidget {
  final Item item;

  const ItemScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ItemState>(
      create: (_) => ItemState(
          name: item.name,
          price: item.price,
          units: item.units,
          category: item.category,
          barcode: item.barcode,
          uom: item.uom),
      child: StreamProvider<List<Category>>(
        create: (context) => FirestoreService().getCategories(),
        initialData: [Category(), Category()],
        child: StreamProvider<List<UOM>>(
          create: (context) => FirestoreService().getUnitOfMeasures(),
          initialData: [UOM(), UOM()],
          child: Scaffold(
            appBar: AppBar(
              title: Text('Item: ${item.barcode}'),
            ),
            body: ItemForm(),
            floatingActionButton: SaveItemButton(),
          ),
        ),
      ),
    );
  }
}

class SaveItemButton extends StatelessWidget {
  const SaveItemButton({
    Key? key,
  }) : super(key: key);

  _commitItemToDB(String barcode, String category, String name, double units,
      String uom, double price, BuildContext context) {
    if (barcode.isEmpty) {
      BottomSheetModel()
          .create(context, false, 'Oops. The barcode was lost.', true);
    } else if (category.isEmpty) {
      BottomSheetModel()
          .create(context, false, 'You need to select a category.', false);
    } else if (name.isEmpty) {
      BottomSheetModel()
          .create(context, false, 'You need to provide a name.', false);
    } else if (units <= 0 || units.isInfinite) {
      BottomSheetModel().create(context, false,
          'You need to enter a unit value which is greater than 0.', false);
    } else if (uom.isEmpty) {
      BottomSheetModel().create(
          context, false, 'You need to select a unit of measure!', false);
    } else if (price <= 0 || price.isInfinite) {
      BottomSheetModel().create(context, false,
          'You need to enter a price which is greater than 0.', false);
    } else {
      FirestoreService()
          .addToSessionAndItems(barcode, category, name, units, uom, price)
          .then((value) {
        BottomSheetModel().create(context, true, 'Item Saved!', true);
      }).catchError((error) {
        BottomSheetModel().create(context, false,
            'Oops. Something went wrong when trying to save the item.', false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ItemState state = Provider.of<ItemState>(context);

    return FloatingActionButton(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(FontAwesomeIcons.save),
      ),
      onPressed: () {
        _commitItemToDB(state.st_barcode, state.st_category, state.st_name,
            state.st_units, state.st_uom, state.st_price, context);
      },
    );
  }
}

class ItemForm extends StatelessWidget {
  const ItemForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ItemState state = Provider.of<ItemState>(context);

    List<Category> categories = Provider.of<List<Category>>(context);
    List<UOM> uoms = Provider.of<List<UOM>>(context);

    int categoryIndex =
        categories.indexWhere((element) => element.name == state.st_category);

    if (categoryIndex > -1) {
      state.st_selectedcategory = categories.elementAt(categoryIndex);
    } else {
      state.st_selectedcategory = null;
    }

    categoryIndex =
        categories.indexWhere((element) => element.name == 'New Category');

    if (categoryIndex == -1) {
      categories.add(Category(name: 'New Category'));
    }

    int uomIndex = uoms.indexWhere((element) => element.value == state.st_uom);

    if (uomIndex > -1) {
      state.st_selecteduom = uoms.elementAt(uomIndex);
    } else {
      state.st_selecteduom = null;
    }

    uomIndex = uoms.indexWhere((element) => element.value == 'New UOM');

    if (uomIndex == -1) {
      uoms.add(UOM(value: 'New UOM'));
    }

    return Padding(
      padding: EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 70,
              child: DropdownButtonFormField<Category>(
                hint: Text('Select a Category'),
                value: state.st_selectedcategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category',
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                      value: category, child: Text(category.name));
                }).toList(),
                onChanged: (category) {
                  if (category!.name == 'New Category') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddCatergory(categories: categories, uoms: uoms),
                      ),
                    );
                    return;
                  }
                  state.st_selectedcategory = category;
                  state.st_category = category.name;
                  state.st_uom = category.defaultuom;

                  int index =
                      uoms.indexWhere((element) => element.value == state.uom);

                  state.st_selecteduom = uoms[index];
                },
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: state.st_name,
              onChanged: (value) {
                state.st_name = value;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a name',
                  labelText: 'Name'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: state.st_units.toString(),
              onChanged: (value) {
                state.st_units = double.parse(value);
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the weight',
                  labelText: 'Units'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 70,
              child: DropdownButtonFormField<UOM>(
                hint: Text('Select a UOM'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Unit of Measurement',
                ),
                value: state.st_selecteduom,
                items: uoms.map((uom) {
                  return DropdownMenuItem(value: uom, child: Text(uom.value));
                }).toList(),
                onChanged: (uom) {
                  if (uom!.value == 'New UOM') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => AddUOM(uoms: uoms),
                      ),
                    );
                    return;
                  }
                  state.st_uom = uom.value;
                  state.st_selecteduom = uom;
                },
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: state.st_price.toString(),
              onChanged: (value) {
                state.st_price = double.parse(value);
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the price',
                  labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
