import 'package:flutter/material.dart';
import 'package:get/get.dart';  // Import GetX
import 'package:iconsax/iconsax.dart';
import 'package:pin/features/add_product/presentation/screens/add_product_screen.dart';
import 'package:pin/features/catalogue/presentation/screens/catalogue_screen.dart';
import 'package:pin/features/chat/presentation/screens/chats/chats_screen.dart';
import 'package:pin/features/profile/presentation/screens/profile_screen.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';

class NavigationMenu extends StatelessWidget {
  NavigationMenu({Key? key}) : super(key: key);

  final NavigationController controller = Get.put(NavigationController());  // Initialize the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // This is where you'll display the respective screens
        switch (controller.selectedIndex.value) {
          case 0:
            return const Catalogue();
          case 1:
            return const VirtualCloset();
          case 2:
            return const AddProduct();
          case 3:
            return const ChatsScreen();
          case 4:
            return const Profile();
          default:
            return const Catalogue();
        }
      }),
      bottomNavigationBar: Obx(() => NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (index) {
          controller.updateIndex(index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.accessibility),
            label: 'Wardrobe',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.add),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.message),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.user),
            label: 'Profile',
          ),
        ],
      )),
    );
  }
}

//USED OBX BUT CAN USE NAVIGATIONBOTTOMBAR INSTEAD
class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}