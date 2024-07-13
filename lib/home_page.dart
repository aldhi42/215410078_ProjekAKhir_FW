import 'package:flutter/material.dart';
import 'game_api.dart';
import 'game.dart';
import 'description.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Game>> futureGames;
  String searchQuery = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Mendapatkan data game dari API
    futureGames = GetApi.fetchGames();
  }

  // Membuat fungsi untuk memfilter game sesuai dengan query pencarian dan kategori
  List<Game> filterGames(List<Game> games) {
    return games.where((game) {
      final matchesSearch = game.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'All' || game.genre == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // digunakan untuk Mendapatkan ukuran layar sesuai dengan perangkat yang digunakan agar lebih responsive
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      //widget ini digunakan untuk membuat judul halaman pada appbar sesuai dengan nama tilte gamenya 
      appBar: AppBar(
        title: const Text('Daftar Game Gratis'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 220, 39, 39),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // widget Column untuk membuat layout vertikal
      body: Column(
        children: [
          // Padding digunakan mengatur jarak pada baris pencarian dan filter
          Padding(
            padding: const EdgeInsets.all(9.0),
            //digunakan untuk membuat widget yang ada didalamnya disusun secara horizontal
            child: Row(
              children: [
                // Expanded digunakan agar TextField mengisi ruang yang tersedia
                Expanded(
                  //widget ini digunakan untuk agar user bisa memasukan teks pada pencarian 
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                //widget ini digunakan untuk mengatur jarak dan ukuran lebar atau tinggi antara baris sesudah atau sebelumnya 
                const SizedBox(width: 8),
                // widget DropdownButton digunakan untuk menampilakn dan pilihan kategori
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: <String>['All', 'MMORPG', 'Shooter', 'Strategy', 'Card Game']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Expanded digunakan agar FutureBuilder mengisi ruang yang tersedia
          Expanded(
            //widget ini digunakan untuk mengatur agar posisi widget didalamnya fromatnya rata tengah
            child: Center(
              //widget ini digunakan untuk mengatur ukuran agar agar tata letak bisa responsif
              child: FutureBuilder<List<Game>>(
                future: futureGames,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No games found');
                  } else {
                    List<Game> games = filterGames(snapshot.data!);
                    //widget ini digunakan untuk mengatur ukuran agar agar tata letak bisa responsif
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Menggunakan GridView.builder untuk menampilkan daftar game dalam bentuk grid
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            // Menyesuaikan jumlah kolom berdasarkan ukuran layar
                            crossAxisCount: isSmallScreen ? 2 : 4,
                            childAspectRatio: 2 / 3,
                          ),
                          itemCount: games.length,
                          itemBuilder: (context, index) {
                            //widget ini digunakan untukek mendeteksi interaksi dari user ketika diklik
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Description(game: games[index]),
                                  ),
                                );
                              },
                              //widget ini digunakan untuk mengatur tata letak konten agar mudah diatur
                              child: Card(
                                // widget Column untuk membuat layout vertikal
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Menampilkan gambar thumbnail game
                                    Expanded(
                                      child: Image.network(
                                        games[index].thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    //widget ini digunakan untuk memberikan jarak antara tepi dengan widget yang didalamnya 
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      //widget ini digunakan untuk membuat tampilan secara vertikal
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Menampilkan judul game
                                          Text(
                                            games[index].title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          // Menampilkan deskripsi singkat game
                                          Text(
                                            games[index].shortDescription,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
