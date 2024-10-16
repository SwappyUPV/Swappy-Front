import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  List<String> selectedStyles = [];
  List<String> selectedSizes = [];
  int? price;
  String quality = '';
  File? _image;

  final List<String> predefinedStyles = [
    'Casual',
    'Formal',
    'Deportivo',
    'Elegante'
  ];
  final List<String> predefinedSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  TextEditingController newStyleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Añadir Producto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un título';
                    }
                    return null;
                  },
                  onSaved: (value) => title = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                  onSaved: (value) => description = value ?? '',
                ),
                const SizedBox(height: 20),
                const Text('Estilos:'),
                Wrap(
                  spacing: 8.0,
                  children: predefinedStyles.map((style) {
                    return FilterChip(
                      label: Text(style),
                      selected: selectedStyles.contains(style),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedStyles.add(style);
                          } else {
                            selectedStyles.remove(style);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: newStyleController,
                        decoration:
                            const InputDecoration(labelText: 'Nuevo estilo'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (newStyleController.text.isNotEmpty) {
                          setState(() {
                            selectedStyles.add(newStyleController.text);
                            // Aquí deberías registrar el nuevo estilo para revisión
                            registerNewStyleForReview(newStyleController.text);
                            newStyleController.clear();
                          });
                        }
                      },
                      child: const Text('Añadir'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Tallas:'),
                Wrap(
                  spacing: 8.0,
                  children: predefinedSizes.map((size) {
                    return FilterChip(
                      label: Text(size),
                      selected: selectedSizes.contains(size),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedSizes.add(size);
                          } else {
                            selectedSizes.remove(size);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => price = int.tryParse(value ?? ''),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Calidad'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese la calidad';
                    }
                    return null;
                  },
                  onSaved: (value) => quality = value!,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Seleccionar Imagen'),
                ),
                if (_image != null)
                  Image.file(_image!, height: 200, fit: BoxFit.cover),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadProduct,
                  child: const Text('Guardar Producto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerNewStyleForReview(String newStyle) {
    // Aquí deberías implementar la lógica para registrar el nuevo estilo en la base de datos
    // para su revisión posterior
    print('Nuevo estilo registrado para revisión: $newStyle');
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, seleccione una imagen')),
        );
        return;
      }

      _formKey.currentState!.save();

      try {
        // Subir imagen a Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('product_images/${DateTime.now().toIso8601String()}.jpg');
        await storageRef.putFile(_image!);
        final imageUrl = await storageRef.getDownloadURL();

        // Crear documento en Firestore
        await FirebaseFirestore.instance.collection('products').add({
          'title': title,
          'description': description,
          'styles': selectedStyles,
          'sizes': selectedSizes,
          'price': price,
          'quality': quality,
          'imageUrl': imageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto guardado exitosamente')),
        );

        // Limpiar el formulario
        _formKey.currentState!.reset();
        setState(() {
          _image = null;
          selectedStyles.clear();
          selectedSizes.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el producto: $e')),
        );
      }
    }
  }
}
