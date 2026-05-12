import 'package:flutter/material.dart';
import 'category_products_page.dart';
import 'services/favorites_service.dart';

// ─── Favorites Page ─────────────────────────────────────────────────────────

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  final _service = FavoritesService();
  late AnimationController _animCtrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2D8D8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: FadeTransition(
                opacity: _fade,
                child: StreamBuilder<List<Product>>(
                  stream: _service.getFavorites(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3A7CA5),
                        ),
                      );
                    }
                    final products = snapshot.data ?? [];
                    if (products.isEmpty) return _buildEmpty();
                    return _buildGrid(products);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Semantics(
            label: 'ย้อนกลับ',
            button: true,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF3A7CA5),
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รายการโปรด',
                  style: TextStyle(
                    color: Color(0xFF2A5F6F),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'สินค้าที่คุณบันทึกไว้',
                  style: TextStyle(
                    color: Color(0xFF4A8A9A),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4F4).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFFE05C7A),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────────

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE05C7A).withValues(alpha: 0.15),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.favorite_border_rounded,
                color: Color(0xFFE05C7A),
                size: 46,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'ยังไม่มีรายการโปรด',
            style: TextStyle(
              color: Color(0xFF2A5F6F),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'กดปุ่ม ❤️ บนสินค้าที่ชอบเพื่อบันทึกไว้ที่นี่',
            style: TextStyle(
              color: const Color(0xFF4A8A9A).withValues(alpha: 0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Product Grid ────────────────────────────────────────────────────────────

  Widget _buildGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + index * 70),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 24 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: _FavoriteProductCard(product: products[index]),
        );
      },
    );
  }
}

// ─── Favorite Product Card (with remove button) ──────────────────────────────

class _FavoriteProductCard extends StatefulWidget {
  final Product product;

  const _FavoriteProductCard({required this.product});

  @override
  State<_FavoriteProductCard> createState() => _FavoriteProductCardState();
}

class _FavoriteProductCardState extends State<_FavoriteProductCard> {
  bool _pressed = false;
  final _service = FavoritesService();

  String _formatPrice(double price) {
    if (price == price.toInt().toDouble()) return '฿${price.toInt()}';
    return '฿${price.toStringAsFixed(2)}';
  }

  Widget _buildImage(Product p) {
    if (p.imageUrl != null) {
      final isNetwork = p.imageUrl!.startsWith('http');
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: isNetwork
            ? Image.network(
                p.imageUrl!,
                width: double.infinity,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Center(
                  child: Text(p.imageEmoji,
                      style: const TextStyle(fontSize: 48)),
                ),
              )
            : Image.asset(
                p.imageUrl!,
                width: double.infinity,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Center(
                  child: Text(p.imageEmoji,
                      style: const TextStyle(fontSize: 48)),
                ),
              ),
      );
    }
    return Center(
        child: Text(p.imageEmoji, style: const TextStyle(fontSize: 48)));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Semantics(
      label: [
        p.name,
        'ร้าน ${p.storeName}',
        'คะแนนรีวิว ${p.rating} คะแนน',
        'ราคา ${p.price == p.price.toInt().toDouble() ? p.price.toInt() : p.price.toStringAsFixed(2)} บาท',
      ].join(', '),
      button: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
          );
        },
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7FB5B5).withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image + remove button ───────────────────────────────────
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4F4).withValues(alpha: 0.6),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: _buildImage(p),
                  ),
                  // Official badge
                  if (p.isOfficial)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A73E8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded,
                                color: Colors.white, size: 10),
                            SizedBox(width: 3),
                            Text(
                              'Official',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Remove from favorites button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Semantics(
                      label: 'ลบออกจากรายการโปรด',
                      button: true,
                      onTap: () async {
                        await _service.toggleFavorite(p);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'ลบ "${p.name}" ออกจากรายการโปรดแล้ว',
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color(0xFF3A7CA5),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                      child: GestureDetector(
                        onTap: () async {
                          await _service.toggleFavorite(p);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'ลบ "${p.name}" ออกจากรายการโปรดแล้ว',
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: const Color(0xFF3A7CA5),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const ExcludeSemantics(
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Color(0xFFE05C7A),
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Product Info ─────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF2A5F6F),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.storefront_rounded,
                              size: 11,
                              color: const Color(0xFF4A8A9A)
                                  .withValues(alpha: 0.7)),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              p.storeName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF4A8A9A)
                                    .withValues(alpha: 0.75),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFF5A623), size: 13),
                          const SizedBox(width: 3),
                          Text(
                            p.rating.toString(),
                            style: const TextStyle(
                              color: Color(0xFF4A8A9A),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A7CA5).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formatPrice(p.price),
                          style: const TextStyle(
                            color: Color(0xFF3A7CA5),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
