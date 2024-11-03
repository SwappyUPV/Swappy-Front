import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin/features/rewards/components/product_card.dart';
import 'package:pin/features/rewards/models/product_model.dart';
import 'package:pin/features/rewards/constants.dart';

class Rewards extends StatelessWidget {
  static int currentPoints = 1200; // Puntos actuales iniciales

  const Rewards({super.key});

  @override
  Widget build(BuildContext context) {
    double iconSize = kIsWeb ? 35 : 26; // Tamaño para íconos en web o móvil
    double fontSize = kIsWeb ? 20 : 15; // Tamaño para texto en web o móvil
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/points.svg',
                  height: iconSize,
                ),
                const SizedBox(width: 4),
                Text(
                  "$currentPoints pts", // Mostrar puntos actuales
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/tickets.svg',
                  height: iconSize,
                ),
                const SizedBox(width: 4),
                Text(
                  "12 tickets",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.help_outline,
                color: Color.fromRGBO(112, 105, 128, 1),
                size: iconSize,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Puedes canjear tus puntos por cualquiera de los siguientes productos! Cada semana aparecerán nuevos productos",
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time, // Ícono de reloj
                    size: iconSize,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Quedan 6 días, 8 horas, 2 minutos",
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Grid de productos
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: defaultPadding,
                  crossAxisSpacing: defaultPadding,
                  childAspectRatio: 0.66,
                ),
                itemCount: demoPopularProducts.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(0, 71, 71, 71),
                      border: Border.all(
                          color: const Color.fromARGB(255, 185, 185, 185)),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ProductCard(
                      image: demoPopularProducts[index].image,
                      brandName: demoPopularProducts[index].brandName,
                      title: demoPopularProducts[index].title,
                      price: demoPopularProducts[index].price,
                      priceAfetDiscount:
                          demoPopularProducts[index].priceAfetDiscount,
                      dicountpercent: demoPopularProducts[index].dicountpercent,
                      press: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
