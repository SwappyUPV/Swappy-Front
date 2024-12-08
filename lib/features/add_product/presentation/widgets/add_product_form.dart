import 'package:flutter/material.dart';
import '/core/services/product.dart';
import '/features/add_product/presentation/widgets/category_dropdown_widget.dart';
import '/features/add_product/presentation/widgets/custom_text_field_widget.dart';
import '/features/add_product/presentation/widgets/image_picker.dart';
import '/features/add_product/presentation/widgets/price_input_widget.dart';
import '/features/add_product/presentation/widgets/quality_selector_widget.dart';
import '/features/add_product/presentation/widgets/sizes_selector_widget.dart';
import '/features/add_product/presentation/widgets/styles_selector_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: Color(0xFFD9D9D9), // Fondo gris claro para toda la ventana
      // Margen alrededor de los elementos
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primera sección
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
            const SizedBox(height: 16), // Espacio entre secciones

            // Nombre
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

            // Descripción
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

            // Estilo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: StylesSelectorWidget(
                predefinedStyles: predefinedStyles,
                selectedStyles: selectedStyles,
                onStylesChanged: (styles) =>
                    setState(() => selectedStyles = styles),
                productService: _productService,
              ),
            ),
            const SizedBox(height: 16),

            // Categoría
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CategoryDropdownWidget(
                selectedCategory: selectedCategory,
                categories: clothingCategories,
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                    _loadSizes(category);
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Tamaños
            if (selectedCategory.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizesSelectorWidget(
                  predefinedSizes: predefinedSizes,
                  selectedSize: selectedSize,
                  onSizesChanged: (size) => setState(() => selectedSize = size),
                  productService: _productService,
                ),
              ),
            const SizedBox(height: 16),

            // Precio
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: PriceInputWidget(
                isExchangeOnly: isExchangeOnly,
                onPriceChanged: (price) => setState(() => this.price = price),
                onExchangeOnlyChanged: (isExchangeOnly) =>
                    setState(() => this.isExchangeOnly = isExchangeOnly),
              ),
            ),
            const SizedBox(height: 16),

            // Calidad
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: QualitySelectorWidget(
                selectedQuality: selectedQuality,
                qualityOptions: qualityOptions,
                onQualityChanged: (quality) =>
                    setState(() => selectedQuality = quality),
              ),
            ),
            const SizedBox(height: 20),

            // Botón
            ElevatedButton(
              onPressed: _uploadProduct,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Finalizar y publicar'),
            ),
            const SizedBox(height: 105),
          ],
        ),
      ),
    );
  }
}
