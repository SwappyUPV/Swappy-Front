import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/features/add_product/presentation/screens/add_product_screen.dart';
import 'package:pin/features/catalogue/presentation/screens/catalogue_screen.dart';
import 'package:pin/features/chat/presentation/screens/chats/chats_screen.dart';
import 'package:pin/features/profile/presentation/screens/profile_screen.dart';
import 'package:pin/features/auth/presentation/screens/login_screen.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final NavigationController controller = Get.put(NavigationController());
  final AuthController authController = Get.put(AuthController());

  final List<GlobalKey<NavigatorState>> _navKeys = List.generate(5, (_) => GlobalKey<NavigatorState>());
  final List<Widget> _pages = [
    const Catalogue(),
    const VirtualCloset(),
    const AddProduct(),
    ChatsScreen(),
    const Profile(),
  ];

  int _selectedIndex = 0;

  Future<bool> _onWillPop() async {
    if (_navKeys[_selectedIndex].currentState?.canPop() ?? false) {
      _navKeys[_selectedIndex].currentState?.pop();
      return false;
    }
    return true;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      _navKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else if (index == 1 || index == 2 || index == 3 || index == 4) {
      if (authController.isLoggedIn.value) {
        setState(() {
          _selectedIndex = index;
        });
      } else {
        _showLoginDialog();
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inicio de Sesión'),
          content: const Text('Necesitas iniciar sesión para acceder a esta sección.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Iniciar Sesión'),
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use NavigationRail for larger screens
        if (constraints.maxWidth >= 600) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    if (index == 2 || index == 3 || index == 4) {
                      if (authController.isLoggedIn.value) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      } else {
                        _showLoginDialog();
                      }
                    } else {
                      setState(() {
                        _selectedIndex = index;
                      });
                    }
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    _buildRailDestination('home', 'home_selected', 'Catálogo'),
                    _buildRailDestination('top', 'top_selected', 'Armario'),
                    _buildRailDestination('add', 'add_selected', 'Subir'),
                    _buildRailDestination('chat', 'chat_selected', 'Chat'),
                    _buildRailDestination('user', 'user_selected', authController.isLoggedIn.value ? 'Perfil' : 'Iniciar Sesión'),
                  ],
                ),
                Expanded(
                  child: WillPopScope(
                    onWillPop: _onWillPop,
                    child: Navigator(
                      key: _navKeys[_selectedIndex],
                      onGenerateInitialRoutes: (_, __) {
                        return [
                          MaterialPageRoute(
                            builder: (context) => _pages[_selectedIndex],
                          ),
                        ];
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Use Bottom Navigation for smaller screens
          return Scaffold(
            body: Stack(
              children: [
                WillPopScope(
                  onWillPop: _onWillPop,
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _pages
                        .asMap()
                        .entries
                        .map((entry) => Navigator(
                      key: _navKeys[entry.key],
                      onGenerateInitialRoutes: (_, __) {
                        return [
                          MaterialPageRoute(
                            builder: (context) => entry.value,
                          ),
                        ];
                      },
                    ))
                        .toList(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BottomAppBar(
                    shape: const CircularNotchedRectangle(),
                    notchMargin: 8.0,
                    color: Colors.transparent, // Make BottomAppBar transparent
                    elevation: 0, // Remove shadow
                    child: Container(
                      height: 98,
                      width: 390,
                      decoration: BoxDecoration(
                        color: Colors.white, // Set the desired background color
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavBarItem('home', 0),
                          _buildNavBarItem('top', 1),
                          const SizedBox(width: 50), // Space for the floating action button
                          _buildNavBarItem('chat', 3),
                          _buildNavBarItem('user', 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Transform.translate(
              offset: const Offset(0, -30), // Adjust the offset to raise the button
              child: Container(
                height: 68,
                width: 68,
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  elevation: 0,
                  onPressed: () {
                    if (authController.isLoggedIn.value) {
                      _onItemTapped(2);
                    } else {
                      _showLoginDialog();
                    }
                  },
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 3, color: Colors.black),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/navBar/add.svg',
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  NavigationRailDestination _buildRailDestination(String icon, String selectedIcon, String label) {
    final bool isSelected = _selectedIndex == _pages.indexWhere((element) => element.toString() == label);
    return NavigationRailDestination(
      icon: SvgPicture.asset(
        'assets/icons/navBar/$icon.svg',
        width: 30,
        height: 30,
        color: isSelected ? Colors.black : Colors.black.withOpacity(0.9),
      ),
      selectedIcon: SvgPicture.asset(
        'assets/icons/navBar/$selectedIcon.svg',
        width: 30,
        height: 30,
        color: Colors.black,
      ),
      label: Text(label),
    );
  }

  Widget _buildNavBarItem(String icon, int index) {
    final bool isSelected = _selectedIndex == index;
    return IconButton(
      icon: SvgPicture.asset(
        'assets/icons/navBar/${isSelected ? '${icon}_selected' : icon}.svg',
        width: 28,
        height: 28,
        color: isSelected ? Colors.black : Colors.black.withOpacity(0.9),
      ),
      onPressed: () => _onItemTapped(index),
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
    });
  }
}