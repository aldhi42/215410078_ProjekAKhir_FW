import 'package:flutter/material.dart';
import 'game.dart';

class Description extends StatelessWidget {
  final Game game;

  const Description({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // digunakan untuk Mendapatkan ukuran layar sesuai dengan perangkat yang digunakan
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      //widget ini digunakan untuk membuat judul halaman pada appbar sesuai dengan nama tilte gamenya 
      appBar: AppBar(
        title: Text(game.title),
      ),
      //widget ini digunakan untuk membuat konten yang berada didalam body bisa discroll/digulir 
      body: SingleChildScrollView(
        //widget ini digunakan untuk memberikan jarak antara tepi widget dengan widget yang ada didalamnya 
        padding: const EdgeInsets.all(16.0),
        //widget ini digunakan untuk mengatur yang ada didalamnya dalam satu kolom secara vertikal 
        //yang diatur secara sejajar dan diatur dari kiri ke kanan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //digunakan Menampilkan gambar thumbnail game
            Image.network(game.thumbnail),
            //widget ini digunakan untuk mengatur jarak dan ukuran lebar atau tinggi antara baris sesudah atau sebelumnya 
            const SizedBox(height: 8.0),
            // digunakan Menampilkan judul game
            Text(
              game.title,
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // digunakan Menampilkan deskripsi singkat game
            Text(
              game.shortDescription,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            const SizedBox(height: 8.0),
            //digunakan Menampilkan genre game
            Text(
              'Genre: ${game.genre}',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // digunakan Menampilkan platform game
            Text(
              'Platform: ${game.platform}',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            //digunakan Menampilkan tanggal rilis game
            Text(
              'Release Date: ${game.releaseDate}',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            //widget ini digunakan untuk mengatur jarak dan ukuran lebar atau tinggi antara baris sesudah atau sebelumnya 
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
