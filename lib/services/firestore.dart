import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanit/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all Unit of Measures from db
  Stream<List<UOM>> getUnitOfMeasures() {
    CollectionReference<Map<String, dynamic>> ref =
        _db.collection('unitofmeasure');
    return ref.snapshots().map(
          (snapShot) => snapShot.docs
              .map(
                (document) => UOM.fromJson(document.data()),
              )
              .toList(),
        );
  }

  // Get all Categories from db
  Stream<List<Category>> getCategories() {
    CollectionReference<Map<String, dynamic>> ref =
        _db.collection('categories');
    return ref.snapshots().map(
          (snapShot) => snapShot.docs
              .map(
                (document) => Category.fromJson(document.data()),
              )
              .toList(),
        );
  }

  // Get all Sessions from db
  Stream<List<Session>> getSession() {
    CollectionReference<Map<String, dynamic>> ref = _db.collection('session');

    return ref.orderBy('category', descending: false).snapshots().map(
          (snapShot) => snapShot.docs
              .map(
                (document) => Session.fromJson(document.data()),
              )
              .toList(),
        );
  }

  // Deletes all Sessions from db
  Future<void> resetSession() {
    CollectionReference<Map<String, dynamic>> ref = _db.collection('session');

    return ref.get().then(
      (snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      },
    );
  }

  Future<Item> getItem(String barcode) async {
    Item item = Item(barcode: barcode);

    CollectionReference<Map<String, dynamic>> itemsRef =
        _db.collection('items');

    QuerySnapshot<Map<String, dynamic>> snapshot = await itemsRef.get();

    for (var ds in snapshot.docs) {
      if (ds.data()['barcode'] == barcode) {
        return Future.value(Item.fromJson(ds.data()));
      }
    }
    return Future.value(item);
  }

  Future<void> addCategory({name: String, defaultuom: String, color: String}) {
    CollectionReference categories = _db.collection('categories');

    Category newCategory =
        Category(name: name, defaultuom: defaultuom, color: color);
    return categories.add(newCategory.toJson());
  }

  Future<void> addUnitOfMeasurement({value: String}) {
    CollectionReference uoms = _db.collection('unitofmeasure');

    UOM newUOM = UOM(value: value);
    return uoms.add(newUOM.toJson());
  }

  // adds the item to the sessions and the item collections
  // each collection is checked to see if the item already exists.
  // if it does exist it is replaced with the new item details

  Future<void> addToSessionAndItems(String barcode, String category,
      String name, double units, String uom, double price, String color) async {
    CollectionReference<Map<String, dynamic>> sessionRef =
        _db.collection('session');

    String sessionId = '';

    QuerySnapshot<Map<String, dynamic>> sessionSnapshot =
        await sessionRef.get();

    for (var ds in sessionSnapshot.docs) {
      if (ds.data()['barcode'] == barcode) {
        sessionId = ds.id;
      }
    }

    if (sessionId != '') {
      await sessionRef.doc(sessionId).delete();
    }

    Session newSession = Session(
      name: name,
      barcode: barcode,
      category: category,
      units: units,
      uom: uom,
      price: price,
      priceperoum: double.parse((price / units).toStringAsFixed(2)),
      color: color,
    );

    await sessionRef.add(newSession.toJson());

    CollectionReference<Map<String, dynamic>> itemRef = _db.collection('items');

    String itemId = '';

    QuerySnapshot<Map<String, dynamic>> itemSnapshot = await itemRef.get();

    for (var ds in itemSnapshot.docs) {
      if (ds.data()['barcode'] == barcode) {
        itemId = ds.id;
      }
    }

    if (itemId != '') {
      await itemRef.doc(itemId).delete();
    }

    Item newItem = Item(
        name: name,
        barcode: barcode,
        category: category,
        units: units,
        uom: uom,
        price: price);

    await itemRef.add(newItem.toJson());
  }
}
