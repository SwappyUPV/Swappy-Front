import 'package:flutter/material.dart';
import 'package:pin/features/auth/data/models/user_model.dart';

class ProfileStats extends StatelessWidget {
  final UserModel userModel;

  const ProfileStats({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 350) {
          // Render vertically for small width screens
          return Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: userModel.profilePicture != null
                    ? NetworkImage(userModel.profilePicture!)
                    : null,
              ),
              const SizedBox(height: 19),
              _buildVerticalStats(),
              const SizedBox(height: 15),
              _buildButtons(),
            ],
          );
        } else {
          // Render horizontally for larger screens
          return Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: userModel.profilePicture != null
                    ? NetworkImage(userModel.profilePicture!)
                    : null,
              ),
              const SizedBox(width: 19),
              Expanded(
                child: Column(
                  children: [
                    _buildHorizontalStats(),
                    const SizedBox(height: 15),
                    _buildButtons(),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildHorizontalStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatColumn('78', 'prendas'),
        _buildStatColumn('926', 'seguidores'),
        _buildStatColumn('21', 'seguidos'),
      ],
    );
  }

  Widget _buildVerticalStats() {
    return Column(
      children: [
        _buildStatColumn('78', 'prendas'),
        const SizedBox(height: 10),
        _buildStatColumn('926', 'seguidores'),
        const SizedBox(height: 10),
        _buildStatColumn('21', 'seguidos'),
      ],
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'UrbaneMedium',
            letterSpacing: -0.32,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'OpenSans',
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        _buildButton('Editar perfil'),
        const SizedBox(width: 10),
        _buildButton('Compartir'),
      ],
    );
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}