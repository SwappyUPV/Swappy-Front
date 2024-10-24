import '../../../components/filled_outline_button.dart';
import '../../../../constants.dart';
import '../../../../presentation/models/Chat.dart';
import '../../messages/message_screen.dart';
import 'package:flutter/material.dart';

import 'chat_card.dart';

class Body extends StatefulWidget {
  final String searchQuery;
  const Body({super.key, required this.searchQuery});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool showActive = false; // Estado para mostrar solo usuarios activos

  @override
  Widget build(BuildContext context) {
    // Filtrar chats según la búsqueda y el estado de 'showActive'
    final filteredChats = chatsData.where((chat) {
      final matchesSearchQuery =
          chat.name.toLowerCase().contains(widget.searchQuery.toLowerCase());
      final matchesActiveStatus =
          showActive ? chat.isActive : true; // Solo si se muestra activos
      return matchesSearchQuery && matchesActiveStatus;
    }).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color: kPrimaryColor,
          child: Row(
            children: [
              FillOutlineButton(
                press: () {
                  setState(() {
                    showActive =
                        false; // Reinicia el filtro al mostrar todos los mensajes
                  });
                },
                text: "Recent Message",
                isFilled: !showActive, // Cambia apariencia según el estado
              ),
              const SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () {
                  setState(() {
                    showActive =
                        true; // Activa el filtro para mostrar solo los activos
                  });
                },
                text: "Active",
                isFilled: showActive, // Cambia apariencia según el estado
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredChats.isNotEmpty // Verifica si hay chats filtrados
              ? ListView.builder(
                  itemCount: filteredChats.length,
                  itemBuilder: (context, index) => ChatCard(
                    chat: filteredChats[index],
                    press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MessagesScreen(),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: const Text(
                      "No chats found")), // Mensaje si no hay resultados
        ),
      ],
    );
  }
}
