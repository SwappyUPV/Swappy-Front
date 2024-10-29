import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../home/components/user_header.dart';
import 'components/item_grid.dart';
import 'components/item_card.dart';

class Exchanges extends StatefulWidget {
  const Exchanges({
    super.key,
    required this.isNew,
    required this.selectedProduct,
  });

  final bool isNew;
  final Map<String, dynamic> selectedProduct;

  @override
  ExchangesState createState() => ExchangesState();
}

class ExchangesState extends State<Exchanges> {
  bool hasChanges =
      false; // Indica si se ha realizado algún cambio (agregar o eliminar)
  List<Map<String, dynamic>> modifiedItems =
      List.from(products); // Lista temporal para los cambios

  @override
  void initState() {
    super.initState();
    _validateInputs();
  }

  void _validateInputs() {
    if (widget.isNew) {
      if (widget.selectedProduct.isEmpty) {
        throw ArgumentError(
            'Se requiere un producto seleccionado para nuevo intercambio');
      }
    }
    // else {
    //   if (widget.exchangeId == null) {
    //     throw ArgumentError(
    //         'Se requiere ID de intercambio para intercambios existentes');
    //   }
    // }
  }

  void _removeItem(int id) {
    setState(() {
      modifiedItems.removeWhere((item) => item["id"] == id);
      hasChanges = true; // Marcar como cambiado
    });
  }

  void _confirmChanges() {
    setState(() {
      products.clear();
      products.addAll(modifiedItems);
      hasChanges = false; // Resetear cambios
    });
  }

  void _cancelChanges() {
    setState(() {
      modifiedItems = List.from(products); // Reiniciar cambios
      hasChanges = false; // Resetear cambios
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // UserHeader para mí
            const UserHeader(
              nombreUsuario: "Nicolas Maduro",
              fotoUrl: "assets/images/bag_1.png",
              esMio: true,
            ),
            // Cuadrícula de mis items con botón de agregar
            ItemGrid(
              items: modifiedItems,
              onRemoveItem: _removeItem,
              onDeleteItem: (Map<String, dynamic> product) {
                setState(() {
                  modifiedItems.remove(product);
                  hasChanges = true;
                });
              },
              showButtons: widget.isNew,
              showAddButton:
                  true, // Nuevo parámetro para mostrar el botón de agregar
            ),
            // Línea de intercambio con ícono
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
            // UserHeader para otro usuario
            const UserHeader(
              nombreUsuario: "Putin",
              fotoUrl: "assets/images/bag_1.png",
              esMio: false,
            ),
            const SizedBox(height: 20), // Espacio antes de los botones

            // Mostrar el producto seleccionado si es nuevo intercambio
            if (widget.isNew) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Producto seleccionado:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ItemCard(
                  press: () {},
                  onDelete: () {},
                  product: {
                    "id": widget.selectedProduct['id'],
                    "title": widget.selectedProduct['title'],
                    "price": widget.selectedProduct['price'],
                    "size": widget.selectedProduct['size'],
                    "description": widget.selectedProduct['description'],
                    "image": widget.selectedProduct['image'],
                  },
                  showDeleteButton: false,
                ),
              ),
            ],

            // Botones al final
            Center(
              child: Column(
                children: [
                  // Mostrar botones "Enviar contrapropuesta" y Cancelar
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Confirmar cambios siempre activo
                          _confirmChanges();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: Text(hasChanges
                            ? "Enviar contrapropuesta" // Cambia el texto si hay cambios
                            : "Confirmar"), // Texto por defecto
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
            const SizedBox(
                height: 20), // Margen para separar los botones del final
          ],
        ),
      ),
    );
  }
}
