import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/widgets/image_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/utils/constants.dart';
import '../models/product_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/category_circle_avatar.dart';
import '../widgets/product_card.dart';
import '../widgets/responsive_widget.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider); // Direct user
    final session = ref.watch(sessionProvider); // Current session
    final isAuthenticated = session != null;

    Wrap buildDesktopDealsSection() {
      return Wrap(
        spacing: 24,
        runSpacing: 24,
        children: productList.map((p) {
          final product = Product.fromMap(p);
          return SizedBox(
            width: 300,
            child: ProductCard(product: product, onTap: () {}),
          );
        }).toList(),
      );
    }

    Wrap buildTabDealsSection() {
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: productList.map((p) {
          final product = Product.fromMap(p);
          return SizedBox(
            width: 250,
            child: ProductCard(product: product, onTap: () {}),
          );
        }).toList(),
      );
    }

    Wrap buildMobileDealsSection() {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: productList.map((p) {
          final product = Product.fromMap(p);
          return SizedBox(
            width: 180,
            child: ProductCard(product: product, onTap: () {}),
          );
        }).toList(),
      );
    }

    return Scaffold(
      // 🔹 Left Drawer (Burger Menu)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.orange),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Menu",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  if (isAuthenticated && user != null)
                    Text(
                      user.email ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("My Orders"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                context.go('/profile');
              },
            ),
            const Divider(),
            if (!isAuthenticated) ...[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Login"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                    shadowColor: Colors.black,
                    elevation: 5,
                    side: const BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Sign Up"),
                ),
              ),
            ]
            else ...[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final authService = ref.read(authServiceProvider);
                    await authService.logout(context);
                    if (context.mounted) {
                      Navigator.pop(context);
                      context.go('/');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Logout"),
                ),
              ),
            ],
          ],
        ),
      ),

      // 🔹 Right Drawer (Cart)

      endDrawer:Drawer(
        child: Consumer(
          builder: (context, ref, child) {
            final cartProducts = ref.watch(cartNotifierProvider);
            final cartProductsRead = ref.read(cartNotifierProvider.notifier);
            final total = ref.watch(cartTotalProvider); // cart total as double

            final formatter = NumberFormat.currency(
              locale: 'en_BD', // Bangladesh locale
              symbol: 'BDT ',
              decimalDigits: 2,
            );

            if (cartProducts.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }

            return Column(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.orange),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My Cart",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Text(
                        "${cartProducts.length} items",
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      return ListTile(
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            product.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          product.newPrice,
                          style: const TextStyle(color: Colors.orange),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cartProductsRead.removeFromCart(product);
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Cart total
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatter.format(total), // formatted double
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkout button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to checkout or perform action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Checkout",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),




        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            // 🔹 Ribbon Above AppBar
            Expanded(
              child: Container(
                height: 35,
                color: Colors.orange,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text(
                  "আমাদের যে কোন পণ্য অর্ডার করতে কল বা WhatsApp করুন: +8801321208940 | হটলাইন: 09642-922922",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // 🔹 Main AppBar
            Expanded(
              child: AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo.webp",
                      height: 50,
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                  Builder(
                    builder: (context) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                        // Circle for cart count
                        Positioned(
                          right: 0,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Center(
                              child: Text(
                                '${ref.watch(cartNotifierProvider).length}', // <-- Replace '0' with cart count from provider
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageCarousel(),
            SizedBox(height: 20,),
            // const Text(
            //   "Welcome to the Store!",
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 20),
            // if (isAuthenticated && user != null)
            //   Text(
            //     "Logged in as: ${user.email}",
            //     style: const TextStyle(fontSize: 16),
            //   )
            // else
            //   const Text(
            //     "You are not logged in",
            //     style: TextStyle(fontSize: 16),
            //   ),
            Column(
              children: [
                Text(
                  "Shop by Category",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 80,
                  runSpacing: 80,
                  alignment: WrapAlignment.start,
                  children: categoriesList.map((category) {
                    return CategoryCircleAvatar(
                      imagePath: category["imagePath"],
                      category: category["category"],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
            SizedBox(height: 30,),
            // All Products
            Column(
              children: [
                Text("Deals of the Day", style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(height: 32),
                ResponsiveWidget(
                  mobile: buildMobileDealsSection(),
                  tab: buildTabDealsSection(),
                  desktop: buildDesktopDealsSection(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
