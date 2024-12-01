import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin/features/add_product/presentation/screens/add_product_screen.dart';
import 'package:pin/features/catalogue/presentation/screens/catalogue_screen.dart';
import 'package:pin/features/chat/presentation/screens/chats/chats_screen.dart';
import 'package:pin/features/profile/presentation/screens/profile_screen.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/features/auth/presentation/screens/login_screen.dart';

class NavigationMenu extends StatelessWidget {
  NavigationMenu({super.key});

  final NavigationController controller = Get.put(NavigationController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
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
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: SvgPicture.asset('assets/icons/navBar/home.svg', width: 30, height: 30),
                      selectedIcon: SvgPicture.asset('assets/icons/navBar/home_selected.svg', width: 30, height: 30),
                      label: Text('Catálogo'),
                    ),
                    NavigationRailDestination(
                      icon: SvgPicture.asset('assets/icons/navBar/top.svg', width: 30, height: 30),
                      selectedIcon: SvgPicture.asset('assets/icons/navBar/top_selected.svg', width: 30, height: 30),
                      label: Text('Armario'),
                    ),
                    NavigationRailDestination(
                      icon: SvgPicture.asset('assets/icons/navBar/chat.svg', width: 30, height: 30),
                      selectedIcon: SvgPicture.asset('assets/icons/navBar/chat_selected.svg', width: 30, height: 30),
                      label: Text('Chat'),
                    ),
                    NavigationRailDestination(
                      icon: SvgPicture.asset('assets/icons/navBar/user.svg', width: 30, height: 30),
                      selectedIcon: SvgPicture.asset('assets/icons/navBar/user_selected.svg', width: 30, height: 30),
                      label: Text(authController.isLoggedIn.value ? 'Perfil' : 'Iniciar Sesión'),
                    ),
                  ],
                ),
                Expanded(
                  child: Obx(() {
                    switch (controller.selectedIndex.value) {
                      case 0:
                        return const Catalogue();
                      case 1:
                        return const VirtualCloset();
                      case 2:
                        return const AddProduct();
                      case 3:
                        return ChatsScreen();
                      case 4:
                        return authController.isLoggedIn.value
                            ? const Profile()
                            : const Login();
                      default:
                        return const Catalogue();
                    }
                  }),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Obx(() {
              switch (controller.selectedIndex.value) {
                case 0:
                  return const Catalogue();
                case 1:
                  return const VirtualCloset();
                case 2:
                  return const AddProduct();
                case 3:
                  return ChatsScreen();
                case 4:
                  return authController.isLoggedIn.value
                      ? const Profile()
                      : const Login();
                default:
                  return const Catalogue();
              }
            }),
            bottomNavigationBar: Obx(() => Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(150.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      currentIndex: controller.selectedIndex.value,
                      onTap: (index) {
                        if (index == 0 || index == 4) {
                          controller.updateIndex(index);
                        } else if (authController.isLoggedIn.value) {
                          controller.updateIndex(index);
                        } else {
                          _showLoginDialog(context);
                        }
                      },
                      type: BottomNavigationBarType.fixed,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      items: [
                        _buildNavBarItem('home', 'home_selected', 0),
                        _buildNavBarItem('top', 'top_selected', 1),
                        _buildNavBarItem('chat', 'chat_selected', 3),
                        _buildNavBarItem('user', 'user_selected', 4),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  child: FloatingActionButton(
                    onPressed: () {
                      controller.updateIndex(2);
                    },
                    backgroundColor: Colors.black,
                    child: SvgPicture.asset('assets/icons/navBar/add.svg', width: 30, height: 30, color: Colors.white),
                  ),
                ),
              ],
            )),
          );
        }
      },
    );
  }

  BottomNavigationBarItem _buildNavBarItem(String icon, String selectedIcon, int index) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        width: 30,
        height: 30,
        child: SvgPicture.asset(
          'assets/icons/navBar/${controller.selectedIndex.value != index ? icon : selectedIcon}.svg',
        ),
      ),
      label: '',
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to log in to access this feature.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Login'),
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
      if (isLoggedIn.value) {
        Get.find<NavigationController>().updateIndex(0);
      }
    });
  }
}