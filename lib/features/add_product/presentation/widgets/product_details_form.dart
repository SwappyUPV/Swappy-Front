import 'package:flutter/material.dart';

class ProductDetailsForm extends StatefulWidget {
  final String initialName;
  final String initialDescription;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;

  const ProductDetailsForm({
    Key? key,
    required this.initialName,
    required this.initialDescription,
    required this.onNameChanged,
    required this.onDescriptionChanged,
  }) : super(key: key);

  @override
  State<ProductDetailsForm> createState() => _ProductDetailsFormState();
}

class _ProductDetailsFormState extends State<ProductDetailsForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descriptionController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Nombre',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'UrbaneMedium',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(height: 22),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'ej., Camiseta Blanca Nike',
              hintStyle: TextStyle(
                color: Color(0x80000000),
                fontFamily: 'OpenSans',
                fontSize: 14,
              ),
              border: UnderlineInputBorder(),
            ),
            onChanged: widget.onNameChanged,
          ),
          const SizedBox(height: 27),
          const Text(
            'Descripción',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'UrbaneMedium',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _descriptionController,
            maxLength: 1000,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'ej., con etiqueta, a estrenar, busco intercambiar por unas zapatillas',
              hintStyle: TextStyle(
                color: Color(0x80000000),
                fontFamily: 'OpenSans',
                fontSize: 14,
              ),
              border: UnderlineInputBorder(),
            ),
            onChanged: widget.onDescriptionChanged,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}