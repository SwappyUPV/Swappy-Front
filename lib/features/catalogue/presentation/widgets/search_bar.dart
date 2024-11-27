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
    return Stack(
      children: [
        // El contenido de la página, que no se desplazará
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 40,
                child: Align(
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(
                      fontFamily: 'UrbaneExtraLight',
                      fontSize: 14, // Usar la fuente personalizada
                    ),
                    decoration: InputDecoration(
                      hintText: 'Busca una prenda o estilo...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(208, 220, 228, 1),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Las sugerencias que se mostrarán encima
        if (_sugerencias.isNotEmpty)
          Positioned(
            top:
                75, // Ajusta esta posición para que las sugerencias no cubran el campo de búsqueda
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap:
                      true, // Para que la lista se ajuste al tamaño del contenido
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
