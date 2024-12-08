import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String label;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType keyboardType;
  final String? placeholder; // Texto de ejemplo opcional
  final bool
      enableCharacterCounter; // Habilita o deshabilita el contador de caracteres
  final int maxLength; // Longitud máxima del texto

  const CustomTextFieldWidget({
    Key? key,
    required this.label,
    required this.onSaved,
    this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.placeholder,
    this.enableCharacterCounter = false,
    this.maxLength = 1000, // Valor por defecto de longitud máxima
  }) : super(key: key);

  @override
  _CustomTextFieldWidgetState createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        // Campo de texto
        TextFormField(
          controller: _controller,
          maxLength: widget.enableCharacterCounter ? widget.maxLength : null,
          decoration: InputDecoration(
            hintText: widget.placeholder ?? '',
            hintStyle: TextStyle(color: Colors.grey), // Texto de ejemplo gris
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onSaved: widget.onSaved,
          onChanged:
              widget.enableCharacterCounter ? (text) => setState(() {}) : null,
        ),
        // Contador de caracteres
      ],
    );
  }
}
