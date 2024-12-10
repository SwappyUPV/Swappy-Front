import 'package:flutter/material.dart';
import 'package:pin/features/auth/data/models/user_model.dart';

class ProfileInfo extends StatelessWidget {
  final UserModel userModel;

  const ProfileInfo({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 19),
        Text(
          '@${userModel.name}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'UrbaneMedium',
            letterSpacing: -0.32,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          'Without fear of success 🫡 🎯\nStreetwear lover',
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'OpenSans',
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Mérida, España',
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'OpenSans',
            color: Color(0xFF3688CC),
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 310) {
              // Render vertically for small width screens
              return Column(
                children: [
                  _buildInfoBox('103', 'intercambios', false),
                  const SizedBox(height: 9),
                  _buildInfoBox('1009', 'puntos acumulados', false),
                ],
              );
            } else {
              // Render horizontally for larger screens
              return Row(
                children: [
                  _buildInfoBox('103', 'intercambios', true),
                  const SizedBox(width: 9),
                  _buildInfoBox('1009', 'puntos acumulados', true),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildInfoBox(String count, String label, bool isExpanded) {
    final container = Container(
      height: 100, // Set a fixed height for the containers
      width: 150, // Set a fixed width for the containers
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'UrbaneMedium',
                letterSpacing: -0.48,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'OpenSans',
              ),
            ),
          ],
        ),
      ),
    );

    return isExpanded
        ? Expanded(child: container)
        : Center(child: SizedBox(width: 150, child: container));
  }
}