import 'package:flutter/material.dart';
import 'package:pin/features/add_product/presentation/widgets/upload_product_app_bar.dart';
import '/core/services/product.dart';
import 'package:pin/features/add_product/presentation/widgets/category_selector.dart';
import 'package:pin/features/add_product/presentation/widgets/photo_upload_section.dart';
import 'package:pin/features/add_product/presentation/widgets/pricing_section.dart';
import 'package:pin/features/add_product/presentation/widgets/product_details_form.dart';
import 'package:pin/features/add_product/presentation/widgets/promotion_section.dart';
import 'package:get/get.dart';
import 'package:pin/core/utils/NavigationMenu/controllers/navigationController.dart';
import 'package:pin/core/utils/NavigationMenu/NavigationMenu.dart';

//todo: when uploading a product, the resetForm should also update the CategorySelector, Pricing and PromotionSection clearing them
class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();

  // State variables
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final NavigationController navigationController =
      Get.find<NavigationController>();
  List<String> selectedStyles = [];
  String selectedSize = '';
  int? price = 0;
  String? selectedQuality;
  dynamic _pickedImage;
  String selectedCategory = '';
  bool isExchangeOnly = false;
  bool _isLoading = true;
  bool isPromoted = false;
  bool isPublic = false;

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
      predefinedQualities = [
        'Nuevo',
        'Casi nuevo',
        'Pequeños desperfectos',
        'Usado',
        'Viejo'
      ];
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      selectedStyles.clear();
      selectedSize = '';
      selectedQuality = null;
      _pickedImage = null;
      selectedCategory = '';
      price = 0;
      isExchangeOnly = false;
      isPublic = false;
      isPromoted = false;
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
        String result = await _productService.uploadProduct(
          title: _titleController.text,
          description: _descriptionController.text,
          styles: selectedStyles,
          size: selectedSize,
          price: isExchangeOnly ? null : price,
          quality: selectedQuality!,
          image: _pickedImage,
          category: selectedCategory,
          isExchangeOnly: isExchangeOnly,
          isPublic: isPublic,
          enCloset: false,
        );

        if (result.startsWith("Producto añadido con éxito")) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 60),
                        const SizedBox(height: 16),
                        const Text(
                          'Guardado correctamente',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  navigationController.updateIndex(0);
                                    Get.offAll(() => NavigationMenu());
                                },
                                child: const Text(
                                  'Ir al catálogo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.black),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _resetForm();
                                },
                                child: const Text(
                                  'Seguir',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      } catch (e) {
        Navigator.of(context)
            .pop(); // Close the loading dialog in case of error
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
          color: Colors.white, // Background color for the entire screen
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
                  nameController: _titleController,
                  descriptionController: _descriptionController,
                ),
                const Divider(color: Color(0xFFD9D9D9), thickness: 20),
                CategorySelector(
                  categories: clothingCategories,
                  styles: predefinedStyles,
                  sizes: predefinedSizes,
                  qualities: predefinedQualities,
                  onCategorySelected: (category) =>
                      setState(() => selectedCategory = category),
                  onStyleSelected: (style) =>
                      setState(() => selectedStyles = [style]),
                  onSizeSelected: (size) => setState(() => selectedSize = size),
                  onQualitySelected: (quality) =>
                      setState(() => selectedQuality = quality),
                ),
                const Divider(color: Color(0xFFD9D9D9), thickness: 20),
                PricingSection(
                  onPriceChanged: (price) => setState(() => this.price = price),
                  onExchangeOnlyChanged: (isExchangeOnly) =>
                      setState(() => this.isExchangeOnly = isExchangeOnly),
                  onPublicChanged: (isPublic) =>
                      setState(() => this.isPublic = isPublic),
                  isPublic: isPublic,
                  initialPrice: price,
                  initialExchangeOnly: isExchangeOnly,
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
