import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class CatalogueAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          // FutureBuilder(
          //   future: FirebaseStorage.instance.ref('swappy.png').getDownloadURL(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done &&
          //         snapshot.hasData) {
          //       return Image.network(
          //         snapshot.data as String,
          //         height: 30,
          //       );
          //     }
          //     return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtiene la URL
          //   },
          // ),
          SizedBox(width: 10),
          Text('Catálogo', style: TextStyle(color: Colors.black)),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.favorite_border, color: Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pantalla de favoritos no implementada')),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
