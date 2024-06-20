import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uk_app/favorite_products_provider.dart';
import 'package:uk_app/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          Consumer<FavoriteProductsProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: product.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  provider.toggleFavoriteStatus(product);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(product.image),
              SizedBox(height: 16),
              Text(
                product.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                product.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uk_app/favorite_products_provider.dart';

// class ProductDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> product;
//   FavoriteProductsProvider fp = FavoriteProductsProvider();

//   ProductDetailScreen({required this.product});

//   @override
//   Widget build(BuildContext context) {
//     fp = Provider.of<FavoriteProductsProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product['title']),
//         actions: [
//           Consumer<FavoriteProductsProvider>(
//               builder: (context, provider, child) {
//             return IconButton(
//               icon: Icon(
//                 fp.fav ? Icons.favorite : Icons.favorite_border,
//                 color: fp.fav ? Colors.red : Colors.grey,
//               ),
//               onPressed: () {
//                 if (fp.fav) {
//                   provider.removeFavoriteProduct(product);
//                 } else {
//                   provider.addFavoriteProduct(product);
//                 }
//               },
//             );
//           })
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.network(product['image']),
//               SizedBox(height: 16.0),
//               Text(product['title'], style: TextStyle(fontSize: 24.0)),
//               SizedBox(height: 8.0),
//               Text('\$${product['price']}', style: TextStyle(fontSize: 20.0)),
//               SizedBox(height: 16.0),
//               Text(product['description']),
//               SizedBox(height: 16.0),
//               // Add specifications here
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
