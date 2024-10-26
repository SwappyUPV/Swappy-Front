import 'package:flutter/material.dart';

class ProductDetailModal extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailModal({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool soloIntercambio = product['soloIntercambio'] ?? false;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            product['nombre'],
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          if (product['descripcion'] != null) ...[
            Text(
              product['descripcion'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
          ],
          Text('Categoría: ${product['categoria']}'),
          Text('Talla: ${product['tallas'].join(', ')}'),
          Text('Vendedor: ${product['userId']}'),
          if (!soloIntercambio) Text('Precio: ${product['precio']}€'),
          Text(soloIntercambio
              ? 'Solo acepta intercambio'
              : 'Acepta compra e intercambio'),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!soloIntercambio)
                ElevatedButton(
                  onPressed: () {
                    // Lógica para enviar oferta de compra
                  },
                  child: Text('Ofertar compra'),
                ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para enviar oferta de intercambio
                },
                child: Text('Ofertar intercambio'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
