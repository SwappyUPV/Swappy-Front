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
import '/features/catalogue/presentation/widgets/navigation_menu.dart';

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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFieldWidget(
            label: 'Título*',
            onSaved: (value) => title = value!,
            validator: (value) =>
                value!.isEmpty ? 'Este campo es obligatorio' : null,
          ),
          const SizedBox(height: 16),
          CustomTextFieldWidget(
            label: 'Descripción',
            onSaved: (value) => description = value ?? '',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          StylesSelectorWidget(
            predefinedStyles: predefinedStyles,
            selectedStyles: selectedStyles,
            onStylesChanged: (styles) =>
                setState(() => selectedStyles = styles),
            productService: _productService,
          ),
          const SizedBox(height: 16),
          CategoryDropdownWidget(
            selectedCategory: selectedCategory,
            categories: clothingCategories,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
                _loadSizes(category);
              });
            },
          ),
          const SizedBox(height: 16),
          if (selectedCategory.isNotEmpty)
            SizesSelectorWidget(
              predefinedSizes: predefinedSizes,
              selectedSize: selectedSize,
              onSizesChanged: (size) => setState(() => selectedSize = size),
              productService: _productService,
            ),
          const SizedBox(height: 16),
          PriceInputWidget(
            isExchangeOnly: isExchangeOnly,
            onPriceChanged: (price) => setState(() => this.price = price),
            onExchangeOnlyChanged: (isExchangeOnly) =>
                setState(() => this.isExchangeOnly = isExchangeOnly),
          ),
          const SizedBox(height: 16),
          QualitySelectorWidget(
            selectedQuality: selectedQuality,
            qualityOptions: qualityOptions,
            onQualityChanged: (quality) =>
                setState(() => selectedQuality = quality),
          ),
          const SizedBox(height: 20),
          ImagePickerWidget(
            pickedImage: _pickedImage,
            onImagePicked: (image) => setState(() => _pickedImage = image),
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
    );
  }
}
