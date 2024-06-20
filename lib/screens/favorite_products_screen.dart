import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uk_app/favorite_products_provider.dart';
import 'package:uk_app/product.dart';
import 'package:uk_app/screens/product_detail_screen.dart';

class FavoriteProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products'),
      ),
      body: Consumer<FavoriteProductsProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: provider.checkFavorites(),
            builder: (context, snapshot) {
              print('SNAPSHOT: ${snapshot.data}');
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    if (provider.products[index].isFavorite) {
                      return ListTile(
                        leading: Image.network(product.image),
                        title: Text(product.title),
                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                product.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            provider.toggleFavoriteStatus(product);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //   // GET FIRESTORE FAVORITES
      //   stream: FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(FirebaseAuth.instance.currentUser!.uid)
      //       .collection('favorites')
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     }

      //     return ListView.builder(
      //       itemCount: snapshot.data!.docs.length,
      //       itemBuilder: (context, index) {
      //         DocumentSnapshot doc = snapshot.data!.docs[index];
      //         print('DOC: ${doc.data()}');
      //         Product product = Product(
      //             id: doc['id'],
      //             title: doc['title'],
      //             description: doc['description'],
      //             price: doc['price'],
      //             image: doc['image']);
      //         // Product product = doc.data();
      //         return Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: ListTile(
      //             leading: Image.network(doc['image']),
      //             title: Text(doc['title']),
      //             subtitle: Text('\$${doc['price']}'),
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) =>
      //                       ProductDetailsScreen(product: product),
      //                 ),
      //               );
      //             },
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
