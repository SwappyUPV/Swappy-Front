import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/Services/product.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  String title = '';
  String description = '';
  List<String> selectedStyles = [];
  List<String> selectedSizes = [];
  int? price;
  String quality = '';
  File? _image;
  String selectedCategory = '';

  List<String> predefinedStyles = [];
  List<String> predefinedSizes = [];
  List<String> clothingCategories = [];

  TextEditingController newStyleController = TextEditingController();
  TextEditingController newSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    ProductService().initializeDefaultStylesAndSizes();
  }

  Future<void> _loadInitialData() async {
    predefinedStyles = await _productService.getVerifiedStyles();
    clothingCategories = await _productService.getClothingCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un título';
                    }
                    return null;
                  },
                  onSaved: (value) => title = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onSaved: (value) => description = value ?? '',
                ),
                const SizedBox(height: 16),
                Text('Estilos:',
                    style: Theme.of(context).textTheme.titleMedium),
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
                        decoration: const InputDecoration(
                          labelText: 'Nuevo estilo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (newStyleController.text.isNotEmpty) {
                          setState(() {
                            selectedStyles.add(newStyleController.text);
                            _productService
                                .addNewStyle(newStyleController.text);
                            newStyleController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Categoría:',
                    style: Theme.of(context).textTheme.titleMedium),
                DropdownButtonFormField<String>(
                  value: selectedCategory.isNotEmpty ? selectedCategory : null,
                  items: clothingCategories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                      _loadSizes(selectedCategory);
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (selectedCategory.isNotEmpty) ...[
                  Text('Tallas:',
                      style: Theme.of(context).textTheme.titleMedium),
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: newSizeController,
                          decoration: const InputDecoration(
                            labelText: 'Nueva talla',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (newSizeController.text.isNotEmpty) {
                            setState(() {
                              selectedSizes.add(newSizeController.text);
                              _productService.addNewSize(
                                  newSizeController.text, selectedCategory);
                              newSizeController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => price = int.tryParse(value ?? ''),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Calidad',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese la calidad';
                    }
                    return null;
                  },
                  onSaved: (value) => quality = value!,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Seleccionar Imagen'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.file(_image!, height: 200, fit: BoxFit.cover),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadProduct,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Guardar Producto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadSizes(String category) async {
    predefinedSizes = await _productService.getVerifiedSizes(category);
    setState(() {});
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
        String result = await _productService.uploadProduct(
          title: title,
          description: description,
          styles: selectedStyles,
          sizes: selectedSizes,
          price: price!,
          quality: quality,
          image: _image!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );

        if (result.startsWith("Producto añadido con éxito")) {
          _formKey.currentState!.reset();
          setState(() {
            _image = null;
            selectedStyles.clear();
            selectedSizes.clear();
            selectedCategory = '';
          });

          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el producto: $e')),
        );
      }
    }
  }
}
