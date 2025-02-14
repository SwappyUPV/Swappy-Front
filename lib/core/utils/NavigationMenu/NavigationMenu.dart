import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin/core/utils/NavigationMenu/components/hover_button.dart';
import 'package:pin/features/add_product/presentation/screens/upload_product_screen.dart';
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
  final List<GlobalKey<NavigatorState>> _navKeys =
  List.generate(5, (_) => GlobalKey<NavigatorState>());
  final List<Widget> _pages = [
    const CatalogueScreen(),
    const VirtualClosetScreen(),
    const UploadProductScreen(),
    ChatsScreen(),
    const ProfileScreen(),
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
                    NavigationRailDestinationWidget.buildRailDestination(
                        'home', 'home_selected', 'Catálogo', _selectedIndex, _pages),
                    NavigationRailDestinationWidget.buildRailDestination(
                        'top', 'top_selected', 'Armario', _selectedIndex, _pages),
                    NavigationRailDestinationWidget.buildRailDestination(
                        'add', 'add_selected', 'Subir', _selectedIndex, _pages),
                    NavigationRailDestinationWidget.buildRailDestination(
                        'chat', 'chat_selected', 'Chat', _selectedIndex, _pages),
                    NavigationRailDestinationWidget.buildRailDestination(
                        'user',
                        'user_selected',
                        authController.isLoggedIn.value ? 'Perfil' : 'Iniciar Sesión',
                        _selectedIndex,
                        _pages),
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
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 56),
                  child: WillPopScope(
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
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 10,
                          spreadRadius: 0.4,
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double iconSize = constraints.maxWidth < 300 ? 24 : 30;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth / 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: BottomNavBarItemWidget.buildNavBarItem(
                                    'home', 0, _selectedIndex, _onItemTapped, iconSize),
                              ),
                              Flexible(
                                child: BottomNavBarItemWidget.buildNavBarItem(
                                    'top', 1, _selectedIndex, _onItemTapped, iconSize),
                              ),
                              Flexible(
                                child: HoverButton(
                                  onTap: () {
                                    if (authController.isLoggedIn.value) {
                                      _onItemTapped(2);
                                    } else {
                                      _showLoginDialog();
                                    }
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/navBar/add.svg',
                                        width: 20,
                                        height: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: BottomNavBarItemWidget.buildNavBarItem(
                                    'chat', 3, _selectedIndex, _onItemTapped, iconSize),
                              ),
                              Flexible(
                                child: BottomNavBarItemWidget.buildNavBarItem(
                                    'user', 4, _selectedIndex, _onItemTapped, iconSize),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

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
}