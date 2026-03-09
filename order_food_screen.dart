import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

class OrderFoodScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;
  const OrderFoodScreen({super.key, this.arguments});

  @override
  State<OrderFoodScreen> createState() => _OrderFoodScreenState();
}

class _OrderFoodScreenState extends State<OrderFoodScreen> {
  String selectedCategory = "Main Course";
  final List<String> categories = ["Main Course", "Snacks", "Beverages"];
  final List<Map<String, dynamic>> cart = [];
  double total = 0;
  bool _showSearch = false;
  final _searchController = TextEditingController();
  String? _searchQuery;
  bool _showFloatingCart = false;
  
  Map<String, dynamic> get _bookingData => widget.arguments ?? {};

  final List<Map<String, dynamic>> foodItems = [
    {
      "name": "Paneer Butter Masala",
      "description": "Rich and creamy paneer curry with butter and spices",
      "price": 150,
      "type": "Main Course",
      "isVeg": true,
      "rating": 4.7,
      "icon": Icons.restaurant
    },
    {
      "name": "Veg Biryani",
      "description": "Aromatic rice dish with mixed vegetables and spices",
      "price": 120,
      "type": "Main Course",
      "isVeg": true,
      "rating": 4.5,
      "icon": Icons.rice_bowl
    },
    {
      "name": "Chicken Biryani",
      "description": "Classic chicken biryani with basmati rice and spices",
      "price": 200,
      "type": "Main Course",
      "isVeg": false,
      "rating": 4.8,
      "icon": Icons.rice_bowl
    },
    {
      "name": "Egg Curry",
      "description": "Flavorful curry with boiled eggs in tomato gravy",
      "price": 140,
      "type": "Main Course",
      "isVeg": false,
      "rating": 4.3,
      "icon": Icons.egg
    },
    {
      "name": "Samosa Plate",
      "description": "Crispy triangular pastry filled with spiced potatoes",
      "price": 50,
      "type": "Snacks",
      "isVeg": true,
      "rating": 4.1,
      "icon": Icons.change_history
    },
    {
      "name": "Spring Roll",
      "description": "Crispy rolls filled with vegetables and noodles",
      "price": 80,
      "type": "Snacks",
      "isVeg": true,
      "rating": 4.2,
            "icon": Icons.restaurant
    },
    {
      "name": "Cold Drink",
      "description": "Refreshing carbonated beverages",
      "price": 40,
      "type": "Beverages",
      "isVeg": true,
      "rating": 4.0,
      "icon": Icons.local_drink
    },
    {
      "name": "Masala Chai",
      "description": "Traditional Indian spiced tea",
      "price": 30,
      "type": "Beverages",
      "isVeg": true,
      "rating": 4.4,
      "icon": Icons.coffee
    },
    {
      "name": "Coffee",
      "description": "Fresh brewed coffee",
      "price": 60,
      "type": "Beverages",
      "isVeg": true,
      "rating": 4.4,
      "icon": Icons.coffee
    },
  ];

