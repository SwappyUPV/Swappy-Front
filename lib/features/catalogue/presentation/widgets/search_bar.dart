import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final List<String> productos;

  const SearchBar({
    Key? key,
    required this.onSearch,
    required this.productos,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  List<String> _sugerencias = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _sugerencias = widget.productos
          .where((producto) => producto.toLowerCase().contains(query))
          .toList();
    });
    widget.onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Busca ropa para intercambiar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        if (_sugerencias.isNotEmpty)
          Container(
            height: 200,
            child: ListView.builder(
              itemCount: _sugerencias.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_sugerencias[index]),
                  onTap: () {
                    _controller.text = _sugerencias[index];
                    widget.onSearch(_sugerencias[index]);
                    setState(() {
                      _sugerencias = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }
}
