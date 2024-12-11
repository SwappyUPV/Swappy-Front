import 'package:flutter/material.dart';
import 'package:pin/features/add_product/presentation/widgets/upload_product_app_bar.dart';
import '/core/services/product.dart';
import 'package:get/get.dart';
import '../../../../core/utils/NavigationMenu/NavigationMenu.dart';
import 'package:pin/core/utils/NavigationMenu/controllers/navigationController.dart';
import 'package:pin/features/add_product/presentation/widgets/category_selector.dart';
import 'package:pin/features/add_product/presentation/widgets/photo_upload_section.dart';
import 'package:pin/features/add_product/presentation/widgets/pricing_section.dart';
import 'package:pin/features/add_product/presentation/widgets/product_details_form.dart';
import 'package:pin/features/add_product/presentation/widgets/promotion_section.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProductScreen> {
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

  List<String> predefinedStyles = [];
  List<String> predefinedSizes = [];
  List<String> clothingCategories = [];
  List<String> predefinedQualities = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      predefinedStyles = await _productService.getStyles();
      clothingCategories = await _productService.getClothingCategories();
      predefinedSizes = ['S', 'M', 'L', 'XL'];
      predefinedQualities = ['Nuevo','Casi nuevo','Pequeños desperfectos', 'Usado', 'Viejo'];
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _pickedImage = null;
      selectedStyles.clear();
      selectedSize = '';
      selectedQuality = null; // Reset selectedQuality
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

    return Scaffold(
      appBar: UploadProductAppBar(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white, // Fondo blanco para toda la ventana
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PhotoUploadSection(
                  pickedImage: _pickedImage,
                  onImagePicked: (image) =>
                      setState(() => _pickedImage = image),
                ),
                const Divider(color: Color(0xFFD9D9D9), thickness: 20),
                ProductDetailsForm(
                  initialName: title,
                  initialDescription: description,
                  onNameChanged: (value) => setState(() => title = value),
                  onDescriptionChanged: (value) =>
                      setState(() => description = value),
                ),
                const Divider(color: Color(0xFFD9D9D9), thickness: 20),
                CategorySelector(
                  categories: clothingCategories,
                  styles: predefinedStyles,
                  sizes: predefinedSizes,
                  qualities: predefinedQualities, // Pass predefined qualities
                  onCategorySelected: (category) =>
                      setState(() => selectedCategory = category),
                  onStyleSelected: (style) =>
                      setState(() => selectedStyles = [style]),
                  onSizeSelected: (size) => setState(() => selectedSize = size),
                  onQualitySelected: (quality) => setState(() => selectedQuality = quality), // Handle quality selection
                ),
                const Divider(color: Color(0xFFD9D9D9), thickness: 20),
                PricingSection(
                  onPriceChanged: (price) => setState(() => this.price = price),
                  onExchangeOnlyChanged: (isExchangeOnly) =>
                      setState(() => this.isExchangeOnly = isExchangeOnly),
                ),
                const Divider(color: Color(0xFFD9D9D9), thickness: 20),
                PromotionSection(
                  isPromoted: isPromoted,
                  onPromotionChanged: (isPromoted) =>
                      setState(() => this.isPromoted = isPromoted),
                ),
                const SizedBox(height: 26),
                _buildPublishButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPublishButton() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFD9D9D9),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: GestureDetector(
        onTap: _uploadProduct,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 17),
          child: const Center(
            child: Text(
              'Finalizar y publicar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'UrbaneMedium',
                letterSpacing: -0.34,
              ),
            ),
          ),
        ),
      ),
    );
  }
}