  // Fields already declared above

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
      total += item['price'];
      _showFloatingCart = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item['name']} added to cart"),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () => _showCart(),
        ),
      ),
    );

    // Hide floating cart after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showFloatingCart = false);
      }
    });
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => buildCart(),
    );
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    if (_searchQuery?.isEmpty ?? true) {
      return foodItems.where((item) => item['type'] == selectedCategory).toList();
    }
    return foodItems.where((item) {
      return item['name'].toLowerCase().contains(_searchQuery!.toLowerCase()) ||
          item['description'].toLowerCase().contains(_searchQuery!.toLowerCase());
    }).toList();
  }
  
  void _showSkipConfirmation() {
    if (cart.isEmpty) {
      _proceedToConfirmation();
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.info_outline),
        title: const Text('Skip Food Order?'),
        content: Text(
          cart.isEmpty
              ? 'Continue without ordering food?'
              : 'You have ${cart.length} item(s) in your cart. Do you want to skip the food order?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              setState(() => cart.clear());
              _proceedToConfirmation();
            },
            icon: const Icon(Icons.skip_next),
            label: const Text('Skip'),
          ),
        ],
      ),
    );
  }
  
  void _proceedToConfirmation() {
    // Calculate food total
    final foodTotal = cart.fold<double>(0, (sum, item) => sum + (item['price'] as num).toDouble());
    final ticketTotal = (_bookingData['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final grandTotal = ticketTotal + foodTotal;
    
    // Show success notification
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                cart.isEmpty 
                  ? 'Proceeding to booking confirmation...' 
                  : 'Food order confirmed! Total: ₹${grandTotal.toStringAsFixed(0)}',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Navigate to confirmation after delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/booking-confirmation',
          arguments: {
            ..._bookingData,
            'foodOrders': cart,
            'foodTotal': foodTotal,
            'grandTotal': grandTotal,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final filteredItems = _getFilteredItems();

    return Scaffold(
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search food items...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _showSearch = false;
                      });
                    },
                  ),
                ),
                autofocus: true,
              )
            : Text('Order Food', style: textTheme.titleLarge),
        actions: [
          if (!_showSearch)
            TextButton.icon(
              onPressed: () => _showSkipConfirmation(),
              icon: const Icon(Icons.skip_next),
              label: const Text('Skip'),
            ),
          IconButton(
            icon: Icon(
              _showSearch ? Icons.search : Icons.search,
              color: colorScheme.onSurface,
            ),
            onPressed: () => setState(() => _showSearch = !_showSearch),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: colorScheme.onSurface,
                ),
                onPressed: _showCart,
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.length.toString(),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onError,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_showSearch) ...[
            // Categories
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => setState(() => selectedCategory = category),
                    ),
                  );
                },
              ),
            ).animate().fadeIn().slideX(),
          ],

          // Food Items
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.no_food,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items found',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => addToCart(item),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Item Icon and Type Indicator
                                Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        color: colorScheme.primary,
                                        size: 32,
                                      ),
                                    ),
                                    Positioned(
                                      right: 4,
                                      top: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: item['isVeg']
                                              ? colorScheme.primaryContainer
                                              : colorScheme.errorContainer,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Icon(
                                          item['isVeg']
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_unchecked,
                                          size: 14,
                                          color: item['isVeg']
                                              ? colorScheme.primary
                                              : colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                
                                // Item Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['description'],
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            size: 16,
                                            color: colorScheme.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['rating'].toString(),
                                            style: textTheme.labelMedium?.copyWith(
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Text(
                                            '₹${item['price']}',
                                            style: textTheme.titleSmall?.copyWith(
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Add Button
                                IconButton.filled(
                                  onPressed: () => addToCart(item),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn().slideX();
                    },
                  ),
          ),
        ],
      ),
      
      // Bottom Action Buttons
      bottomNavigationBar: cart.isEmpty
          ? Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => _showSkipConfirmation(),
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Continue Without Food'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You can add food items later',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn().slideY(begin: 1, end: 0)
          : null,
      
      // Floating Cart Button
      floatingActionButton: _showFloatingCart && cart.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showCart,
              icon: const Icon(Icons.shopping_cart_checkout),
              label: Text('${cart.length} items'),
            ).animate().scale()
          : null,
    );
  }

  // Cart View
  Widget buildCart() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    if (cart.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.remove_shopping_cart, size: 64, color: colorScheme.secondary),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add some delicious food items to your cart',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Cart Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Your Cart',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(width: 8),
                if (cart.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${cart.length} items',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                const Spacer(),
                if (cart.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => setState(() => cart.clear()),
                    icon: Icon(Icons.delete),
                    label: const Text('Clear'),
                  ),
              ],
            ),
          ),
          // Cart List
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              itemCount: cart.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: colorScheme.primary,
                    ),
                  ),
                  title: Text(item['name']),
                  subtitle: Text(
                    '₹${item['price']}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  trailing: IconButton.outlined(
                    onPressed: () => setState(() => cart.removeAt(index)),
                    icon: const Icon(Icons.close),
                  ),
                );
              },
            ),
          ),
          // Order Summary
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        '₹${cart.fold<double>(0, (sum, item) => sum + item['price'])}',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _proceedToConfirmation();
                    },
                    icon: const Icon(Icons.shopping_cart_checkout),
                    label: Text(cart.isEmpty ? 'Continue Without Food' : 'Proceed to Checkout'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                  if (cart.isNotEmpty)
                    const SizedBox(height: 8),
                  if (cart.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSkipConfirmation();
                      },
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Skip Food Order'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 1, end: 0);
  }
}
