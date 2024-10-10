import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mid_term/database/product.dart';

ValueNotifier<List<Product>> productListNotifier = ValueNotifier([]);

final CollectionReference productCollection =
    FirebaseFirestore.instance.collection('Product');

// Add data
Future<void> addProduct(Product product) async {
  final docRef = productCollection.doc();
  product.id = docRef.id;
  await docRef.set(product.toMap());

  await getAllProducts();
}

// get all data
Future<void> getAllProducts() async {
  final QuerySnapshot snapshot = await productCollection.orderBy('name').get();

  // update lại toàn bộ danh sách sản phẩm
  productListNotifier.value = snapshot.docs.map((doc) {
    return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }).toList();
}

// update sản phẩm trong Firestore
Future<void> updateProduct(Product product) async {
  await productCollection.doc(product.id).update(product.toMap());

  await getAllProducts();
}

// delete data
Future<void> deleteProduct(String id) async {
  await productCollection.doc(id).delete();

  await getAllProducts();
}
