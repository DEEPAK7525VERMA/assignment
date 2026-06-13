import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_detail_screen.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().fetchProducts(refresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductViewModel>().fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                _debouncer.run(() {
                  context.read<ProductViewModel>().searchProducts(value);
                });
              },
            ),
          ),
          
          Expanded(
            child: Consumer<ProductViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading && viewModel.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.products.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: viewModel.products.length + (viewModel.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == viewModel.products.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final product = viewModel.products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.thumbnail,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.image_not_supported, size: 60),
                          ),
                        ),
                        title: Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(
                            viewModel.isInWishlist(product.id) 
                                ? Icons.favorite 
                                : Icons.favorite_border,
                            color: viewModel.isInWishlist(product.id) 
                                ? Colors.red 
                                : Colors.grey,
                          ),
                          onPressed: () {
                            viewModel.toggleWishlist(product.id);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}