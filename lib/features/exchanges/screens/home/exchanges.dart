import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/details/components/confirmation.dart';
import '../home/components/user_header.dart';
import 'package:pin/core/services/exchange_service.dart';
import 'components/item_grid.dart';
import 'package:pin/features/profile/presentation/screens/profile_screen.dart';
import 'package:pin/features/rewards/rewards.dart'; // Asegúrate de importar Rewards

class Exchanges extends StatefulWidget {
  final Product? selectedProduct;
  final String? userId;
  final String? chatId;

  const Exchanges({
    super.key,
    this.selectedProduct,
    this.userId,
    this.chatId,
  });

  @override
  ExchangesState createState() => ExchangesState();
}

class ExchangesState extends State<Exchanges> {
  bool hasResponded = false;
  bool hasChanges = false;
  List<Product> modifiedItems = List.from(products);
  final ExchangeService _exchangeService = ExchangeService();

  Future<void> _createExchange(userId, chatId) async {
    String receiverId = userId;
    String exchangeId = await _exchangeService.createExchange(
      senderId: userId!,
      receiverId: receiverId,
      itemsOffered: [], // Pueden estar vacíos por ahora
      itemsRequested: [],
    );

    await _exchangeService.notifyNewExchange(userId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Intercambio creado con éxito")),
    );
  }

  void _addItem() {
    setState(() {
      modifiedItems.add(Product(
        id: "1",
        title: "Office Code",
        price: 234,
        size: "12",
        description: dummyText,
        image: "assets/images/bag_1.png",
        color: const Color(0xFF3D82AE),
        category: "Bags",
        isExchangeOnly: false,
        styles: ["Office", "Code"],
        quality: "New",
      ));
      hasChanges = true;
    });
  }

  void _removeItem(int id) {
    setState(() {
      modifiedItems.removeWhere((item) => item.id == id);
      hasChanges = true;
    });
  }

  void _confirmChanges() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Intercambio'),
          content: const Text('¿Estás seguro de realizar este intercambio?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo sin hacer nada
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _createExchange(widget.userId!, widget.chatId!);
                setState(() {
                  products.clear();
                  products.addAll(modifiedItems);
                  hasChanges = false;
                  hasResponded = false;

                  // Sumar puntos de intercambio
                  Rewards.currentPoints += 200;
                });
                Navigator.of(context).pop();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ConfirmationScreen(
                      title: 'Intercambio Confirmado',
                      description: 'El intercambio se ha completado con éxito.',
                      image: 'assets/images/Help_lightTheme.png',
                    ),
                  ),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _cancelChanges() {
    setState(() {
      modifiedItems = List.from(products);
      hasChanges = false;
      hasResponded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;
    final double maxWidth = isWeb
        ? 500.0
        : MediaQuery.of(context).size.width * 0.7; // 70% del ancho en móvil
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
                  "200 pts",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
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
                  "2 tickets",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
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
                      "Estos son los puntos y tickets que vas a ganar por el intercambio! Luego puedes canjearlos por premios en la tienda de regalos de tu perfil",
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const UserHeader(
              nombreUsuario: "Nicolas Maduro",
              fotoUrl: "assets/images/user_2.png",
              esMio: true,
            ),
            ItemGrid(
              items: modifiedItems,
              onRemoveItem: hasResponded ? _removeItem : null,
              onAddItem: hasResponded ? _addItem : null,
              onDeleteItem: (Product product) {
                setState(() {
                  modifiedItems.remove(product);
                  hasChanges = true;
                });
              },
              showButtons: hasResponded,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(child: Divider()),
                  Icon(Icons.swap_horiz, size: 32),
                  Expanded(child: Divider()),
                ],
              ),
            ),
            const UserHeader(
              nombreUsuario: "Putin",
              fotoUrl: "assets/images/user_3.png",
              esMio: false,
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  if (!hasResponded)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: maxWidth,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                hasResponded = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 16),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: const Text("Responder"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Declinar",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: maxWidth,
                          child: ElevatedButton(
                            onPressed: _confirmChanges,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: Text(hasChanges
                                ? "Enviar contrapropuesta"
                                : "Confirmar"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: _cancelChanges,
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
