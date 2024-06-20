import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uk_app/product.dart';

class FavoriteProductsProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Product> _products = [];

  List<Product> get products => _products;

  Future<List> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      List<dynamic> productList = json.decode(response.body);
      _products = productList.map((data) => Product.fromMap(data)).toList();

      await checkFavorites();
      notifyListeners();
      return _products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List> checkFavorites() async {
    User? user = _auth.currentUser;

    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();

      List<String> favoriteIds =
          querySnapshot.docs.map((doc) => doc.id).toList();

      for (var product in _products) {
        if (favoriteIds.contains(product.id.toString())) {
          product.isFavorite = true;
        }
      }
    }
    return _products;
  }

  Future<void> toggleFavoriteStatus(Product product) async {
    User? user = _auth.currentUser;

    if (user != null) {
      if (product.isFavorite) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(product.id.toString())
            .delete();
        product.isFavorite = false;
      } else {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(product.id.toString())
            .set(product.toMap());
        product.isFavorite = true;
      }

      notifyListeners();
    }
  }
}
