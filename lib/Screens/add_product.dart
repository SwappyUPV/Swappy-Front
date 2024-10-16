import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/Services/product.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '/Screens/catalogue.dart'; // Añade esta línea al principio del archivo

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
  String? selectedQuality;
  dynamic _pickedImage;
  String selectedCategory = '';

  List<String> predefinedStyles = [];
  List<String> predefinedSizes = [];
  List<String> clothingCategories = [];

  bool _isLoading = true;
  bool isExchangeOnly = false;

  final List<String> qualityOptions = [
    'Nuevo',
    'Seminuevo',
    'Algo utilizado',
    'Bastante usado',
    'Muy desgastado'
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _loadInitialData();
    } catch (e) {
      print('Error al cargar datos iniciales: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadInitialData() async {
    predefinedStyles = await _productService.getVerifiedStyles();
    clothingCategories = await _productService.getClothingCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Cargando...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                _buildTextField(
                  label: 'Título*',
                  onSaved: (value) => title = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Descripción',
                  onSaved: (value) => description = value ?? '',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildStylesSection(),
                const SizedBox(height: 16),
                _buildCategoryDropdown(),
                const SizedBox(height: 16),
                if (selectedCategory.isNotEmpty) _buildSizesSection(),
                const SizedBox(height: 16),
                _buildPriceSection(),
                const SizedBox(height: 16),
                _buildQualitySection(),
                const SizedBox(height: 20),
                _buildImageSection(),
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

  Widget _buildTextField({
    required String label,
    required Function(String?) onSaved,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildStylesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Estilos:', style: Theme.of(context).textTheme.titleMedium),
        Wrap(
          spacing: 8.0,
          children: [
            ...predefinedStyles
                .map((style) => _buildChip(style, selectedStyles)),
            ...selectedStyles
                .where((style) => !predefinedStyles.contains(style))
                .map((style) =>
                    _buildChip('$style (en revisión)', selectedStyles)),
          ],
        ),
        TextButton.icon(
          icon: Icon(Icons.add),
          label: Text('Añadir nuevo estilo'),
          onPressed: () => _showAddDialog('estilo'),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Categoría*',
        border: OutlineInputBorder(),
      ),
      value: selectedCategory.isNotEmpty ? selectedCategory : null,
      items: clothingCategories.map((category) {
        return DropdownMenuItem(value: category, child: Text(category));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value!;
          _loadSizes(selectedCategory);
        });
      },
      validator: (value) =>
          value == null ? 'Por favor, seleccione una categoría' : null,
    );
  }

  Widget _buildSizesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tallas:', style: Theme.of(context).textTheme.titleMedium),
        Wrap(
          spacing: 8.0,
          children: [
            ...predefinedSizes.map((size) => _buildChip(size, selectedSizes)),
            ...selectedSizes
                .where((size) => !predefinedSizes.contains(size))
                .map(
                    (size) => _buildChip('$size (en revisión)', selectedSizes)),
          ],
        ),
        TextButton.icon(
          icon: Icon(Icons.add),
          label: Text('Añadir nueva talla'),
          onPressed: () => _showAddDialog('talla'),
        ),
      ],
    );
  }

  Widget _buildChip(String label, List<String> selectedList) {
    final isSelected = selectedList.contains(label.split(' ').first);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedList.add(label.split(' ').first);
          } else {
            selectedList.remove(label.split(' ').first);
          }
        });
      },
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Seleccionar Imagen'),
        ),
        if (_pickedImage != null)
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: kIsWeb
                ? Image.network(_pickedImage.path)
                : Image.file(_pickedImage),
          ),
      ],
    );
  }

  void _showAddDialog(String type) {
    String newValue = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir nuevo ${type}'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "Introduce el nuevo ${type}"),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Añadir'),
              onPressed: () {
                if (newValue.isNotEmpty) {
                  setState(() {
                    if (type == 'estilo') {
                      selectedStyles.add(newValue);
                      _productService.addNewStyle(newValue);
                    } else if (type == 'talla') {
                      selectedSizes.add(newValue);
                      _productService.addNewSize(newValue, selectedCategory);
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadSizes(String category) async {
    predefinedSizes = await _productService.getVerifiedSizes(category);
    setState(() {});
  }

  Future<File> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 70,
    );
    return result!;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        setState(() {
          if (kIsWeb) {
            _pickedImage = pickedFile;
          } else {
            _pickedImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar la imagen: $e')),
      );
    }
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Precio*',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            enabled: !isExchangeOnly,
            validator: (value) {
              if (!isExchangeOnly && (value == null || value.isEmpty)) {
                return 'Este campo es obligatorio';
              }
              if (!isExchangeOnly && int.tryParse(value!) == null) {
                return 'Ingrese solo números';
              }
              return null;
            },
            onSaved: (value) => price = int.tryParse(value ?? ''),
          ),
        ),
        SizedBox(width: 10),
        Column(
          children: [
            Text('Solo intercambio'),
            Checkbox(
              value: isExchangeOnly,
              onChanged: (value) {
                setState(() {
                  isExchangeOnly = value!;
                  if (isExchangeOnly) {
                    price = null;
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQualitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Calidad*', style: Theme.of(context).textTheme.titleMedium),
        ...qualityOptions
            .map((quality) => RadioListTile<String>(
                  title: Text(quality),
                  value: quality,
                  groupValue: selectedQuality,
                  onChanged: (value) {
                    setState(() {
                      selectedQuality = value;
                    });
                  },
                ))
            .toList(),
      ],
    );
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, seleccione una imagen')),
        );
        return;
      }

      _formKey.currentState!.save();

      if (selectedQuality == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, seleccione una calidad')),
        );
        return;
      }

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          },
        );

        String result = await _productService.uploadProduct(
          title: title,
          description: description,
          styles: selectedStyles,
          sizes: selectedSizes,
          price: price!,
          quality: selectedQuality!,
          image: _pickedImage,
          category: selectedCategory,
        );

        Navigator.of(context).pop(); // Cierra el diálogo de progreso

        if (result.startsWith("Producto añadido con éxito")) {
          // Mostrar diálogo de confirmación
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Producto añadido'),
                content: Text('¿Qué deseas hacer ahora?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Añadir otro producto'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                      _resetForm(); // Método para resetear el formulario
                    },
                  ),
                  TextButton(
                    child: Text('Volver al catálogo'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Catalogue()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      } catch (e) {
        Navigator.of(context).pop(); // Cierra el diálogo de progreso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el producto: $e')),
        );
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _pickedImage = null;
      selectedStyles.clear();
      selectedSizes.clear();
      selectedCategory = '';
    });
  }
}
