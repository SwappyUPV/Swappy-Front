import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin/core/services/chat_service.dart';
import 'package:pin/features/exchanges/models/Exchange.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/details/components/confirmation.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';
import '../home/components/user_header.dart';
import 'package:pin/core/services/exchange_service.dart';
import 'components/item_grid.dart';
import 'package:pin/features/profile/presentation/screens/profile_screen.dart';
import 'package:pin/features/rewards/rewards.dart'; // Asegúrate de importar Rewards

class Exchanges extends StatefulWidget {
  final Product? selectedProduct;
  final String? exchangeId;
  final String? receiverId;

  const Exchanges({
    super.key,
    this.selectedProduct,
    this.exchangeId,
    this.receiverId,
  });

  @override
  ExchangesState createState() => ExchangesState();
}

class ExchangesState extends State<Exchanges> {
  bool hasResponded = false;
  bool hasChanges = false;
  String? currentUserId;
  bool isNewExchange =
      false; // Nueva variable para identificar si es un nuevo intercambio
  bool isOwner = false;
  List<Product> modifiedItems = [];
  Product? selectedProduct;
  final ExchangeService _exchangeService = ExchangeService();
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _loadUserId();
    isNewExchange = widget.exchangeId == null || widget.exchangeId!.isEmpty;
    selectedProduct = widget.selectedProduct;
  }

  Future<void> _loadUserId() async {
    String? userId = await _chatService.getUserId();
    setState(() {
      currentUserId = userId;
    });
  }

  Future<String> _getUser() async {
    String? userId = await _chatService.getUserId();
    return userId ??
        ''; // Asegúrate de retornar un valor válido en caso de null
  }

  Future<void> _createExchange() async {
    // Obtener el userId si es necesario
    String? senderId = await _chatService.getUserId();

    // Crear un nuevo intercambio si no existe exchangeId
    if (isNewExchange) {
      final newExchange = await _exchangeService.createExchange(
        senderId: senderId!,
        receiverId: widget.receiverId ?? '',
        itemsOffered: [],
        itemsRequested: [],
      );

      if (newExchange != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Intercambio creado con éxito")),
        );
        setState(() {
          // Actualizar el estado si es necesario
          isNewExchange = false; // Ahora ya no es un intercambio nuevo
        });

        if (widget.receiverId != null) {
          await _exchangeService.notifyNewExchange(widget.receiverId!);
        }
      }
    } else {
      // Obtener intercambio si exchangeId existe
      _exchangeService
          .getExchangeById(widget.exchangeId!)
          .then((dataExchange) async {
        if (dataExchange != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Intercambio obtenido con éxito")),
          );
          setState(() {
            // Actualizar el estado con los datos del intercambio
          });

          if (dataExchange.receiverId != null) {
            await _exchangeService.notifyNewExchange(dataExchange.receiverId);
          }
        }
      });
    }
  }

  void _addItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VirtualCloset(
          fromExchange: true,
        ), // Aquí debes asegurarte de implementar VirtualCloset.
      ),
    );
  }

  void _removeItem(int id) {
    setState(() {
      modifiedItems.removeWhere((item) => item.id == id);
      hasChanges = true;
    });
  }

  void _cancelExchange() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar cancelación'),
          content: const Text(
              '¿Estás seguro de que quieres cancelar este intercambio?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _exchangeService.cancelExchange(widget.exchangeId!);
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ConfirmationScreen(
                      title: 'Intercambio cancelado',
                      description: 'El intercambio ha sido cancelado.',
                      image: 'assets/images/Help_lightTheme.png',
                    ),
                  ),
                );
              },
              child: const Text('Sí, cancelar'),
            ),
          ],
        );
      },
    );
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
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _createExchange();
                setState(() {
                  products.clear();
                  products.addAll(modifiedItems);
                  hasChanges = false;
                  hasResponded = false;
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;
    final double maxWidth =
        isWeb ? 500.0 : MediaQuery.of(context).size.width * 0.7;
    double iconSize = kIsWeb ? 35 : 26;
    double fontSize = kIsWeb ? 20 : 15;

    if (currentUserId == null) {
      // El userId no está disponible todavía, podrías mostrar un loader
      return Center(child: CircularProgressIndicator());
    }

    // Ahora que tienes el currentUserId, puedes usarlo para la lógica
    bool isSender =
        widget.exchangeId != null && widget.receiverId != currentUserId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Código de puntos y tickets
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
              onAddItem: (List<Product> selectedProducts) {
                setState(() {
                  modifiedItems.addAll(selectedProducts);
                  hasChanges = true;
                });
              },
              onDeleteItem: (Product product) {
                setState(() {
                  modifiedItems.remove(product);
                  hasChanges = true;
                });
              },
              showButtons: hasResponded || isNewExchange,
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
                  if (isNewExchange || hasResponded)
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
                    )
                  else if (isSender) // Si es el usuario que envió el intercambio
                    Column(
                      children: [
                        SizedBox(
                          width: maxWidth,
                          child: ElevatedButton(
                            onPressed: _cancelExchange,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: const Text("Cancelar intercambio"),
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
