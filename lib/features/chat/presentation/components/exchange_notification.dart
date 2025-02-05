import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:pin/features/exchanges/models/Exchange.dart';
import 'package:pin/core/services/catalogue.dart';
import 'package:pin/features/exchanges/models/Product.dart';

import '../../../../core/constants/constants.dart';

class ExchangeNotification extends StatelessWidget {
  final ChatMessageModel? exchange;
  final bool isClickable;
  final String receiver;
  final String? User1;
  final String? User2;

  ExchangeNotification({
    super.key,
    required this.exchange,
    required this.receiver,
    this.isClickable = true,
    this.User1,
    this.User2,
  });

  Future<String> _getUserName(String? uid) async {
    if (uid == null || uid.isEmpty) {
      return 'Usuario desconocido';
    }

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final userData = UserModel.fromFirestore(userDoc);
      return userData.name;
    }
    return 'Usuario desconocido';
  }

  Future<Exchange?> _getExchange(String exchangeId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('exchanges')
          .doc(exchangeId)
          .get();

      if (docSnapshot.exists) {
        return Exchange.fromFirestore(docSnapshot);
      }
      return null;
    } catch (e) {
      print('Error al obtener el intercambio: $e');
      return null;
    }
  }

  Future<List<Map<String, String>>> _getProductInfo(
      List<String> productIds) async {
    List<Map<String, String>> products = [];
    for (String id in productIds) {
      Product? product = await CatalogService().getClothById(id);
      if (product != null) {
        products.add({
          'title': product.title,
          'image': product.image,
        });
      }
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String currentUserUid = _auth.currentUser?.uid ?? '';

    return FutureBuilder<Exchange?>(
      future:
          exchange?.content != null ? _getExchange(exchange!.content) : null,
      builder: (context, exchangeSnapshot) {
        if (exchangeSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final exchange = exchangeSnapshot.data;

        return FutureBuilder<List<List<Map<String, String>>>>(
          future: exchange != null
              ? Future.wait([
                  _getProductInfo(exchange.itemsOffered),
                  _getProductInfo(exchange.itemsRequested),
                ])
              : null,
          builder: (context, productsSnapshot) {
            if (productsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final offeredProducts = productsSnapshot.data?[0] ?? [];
            final requestedProducts = productsSnapshot.data?[1] ?? [];

            return GestureDetector(
              onTap: isClickable
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Exchanges(
                            selectedProduct: null,
                            exchangeId: this.exchange?.content,
                            receiverId: this.exchange?.sender == currentUserUid
                                ? receiver
                                : this.exchange?.sender,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: PrimaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.swap_horiz,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              this.exchange?.sender == currentUserUid
                                  ? 'Enviaste una oferta'
                                  : 'Has recibido una oferta',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      if (offeredProducts.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Ofreces',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: offeredProducts.length,
                            itemBuilder: (context, index) {
                              final product = offeredProducts[index];
                              return Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 8),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(product['image']!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      product['title']!,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 10,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      if (requestedProducts.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Solicitas',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: requestedProducts.length,
                            itemBuilder: (context, index) {
                              final product = requestedProducts[index];
                              return Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 8),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(product['image']!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      product['title']!,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 10,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
