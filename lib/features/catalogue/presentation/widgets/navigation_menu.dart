import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pin/features/add_product/presentation/screens/add_product_screen.dart';
import 'package:pin/features/catalogue/presentation/screens/catalogue_screen.dart';
import 'package:pin/features/chat/presentation/screens/chats/chats_screen.dart';
import 'package:pin/features/profile/presentation/screens/profile_screen.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/features/auth/presentation/screens/login_screen.dart';

class NavigationMenu extends StatelessWidget {
  NavigationMenu({Key? key}) : super(key: key);

  final NavigationController controller = Get.put(NavigationController());
  final AuthController authController = Get.put(AuthController());

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
            return authController.isLoggedIn.value
                ? const Profile()
                : const Login();
          default:
            return const Catalogue();
        }
      }),
      bottomNavigationBar: Obx(() => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) {
              if (index == 0 || index == 4) {
                controller.updateIndex(index);
              } else if (authController.isLoggedIn.value) {
                controller.updateIndex(index);
              } else {
                _showLoginDialog(context);
              }
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
                icon: authController.isLoggedIn.value
                    ? Icon(Iconsax.user)
                    : Icon(Iconsax.login),
                label: authController.isLoggedIn.value
                    ? 'Perfil'
                    : 'Iniciar sesión',
              ),
            ],
          )),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Iniciar sesión'),
          content:
              Text('Necesitas iniciar sesión para acceder a esta función.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Iniciar sesión'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        );
      },
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

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      isLoggedIn.value = user != null;
    });
  }
}
