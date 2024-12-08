import 'package:flutter/material.dart';

class FilterRowWidget extends StatefulWidget {
  final String type; // 'precio', 'calidad', 'categoria'

  const FilterRowWidget({
    Key? key,
    required this.type, // Tipo: 'precio', 'calidad', 'categoria'
  }) : super(key: key);

  @override
  _FilterRowWidgetState createState() => _FilterRowWidgetState();
}

class _FilterRowWidgetState extends State<FilterRowWidget> {
  String? _selectedCategory;
  String? _selectedQuality;
  bool _isExchangeOnly = false;
  TextEditingController _priceController = TextEditingController();
  final List<String> _categories = ['Ropa', 'Electrónica', 'Hogar'];
  final List<String> _qualityOptions = ['Alta', 'Media', 'Baja'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPopup(context); // Muestra el popup cuando se toca el widget
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.type.toUpperCase(),
            ),
            Icon(Icons.arrow_right), // Siempre mostrar la flecha
          ],
        ),
      ),
    );
  }

  // Método para mostrar el popup
  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona ${widget.type}'),
          content: _buildPopupContent(),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cerrar el popup
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  // Construye el contenido del popup dependiendo del tipo
  Widget _buildPopupContent() {
    switch (widget.type) {
      case 'categoria':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: _categories
              .map((category) => ListTile(
                    title: Text(category),
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.of(context).pop(); // Cerrar el popup
                    },
                  ))
              .toList(),
        );
      case 'precio':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Solo intercambio'),
                Checkbox(
                  value: _isExchangeOnly,
                  onChanged: (value) {
                    setState(() {
                      _isExchangeOnly = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ],
        );
      case 'calidad':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: _qualityOptions
              .map((quality) => ListTile(
                    title: Text(quality),
                    onTap: () {
                      setState(() {
                        _selectedQuality = quality;
                      });
                      Navigator.of(context).pop(); // Cerrar el popup
                    },
                  ))
              .toList(),
        );
      default:
        return SizedBox.shrink(); // Fallback
    }
  }
}
