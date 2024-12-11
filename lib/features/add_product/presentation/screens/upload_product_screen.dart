import 'package:flutter/material.dart';
import 'package:pin/features/add_product/presentation/widgets/category_selector.dart';
import 'package:pin/features/add_product/presentation/widgets/photo_upload_section.dart';
import 'package:pin/features/add_product/presentation/widgets/pricing_section.dart';
import 'package:pin/features/add_product/presentation/widgets/product_details_form.dart';
import 'package:pin/features/add_product/presentation/widgets/promotion_section.dart';
import 'package:pin/features/add_product/presentation/widgets/upload_product_app_bar.dart';

class UploadProductScreen extends StatelessWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
            children: [
              const UploadProductAppBar(),
              const PhotoUploadSection(),
              const Divider(color: Color(0xFFD9D9D9), thickness: 20),
              const ProductDetailsForm(),
              const Divider(color: Color(0xFFD9D9D9), thickness: 20),
              const CategorySelector(),
              const Divider(color: Color(0xFFD9D9D9), thickness: 20),
              const PricingSection(),
              const Divider(color: Color(0xFFD9D9D9), thickness: 20),
              const PromotionSection(),
              _buildPublishButton(),
            ],
          ),
      ),
    );
  }

  Widget _buildPublishButton() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFD9D9D9),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
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
              fontFamily: 'Urbane',
              letterSpacing: -0.34,
            ),
          ),
        ),
      ),
    );
  }
}