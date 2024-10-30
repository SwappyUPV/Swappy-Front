import 'package:flutter/material.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import '../home/components/user_header.dart';
import 'components/item_grid.dart';

class Exchanges extends StatefulWidget {
  const Exchanges({super.key});

  @override
  ExchangesState createState() => ExchangesState();
}

class ExchangesState extends State<Exchanges> {
  bool hasResponded = false;
  bool hasChanges = false;
  List<Product> modifiedItems = List.from(products);

  void _addItem() {
    setState(() {
      modifiedItems.add(Product(
        id: 1,
        title: "Office Code",
        price: 234,
        size: 12,
        description: dummyText,
        image: "assets/images/bag_1.png",
        color: const Color(0xFF3D82AE),
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

  void _confirmChanges() {
    setState(() {
      products.clear();
      products.addAll(modifiedItems);
      hasChanges = false;
      hasResponded = false;
    });
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // UserHeader para mí
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
