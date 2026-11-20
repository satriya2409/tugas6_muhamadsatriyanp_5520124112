
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MODEL DATA MAKANAN
class Food {
  final String name;
  final int price;
  final String description;
  final String image;

  const Food({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Menu',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF9F3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7043),
        ),
      ),
      home: const FoodPage(),
    );
  }
}

// HALAMAN DAFTAR MAKANAN
class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final ScrollController _scrollController = ScrollController();

  bool _showBackToTopButton = false;
  bool isGrid = false;

  final List<Food> foods = [
    const Food(
      name: 'Nasi Goreng Spesial',
      price: 25000,
      description: 'Nasi goreng dengan telur, ayam, dan bumbu pilihan.',
      image:
          'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=600',
    ),
    const Food(
      name: 'Mie Goreng',
      price: 18000,
      description: 'Mie goreng lezat dengan sayuran dan telur.',
      image:
          'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=600',
    ),
    const Food(
      name: 'Sate Ayam',
      price: 30000,
      description: 'Sate ayam bakar dengan saus kacang spesial.',
      image:
          'https://images.unsplash.com/photo-1529563021893-cc83c992d75d?w=600',
    ),
    const Food(
      name: 'Burger Beef',
      price: 35000,
      description: 'Burger daging sapi dengan keju dan sayuran segar.',
      image:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600',
    ),
    const Food(
      name: 'Pizza',
      price: 55000,
      description: 'Pizza dengan topping keju, sosis, dan saus tomat.',
      image:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600',
    ),
    const Food(
      name: 'Ayam Geprek',
      price: 22000,
      description: 'Ayam crispy dengan sambal pedas khas Indonesia.',
      image:
          'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600',
    ),
    const Food(
      name: 'Ramen',
      price: 32000,
      description: 'Mie ramen dengan kuah gurih dan telur.',
      image:
          'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600',
    ),
    const Food(
      name: 'Pancake',
      price: 20000,
      description: 'Pancake lembut dengan topping buah dan sirup.',
      image:
          'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=600',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 250) {
        if (!_showBackToTopButton) {
          setState(() {
            _showBackToTopButton = true;
          });
        }
      } else {
        if (_showBackToTopButton) {
          setState(() {
            _showBackToTopButton = false;
          });
        }
      }
    });
  }

  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  // PULL TO REFRESH
  Future<void> refreshFoods() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daftar makanan berhasil diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // KEMBALI KE ATAS
  void scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  // NAVIGASI KE HALAMAN DETAIL
  void openDetail(Food food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailPage(food: food),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7043),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text(
              'Food Menu',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Tampilan List',
            icon: const Icon(Icons.view_list),
            onPressed: () {
              setState(() {
                isGrid = false;
              });
            },
          ),
          IconButton(
            tooltip: 'Tampilan Grid',
            icon: const Icon(Icons.grid_view),
            onPressed: () {
              setState(() {
                isGrid = true;
              });
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        color: const Color(0xFFFF7043),
        onRefresh: refreshFoods,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF7043),
                        Color(0xFFFFA270),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.fastfood,
                        color: Colors.white,
                        size: 42,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Mau Makan Apa Hari Ini?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Temukan berbagai makanan lezat dengan harga terbaik!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // JUDUL DAN JUMLAH MENU
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Makanan',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      '${foods.length} Menu',
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 15),
            ),

            // TAMPILAN LIST ATAU GRID
            if (isGrid)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return buildGridCard(foods[index]);
                    },
                    childCount: foods.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return buildListCard(foods[index]);
                    },
                    childCount: foods.length,
                  ),
                ),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 25),
            ),
          ],
        ),
      ),

      // TOMBOL KEMBALI KE ATAS
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              onPressed: scrollToTop,
              backgroundColor: const Color(0xFFFF7043),
              foregroundColor: Colors.white,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }

  // KARTU TAMPILAN LIST
  Widget buildListCard(Food food) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openDetail(food),
        child: Row(
          children: [
            Image.network(
              food.image,
              width: 125,
              height: 145,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 125,
                  height: 145,
                  color: Colors.orange.shade100,
                  child: const Icon(Icons.restaurant, size: 40),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      food.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formatRupiah(food.price),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Lihat Detail →',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // KARTU TAMPILAN GRID
  Widget buildGridCard(Food food) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openDetail(food),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                food.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.orange.shade100,
                    child: const Center(
                      child: Icon(Icons.restaurant, size: 40),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formatRupiah(food.price),
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Lihat Detail →',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HALAMAN DETAIL MAKANAN
class FoodDetailPage extends StatelessWidget {
  final Food food;

  const FoodDetailPage({
    super.key,
    required this.food,
  });

  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7043),
        foregroundColor: Colors.white,
        title: const Text(
          'Detail Makanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GAMBAR MAKANAN
            Image.network(
              food.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.orange.shade100,
                  child: const Icon(
                    Icons.restaurant,
                    size: 80,
                    color: Colors.deepOrange,
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAMA MAKANAN
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // HARGA
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE0D2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sell,
                          color: Colors.deepOrange,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          formatRupiah(food.price),
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // DESKRIPSI
                  const Text(
                    'Deskripsi Makanan',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    food.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // TOMBOL KEMBALI
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text(
                        'Kembali ke Daftar Makanan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7043),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
