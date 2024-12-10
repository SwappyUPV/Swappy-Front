import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin/features/auth/data/models/user_model.dart';

class WardrobeSection extends StatelessWidget {
  final UserModel userModel;

  const WardrobeSection({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 68),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Armario',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'UrbaneMedium',
                      ),
                    ),
                    const SizedBox(width: 11),
                    Icon(Icons.arrow_forward_ios, size: 12),
                  ],
                ),
                SvgPicture.asset(
                  'assets/icons/Filtrar.svg',
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          _buildWardrobeGrid(),
        ],
      ),
    );
  }

  Widget _buildWardrobeGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250, // Maximum width of each container
          mainAxisSpacing: 10, // Vertical spacing between containers
          crossAxisSpacing: 10, // Horizontal spacing between containers
          childAspectRatio: 1, // Adjust if needed to match container's aspect ratio
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FittedBox(
              fit: BoxFit.contain, // Adjust this to your desired behavior
              child: Image.asset(
                'assets/images/wardrobe/wardrobe_item_${index + 1}.png',
              ),
            ),

          );
        },
      ),
    );
  }
}