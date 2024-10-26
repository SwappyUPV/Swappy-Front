import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../home/components/user_header.dart';
import 'components/item_grid.dart';

class Exchanges extends StatefulWidget {
  const Exchanges({super.key});

  @override
  ExchangesState createState() => ExchangesState();
}

class ExchangesState extends State<Exchanges> {
  bool hasResponded =
      false; // Controla la visibilidad de los botones Responder/Confirmar
  bool hasChanges =
      false; // Indica si se ha realizado algún cambio (agregar o eliminar)
  List<Product> modifiedItems =
      List.from(products); // Lista temporal para los cambios

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
      hasChanges = true; // Marcar como cambiado
    });
  }

  void _removeItem(int id) {
    setState(() {
      modifiedItems.removeWhere((item) => item.id == id);
      hasChanges = true; // Marcar como cambiado
    });
  }

  void _confirmChanges() {
    setState(() {
      products.clear();
      products.addAll(modifiedItems);
      hasChanges = false; // Resetear cambios
      hasResponded = false; // Volver al estado inicial
    });
  }

  void _cancelChanges() {
    setState(() {
      modifiedItems = List.from(products); // Reiniciar cambios
      hasChanges = false; // Resetear cambios
      hasResponded = false; // Volver al estado inicial
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
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
            // Cuadrícula de mis items con botón 'X' en cada ItemCard y botón '+' en la cuadrícula
            ItemGrid(
              items: modifiedItems,
              onRemoveItem: hasResponded ? _removeItem : null,
              onAddItem: hasResponded ? _addItem : null,
              onDeleteItem: (Product product) {
                setState(() {
                  modifiedItems.remove(product);
                  hasChanges = true; // Marcar como cambiado
                });
              },
              showButtons: hasResponded,
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

            // Botones al final
            Center(
              child: Column(
                children: [
                  if (!hasResponded)
                    // Mostrar botones Responder y Declinar
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              hasResponded = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Responder"),
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
