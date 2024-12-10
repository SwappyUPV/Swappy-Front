import 'package:flutter/material.dart';
import '/core/services/product.dart';
import '/features/add_product/presentation/widgets/custom_text_field_widget.dart';
import '/features/add_product/presentation/widgets/image_picker.dart';
import 'package:get/get.dart';
import '../../../../core/utils/NavigationMenu/NavigationMenu.dart';
import 'package:pin/core/utils/NavigationMenu/controllers/navigationController.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();

  // Variables de estado
  String title = '';
  String description = '';
  List<String> selectedStyles = [];
  String selectedSize = '';
  int? price;
  String? selectedQuality;
  dynamic _pickedImage;
  String selectedCategory = '';
  bool isExchangeOnly = false;
  bool _isLoading = true;
  bool isPromoted = false; // Variable para controlar si está promocionada o no

  // Listas predefinidas
  List<String> predefinedStyles = [];
  List<String> predefinedSizes = [];
  List<String> clothingCategories = [];
  final List<String> qualityOptions = [
    'Nuevo',
    'Seminuevo',
    'Algo utilizado',
    'Bastante usado',
    'Muy desgastado'
  ];
  bool showCategoryOptions = false;
  bool showPriceOptions = false;
  bool showQualityOptions = false;
  bool showStyleOptions = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _loadInitialData();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadInitialData() async {
    predefinedStyles = await _productService.getStyles();
    clothingCategories = await _productService.getClothingCategories();
  }

  Future<void> _loadSizes(String category) async {
    predefinedSizes = await _productService.getSizes(category);
    setState(() {});
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _pickedImage = null;
      selectedStyles.clear();
      selectedSize = '';
      selectedQuality = null;
      selectedCategory = '';
    });
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
          size: selectedSize,
          price: isExchangeOnly ? null : price,
          quality: selectedQuality!,
          image: _pickedImage,
          category: selectedCategory,
          isExchangeOnly: isExchangeOnly,
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
                      Navigator.of(context).pop();
                      _resetForm();
                    },
                  ),
                  TextButton(
                    child: Text('Volver al catálogo'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      final NavigationController navigationController =
                          Get.find<NavigationController>();
                      navigationController.updateIndex(0);
                      Get.off(() => NavigationMenu());
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

  // Función para mostrar el Popup para estilos y tamaños
  void _showPopup(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona $type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: type == 'Estilos'
                ? predefinedStyles
                    .map((style) => ListTile(
                          title: Text(style),
                          onTap: () {
                            setState(() {
                              if (!selectedStyles.contains(style)) {
                                selectedStyles.add(style);
                              }
                            });
                            Navigator.pop(context);
                          },
                        ))
                    .toList()
                : type == 'Categoria'
                    ? clothingCategories
                        .map((category) => ListTile(
                              title: Text(category),
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                                Navigator.pop(context);
                              },
                            ))
                        .toList()
                    : type == 'Calidad'
                        ? qualityOptions
                            .map((quality) => ListTile(
                                  title: Text(quality),
                                  onTap: () {
                                    setState(() {
                                      selectedQuality = quality;
                                    });
                                    Navigator.pop(context);
                                  },
                                ))
                            .toList()
                        : predefinedSizes
                            .map((size) => ListTile(
                                  title: Text(size),
                                  onTap: () {
                                    setState(() {
                                      selectedSize = size;
                                    });
                                    Navigator.pop(context);
                                  },
                                ))
                            .toList(),
          ),
        );
      },
    );
  }

  void _showPricePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Configura el precio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    price = int.tryParse(value);
                  });
                },
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: Color(0xFFD9D9D9), // Fondo gris claro para toda la ventana
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Primero, añade una foto de la prenda que vas a vender o intercambiar, ¡Asegúrate de que aparezca nítida, de frente y bien iluminada!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ImagePickerWidget(
                    pickedImage: _pickedImage,
                    onImagePicked: (image) =>
                        setState(() => _pickedImage = image),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomTextFieldWidget(
                label: 'Nombre',
                placeholder: 'ej., Camiseta Blanca Nike',
                enableCharacterCounter: false,
                onSaved: (value) => print('Valor guardado: $value'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Este campo no puede estar vacío'
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomTextFieldWidget(
                label: 'Descripción',
                placeholder:
                    'ej., con etiqueta, a estrenar, busco intercambiar por unas zapatillas',
                enableCharacterCounter: true,
                onSaved: (value) => print('Valor guardado: $value'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Este campo no puede estar vacío'
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            // Categoría
            GestureDetector(
              onTap: () {
                setState(() {
                  showCategoryOptions = !showCategoryOptions;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categoría:'),
                    Text(selectedCategory.isEmpty
                        ? 'Seleccionar'
                        : selectedCategory),
                  ],
                ),
              ),
            ),
            if (showCategoryOptions)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: clothingCategories
                      .map((category) => ListTile(
                            title: Text(category),
                            trailing: selectedCategory == category
                                ? Icon(Icons.check,
                                    color: Colors
                                        .green) // Flecha de check si está seleccionado
                                : null,
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                                showCategoryOptions = false;
                              });
                            },
                          ))
                      .toList(),
                ),
              ),

            SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                setState(() {
                  isExchangeOnly =
                      !isExchangeOnly; // Cambia el estado del interruptor
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Solo intercambio'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(isExchangeOnly ? 'ON' : 'OFF'),
                        Switch(
                          value: isExchangeOnly,
                          onChanged: (bool value) {
                            setState(() {
                              isExchangeOnly = value;
                              if (value) {
                                // Si se activa solo intercambio, limpiamos el precio
                                price = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Precio
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  enabled:
                      !isExchangeOnly, // Deshabilitamos el campo si es solo intercambio
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(),
                    // Añadimos un sufijo para mostrar la moneda
                    suffixText: '€',
                    // Añadimos un texto de ayuda cuando está deshabilitado
                    helperText: isExchangeOnly
                        ? 'No disponible en modo intercambio'
                        : null,
                    // Cambiamos el color cuando está deshabilitado
                    fillColor: isExchangeOnly ? Colors.grey[200] : null,
                    filled: isExchangeOnly,
                  ),
                  controller: TextEditingController(
                    text: price?.toString() ?? '',
                  )..selection = TextSelection.fromPosition(
                      TextPosition(offset: price?.toString().length ?? 0),
                    ),
                  onChanged: (value) {
                    if (!isExchangeOnly) {
                      setState(() {
                        price = int.tryParse(value);
                      });
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 16),
            // Calidad
            GestureDetector(
              onTap: () {
                setState(() {
                  showQualityOptions = !showQualityOptions;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Calidad:'),
                    Text(selectedQuality ?? 'Seleccionar'),
                  ],
                ),
              ),
            ),
            if (showQualityOptions)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: qualityOptions
                      .map((quality) => ListTile(
                            title: Text(quality),
                            trailing: selectedQuality == quality
                                ? Icon(Icons.check,
                                    color: Colors
                                        .green) // Flecha de check si está seleccionado
                                : null,
                            onTap: () {
                              setState(() {
                                selectedQuality = quality;
                                showQualityOptions = false;
                              });
                            },
                          ))
                      .toList(),
                ),
              ),

            SizedBox(height: 16),
            // Estilos
            GestureDetector(
              onTap: () {
                setState(() {
                  showStyleOptions = !showStyleOptions;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estilo(s):'),
                    Text(selectedStyles.isNotEmpty
                        ? selectedStyles.join(', ')
                        : 'Seleccionar'),
                  ],
                ),
              ),
            ),
            if (showStyleOptions)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: predefinedStyles
                      .map((style) => ListTile(
                            title: Text(style),
                            trailing: selectedStyles.contains(style)
                                ? Icon(Icons.check,
                                    color: Colors
                                        .green) // Flecha de check si está seleccionado
                                : null,
                            onTap: () {
                              setState(() {
                                if (selectedStyles.contains(style)) {
                                  selectedStyles.remove(style);
                                } else {
                                  selectedStyles.add(style);
                                }
                              });
                            },
                          ))
                      .toList(),
                ),
              ),

            SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                setState(() {
                  isPromoted = !isPromoted; // Cambia el estado del interruptor
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Promocionar prenda (1 euro)'),
                    SizedBox(height: 8), // Espacio entre el título y el texto
                    Text(
                      'Destaca su prenda en búsquedas y secciones principales para aumentar su visibilidad y llegar a más usuarios.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 16), // Espacio antes del interruptor
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(isPromoted ? 'ON' : 'OFF'),
                        Switch(
                          value: isPromoted,
                          onChanged: (bool value) {
                            setState(() {
                              isPromoted = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 26),
            ElevatedButton(
              onPressed: _uploadProduct,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Finalizar y publicar'),
            ),
            const SizedBox(height: 106),
          ],
        ),
      ),
    );
  }
}
