import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin/features/profile/presentation/widgets/product_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WardrobeSection extends StatefulWidget {
  final UserModel userModel;

  const WardrobeSection({Key? key, required this.userModel}) : super(key: key);

  @override
  _WardrobeSectionState createState() => _WardrobeSectionState();
}

class _WardrobeSectionState extends State<WardrobeSection> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWardrobeItems();
  }

  Future<void> _fetchWardrobeItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('clothes')
            .where('userId', isEqualTo: userId)
            .where('isPublic', isEqualTo: true)
            .get();

        List<Product> products = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Product(
            id: doc.id,
            title: data['nombre'] ?? '',
            price: data['precio'] ?? 0,
            image: data['imagen'] ?? '',
            description: data['descripcion'] ?? '',
            size: data['talla'] ?? '',
            styles: List<String>.from(data['estilos'] ?? []),
            quality: data['calidad'] ?? '',
            category: data['categoria'] ?? '',
            isExchangeOnly: data['soloIntercambio'] ?? false,
            userId: data['userId'],
            createdAt: data['createdAt'] ?? Timestamp.now(),
            isPublic: data['isPublic'] ?? false,
            inCloset: true,
          );
        }).toList();

        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching wardrobe items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 68),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'Armario',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'UrbaneMedium',
                        ),
                      ),
                      const SizedBox(width: 11),
                      Icon(Icons.arrow_forward_ios, size: 12),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/Filtrar.svg',
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          _isLoading ? const CircularProgressIndicator() : _buildWardrobeGrid(),
        ],
      ),
    );
  }

  Widget _buildWardrobeGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(product: _products[index]),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.network(
                  _products[index].image,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
