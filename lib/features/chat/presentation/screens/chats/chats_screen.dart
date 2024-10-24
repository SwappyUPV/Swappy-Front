import '../../../constants.dart';
import 'package:flutter/material.dart';
import 'components/body.dart'; // Asegúrate de que este import sea correcto

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false; // Variable para controlar la búsqueda

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(searchQuery: _searchQuery), // Pasa el searchQuery al Body
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Ícono de búsqueda siempre a la derecha
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching; // Alterna el estado de búsqueda
                if (!_isSearching) {
                  _searchController
                      .clear(); // Limpiar el texto si se cierra la búsqueda
                  _searchQuery = ''; // Reiniciar la consulta de búsqueda
                }
              });
            },
          ),
          // Muestra el campo de búsqueda si _isSearching es true
          if (_isSearching)
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Buscar...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery =
                        value; // Actualiza el searchQuery en tiempo real
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
