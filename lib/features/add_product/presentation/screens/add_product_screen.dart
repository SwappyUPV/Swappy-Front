import 'package:flutter/material.dart';
import 'package:pin/features/CustomAppBar.dart';
import '../widgets/add_product_form.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'SUBE UNA PRENDA',
        iconPath: 'assets/icons/back.svg',
        // Llama a Navigator.pop para regresar a la pantalla anterior
        onIconPressed: () {},
        iconPosition: IconPosition.left, // Para icono a la izquierda
      ),
      body: Container(
        color: Color.fromARGB(255, 12, 2, 2), // Fondo gris claro
        child: SingleChildScrollView(
          child: AddProductForm(),
        ),
      ),
    );
  }
}
