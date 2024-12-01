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
import 'package:pin/core/utils/NavigationMenu/components/NavigationRailDestinationWidget.dart';
import 'package:pin/core/utils/NavigationMenu/components/BottomNavBarItemWidget.dart';
import 'package:pin/core/utils/NavigationMenu/controllers/navigationController.dart';
import 'package:pin/core/utils/NavigationMenu/controllers/AuthController.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final NavigationController controller = Get.put(NavigationController());
  final AuthController authController = Get.put(AuthController());
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navKeys = List.generate(5, (_) => GlobalKey<NavigatorState>());
  final List<Widget> _pages = [
    const Catalogue(),
    const VirtualCloset(),
    const AddProduct(),
    ChatsScreen(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                    NavigationRailDestinationWidget.buildRailDestination('home', 'home_selected', 'Catálogo', _selectedIndex, _pages),
                    NavigationRailDestinationWidget.buildRailDestination('top', 'top_selected', 'Armario', _selectedIndex, _pages),
                    NavigationRailDestinationWidget.buildRailDestination('add', 'add_selected', 'Subir', _selectedIndex, _pages),
                    NavigationRailDestinationWidget.buildRailDestination('chat', 'chat_selected', 'Chat', _selectedIndex, _pages),
                    NavigationRailDestinationWidget.buildRailDestination('user', 'user_selected', authController.isLoggedIn.value ? 'Perfil' : 'Iniciar Sesión', _selectedIndex, _pages),
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
                    color: Colors.transparent,
                    elevation: 0,
                    child: Container(
                      height: 98,
                      width: 390,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          BottomNavBarItemWidget.buildNavBarItem('home', 0, _selectedIndex, _onItemTapped),
                          BottomNavBarItemWidget.buildNavBarItem('top', 1, _selectedIndex, _onItemTapped),
                          const SizedBox(width: 50),
                          BottomNavBarItemWidget.buildNavBarItem('chat', 3, _selectedIndex, _onItemTapped),
                          BottomNavBarItemWidget.buildNavBarItem('user', 4, _selectedIndex, _onItemTapped),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Transform.translate(
              offset: const Offset(0, -30),
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

  //  -------------------------------------- Methods --------------------------------------------

  /// Handles the back button press to navigate within the nested navigators.
  Future<bool> _onWillPop() async {
    if (_navKeys[_selectedIndex].currentState?.canPop() ?? false) {
      _navKeys[_selectedIndex].currentState?.pop();
      return false;
    }
    return true;
  }

  /// Handles the navigation item tap.
  /// If the user is not logged in and tries to access restricted pages, it shows a login dialog.
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

  /// Shows a dialog prompting the user to log in.
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
}