import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin/core/services/chat_service.dart';
import 'package:pin/features/exchanges/models/Exchange.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/details/components/confirmation.dart';
import 'package:pin/features/virtual_closet/presentation/screens/change_clothes_screen.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';
import '../home/components/user_header.dart';
import 'package:pin/core/services/exchange_service.dart';
import 'components/item_grid.dart';
import 'package:pin/features/profile/presentation/screens/profile_screen.dart';
import 'package:pin/features/rewards/rewards.dart'; // Asegúrate de importar Rewards
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin/core/services/catalogue.dart';

class Exchanges extends StatefulWidget {
  final Product? selectedProduct;
  final String? exchangeId;
  final String? receiverId;

  const Exchanges(
      {super.key, this.selectedProduct, this.exchangeId, this.receiverId});

  @override
  ExchangesState createState() => ExchangesState();
}

class ExchangesState extends State<Exchanges> {
  bool hasResponded = false;
  bool hasChanges = false;
  String? currentUserId;
  String? receiverUserId;
  String? currentUserName;
  String? receiverUserName;
  String? UserName;
  String? urlUser;
  bool isOther = false;
  String? urlReceiver;
  bool isNewExchange = true;
  bool isOwner = false;
  bool pinga = true;
  List<Product> modifiedItems = [];
  List<Product> otherItems = [];
  Product? selectedProduct;
  final ExchangeService _exchangeService = ExchangeService();
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _loadUserIds();
    isNewExchange = widget.exchangeId == null;
    if (widget.selectedProduct != null) {
      setState(() {
        otherItems.add(widget.selectedProduct!);
      });
    }
    if (widget.exchangeId != null) {
      _loadListas();
    }
    print(isOther);
  }

  Future<void> _loadListas() async {
    Exchange cambio = await _exchangeService
        .getExchangeById(widget.exchangeId.toString()) as Exchange;

    setState(() {
      receiverUserId = cambio.receiverId;
    });

    List<String> modifiedItemsList = cambio.itemsOffered;
    List<String> otherItemsList = cambio.itemsRequested;
    print(modifiedItemsList);
    print(otherItemsList);

    // Asegurarse de que currentUserId no sea null
    if (currentUserId == null) {
      print("Error: currentUserId es null");
      return;
    }

    if (cambio.senderId == currentUserId) {
      setState(() {
        isOwner = true;
      });
      getProductsByIdsMoodified(modifiedItemsList);
      getProductsByIdsOther(otherItemsList);
    } else {
      setState(() {
        this.isOther = true;
        receiverUserId = cambio.senderId;
      });
      getProductsByIdsMoodified(otherItemsList);
      getProductsByIdsOther(modifiedItemsList);
    }

    _NameUser();
    _ImgUser();
    _NameReceiver();
    _ImgReceiver();

    print("isOther: $isOther");
  }

  Future<void> getProductsByIdsMoodified(List<String> clothesIds) async {
    List<Product> clothes = [];
    for (var id in clothesIds) {
      Product? cloth = await CatalogService().getClothById(id);
      print(cloth!.category);
      clothes.add(cloth!);
    }
    setState(() {
      modifiedItems = clothes;
    });
  }

  Future<void> getProductsByIdsOther(List<String> clothesIds) async {
    List<Product> clothes = [];
    for (var id in clothesIds) {
      Product? cloth = await CatalogService().getClothById(id);
      clothes.add(cloth!);
    }
    setState(() {
      otherItems = clothes;
    });
  }

  Future<void> _loadUserIds() async {
    String? userId = await _chatService.getUserId();

    setState(() {
      currentUserId = userId;
      receiverUserId = widget.receiverId;
    });
    _NameUser();
    _NameReceiver();
    _ImgUser();
    _ImgReceiver();
  }

  Future<void> _NameUser() async {
    try {
      String name1 = '';
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: [currentUserId])
          .get()
          .then((QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              var name = querySnapshot
                  .docs.first['name']; // Accessing the 'name' field
              name1 = name;
            }
          });

      setState(() {
        currentUserName = name1;
      });
    } catch (e) {
      print("Error al obtener datos de Firebase (Top): $e");
    }
  }

  Future<void> _NameReceiver() async {
    try {
      String name1 = '';
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: [receiverUserId])
          .get()
          .then((QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              var name = querySnapshot
                  .docs.first['name']; // Accessing the 'name' field
              name1 = name;
            }
          });

      setState(() {
        receiverUserName = name1;
      });
    } catch (e) {
      print("Error al obtener datos de Firebase (Top): $e");
    }
  }

  Future<void> _ImgUser() async {
    try {
      String url1 = '';
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: [currentUserId])
          .get()
          .then((QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              var url = querySnapshot.docs.first[
                  'profilePicture']; // Accessing the 'profilePicture' field
              url1 = url;
            }
          });

      setState(() {
        urlUser = url1;
      });
    } catch (e) {
      print("Error al obtener datos de Firebase (Top): $e");
    }
  }

  Future<void> _ImgReceiver() async {
    try {
      String url1 = '';
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: [receiverUserId])
          .get()
          .then((QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              var url = querySnapshot.docs.first[
                  'profilePicture']; // Accessing the 'profilePicture' field
              url1 = url;
            }
          });

      setState(() {
        urlReceiver = url1;
      });
    } catch (e) {
      print("Error al obtener datos de Firebase (Top): $e");
    }
  }

  Future<String> _getUser() async {
    String? userId = await _chatService.getUserId();
    return userId ??
        ''; // Asegúrate de retornar un valor válido en caso de null
  }

  Future<void> _createExchange() async {
    if (isOther) {
      await _exchangeService.cancelExchange(widget.exchangeId!);
    }
    // Obtener el userId si es necesario
    String? senderId = await _chatService.getUserId();
    String? receiverId = receiverUserId;
    List<String> itemsOfferedIds = [];
    List<String> itemsRequestedIds = [];
    for (var producto in modifiedItems) {
      itemsOfferedIds.add(producto.id);
    }
    for (var producto in otherItems) {
      itemsRequestedIds.add(producto.id);
    }

    // Crear un nuevo intercambio si no existe exchangeId

    final newExchange = await _exchangeService.createExchange(
      senderId: senderId!,
      receiverId: receiverId ?? '',
      itemsOffered: itemsOfferedIds,
      itemsRequested: itemsRequestedIds,
      status: 'pendiente',
    );

    if (newExchange != null) {
      /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Intercambio creado con éxito")),
      ) */;
      setState(() {
        // Actualizar el estado si es necesario
        isNewExchange = false; // Ahora ya no es un intercambio nuevo
      });

      await _exchangeService.notifyNewExchange(receiverId ?? '');
    } else {
      // Obtener intercambio si exchangeId existe
      _exchangeService
          .getExchangeById(widget.exchangeId!)
          .then((dataExchange) async {
        if (dataExchange != null) {
         /*  ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Intercambio obtenido con éxito")),
          ); */
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
        builder: (context) => ChangeClothes(
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

  void _cancelExchange() async {
    // Esperamos la respuesta del usuario en el diálogo
    bool? confirmado = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar cancelación'),
          content: const Text(
              '¿Estás seguro de que quieres cancelar este intercambio?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Regresamos 'false' si el usuario cancela
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Realizar la cancelación del intercambio
                await _exchangeService.cancelExchange(widget.exchangeId!);
                Navigator.of(context)
                    .pop(true); // Regresamos 'true' si el usuario confirma
              },
              child: const Text('Sí, cancelar'),
            ),
          ],
        );
      },
    );

    // Si el usuario confirma la cancelación (confirmado == true), navega a la pantalla de confirmación
    if (confirmado == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ConfirmationScreen(
            title: 'Intercambio cancelado',
            description: 'El intercambio ha sido cancelado.',
            image: 'assets/images/Help_lightTheme.png',
          ),
        ),
      );
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pop();
    }
  }

  Future<void> _doTrade() async {
    await doTrade1();

    await _exchangeService.cancelExchange(widget.exchangeId!);
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ConfirmationScreen(
          title: 'Intercambio completado',
          description: 'El intercambio ha sido completado.',
          image: 'assets/images/Help_lightTheme.png',
        ),
      ),
    );
  }

  Future<void> doTrade1() async {
    for (var producto in modifiedItems) {
      /*print("ID del producto: ${producto.id}");
      try {
        // Realizar la consulta en la colección 'users'
        final snapshot = await FirebaseFirestore.instance
            .collection('clothes')
            .where('id', isEqualTo: producto.id)
            .get();

        // Verificar si hay documentos que coincidan
        if (snapshot.docs.isNotEmpty) {
          print("culo");
          // Accedemos al primer documento y actualizamos el campo 'uid' con el nuevo valor
          await FirebaseFirestore.instance
              .collection('clothes')
              .doc(snapshot.docs.first.id)  // Usamos el id del primer documento encontrado
              .update({
            'userId': receiverUserId,  // Actualizamos el campo 'uid'
          });

          print("userId actualizado correctamente.");
        } else {
          print("No se encontró el usuario con el uid proporcionado.");
        }
      } catch (e) {
        print("Error al actualizar el userId: $e");
      }*/
      await updateUserIdByClothesId(producto.id, receiverUserId!);
    }
    for (var producto in otherItems) {
      /*
      print("ID del producto: ${producto.id}");
      try {
        // Realizar la consulta en la colección 'users'
        final snapshot = await FirebaseFirestore.instance
            .collection('clothes')
            .where('id', isEqualTo: producto.id)
            .get();

        // Verificar si hay documentos que coincidan
        if (snapshot.docs.isNotEmpty) {
          // Accedemos al primer documento y actualizamos el campo 'uid' con el nuevo valor
          await FirebaseFirestore.instance
              .collection('clothes')
              .doc(snapshot.docs.first.id)  // Usamos el id del primer documento encontrado
              .update({
            'userId': currentUserId,  // Actualizamos el campo 'uid'
          });

          print("userId actualizado correctamente.");
        } else {
          print("No se encontró el usuario con el uid proporcionado.");
        }
      } catch (e) {
        print("Error al actualizar el userId: $e");
      }
    */
      await updateUserIdByClothesId(producto.id, currentUserId!);
    }
  }

  Future<void> updateUserIdByClothesId(
      String clothesId, String newUserId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference docRef =
        firestore.collection('clothes').doc(clothesId);

    try {
      await docRef.update({'userId': newUserId});
      print('userId actualizado correctamente.');
    } catch (e) {
      print('Error al actualizar userId: $e');
    }
  }

  void _confirmChanges() async {
    // Mostrar el diálogo y esperar la respuesta del usuario
    bool? confirmado = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Intercambio'),
          content: const Text('¿Estás seguro de realizar este intercambio?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Enviar 'false' si el usuario cancela
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
                Navigator.of(context)
                    .pop(true); // Enviar 'true' si el usuario confirma
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    // Si el usuario confirma (confirmado == true), navega a la pantalla de confirmación
    if (confirmado == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ConfirmationScreen(
            title: 'Intercambio Confirmado',
            description: 'El intercambio se ha enviado con éxito.',
            image: 'assets/images/Help_lightTheme.png',
          ),
        ),
      );
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pop();
    }
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
            UserHeader(
              nombreUsuario: currentUserName ?? "Usuario1",
              fotoUrl: urlUser ?? "assets/images/user_2.png",
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
              showButtons: isOther || isNewExchange,
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
            UserHeader(
              nombreUsuario: receiverUserName ?? "Usuario2",
              fotoUrl: urlReceiver ?? "assets/images/user_2.png",
              esMio: false,
            ),
            ItemGrid(
              items: otherItems,
              onAddItem: (List<Product> selectedProducts) {
                setState(() {
                  otherItems.addAll(selectedProducts);
                  hasChanges = true;
                });
              },
              onDeleteItem: (Product product) {
                setState(() {
                  otherItems.remove(product);
                  hasChanges = true;
                });
              },
              showButtons: isOther || isNewExchange,
              id: receiverUserId,
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  if (isOther || isNewExchange)
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
                            child: Text(isOther
                                ? "Enviar contrapropuesta"
                                : "Confirmar"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (isOther) // Solo muestra el botón "Aceptar Cambio" si isOther es true
                          TextButton(
                            onPressed: _doTrade,
                            child: const Text(
                              "Aceptar intercambio",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
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
