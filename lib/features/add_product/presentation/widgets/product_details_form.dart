import 'package:flutter/material.dart';

class ProductDetailsForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  const ProductDetailsForm({
    Key? key,
    required this.nameController,
    required this.descriptionController,
  }) : super(key: key);

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
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'ej., Camiseta Blanca Nike',
              hintStyle: TextStyle(
                color: Color(0x80000000),
                fontFamily: 'OpenSans',
                fontSize: 14,
              ),
              border: UnderlineInputBorder(),
            ),
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
            controller: descriptionController,
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
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}