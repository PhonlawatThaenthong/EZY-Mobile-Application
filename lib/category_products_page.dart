import 'package:flutter/material.dart';

// ─── Product Data Model ─────────────────────────────────────────────────────

class Product {
  final String name;
  final String description;
  final double price;
  final String imageEmoji;
  final double rating;
  final bool isOfficial;
  final String storeName;
  final List<String> features;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageEmoji,
    this.rating = 4.5,
    this.isOfficial = false,
    this.storeName = 'ร้านค้าทั่วไป',
    this.features = const [],
  });
}

// ─── Sample Products per Category ───────────────────────────────────────────

final Map<String, List<Product>> categoryProducts = {
  'สั่งซื้อสินค้าออนไลน์': [
    Product(
      name: 'หูฟังไร้สาย',
      description: 'หูฟัง Bluetooth 5.3 เสียงดี แบตอึด',
      price: 990,
      imageEmoji: '🎧',
      rating: 4.7,
      isOfficial: true,
      storeName: 'Sony Official Store',
      features: [
        'เชื่อมต่อ Bluetooth 5.3 ระยะ 10 เมตร',
        'แบตเตอรี่ใช้งานได้ 30 ชั่วโมง',
        'ตัดเสียงรบกวน Active Noise Cancelling',
        'กันน้ำระดับ IPX4',
        'ชาร์จเร็ว 10 นาที ฟัง 1 ชั่วโมง',
      ],
    ),
    Product(
      name: 'เคสมือถือ',
      description: 'เคสกันกระแทก สำหรับ iPhone/Android',
      price: 299,
      imageEmoji: '📱',
      rating: 4.5,
      isOfficial: false,
      storeName: 'TechCase Shop',
      features: [
        'กันกระแทกได้ในระดับทหาร MIL-STD-810G',
        'รองรับ MagSafe ชาร์จไร้สาย',
        'ขอบนูนป้องกันหน้าจอและกล้อง',
        'วัสดุ TPU + Polycarbonate',
      ],
    ),
    Product(
      name: 'สายชาร์จ USB-C',
      description: 'สายชาร์จเร็ว 65W ยาว 1.5m',
      price: 199,
      imageEmoji: '🔌',
      rating: 4.4,
      isOfficial: false,
      storeName: 'CablePro',
      features: [
        'รองรับการชาร์จเร็ว 65W PD',
        'ความยาว 1.5 เมตร ใช้งานสะดวก',
        'รองรับ Data Transfer 480Mbps',
        'ทนทาน โค้งงอได้ 10,000 ครั้ง',
      ],
    ),
    Product(
      name: 'เมาส์ไร้สาย',
      description: 'เมาส์ Wireless เงียบ ประหยัดถ่าน',
      price: 450,
      imageEmoji: '🖱️',
      rating: 4.3,
      isOfficial: true,
      storeName: 'Logitech Official',
      features: [
        'คลิกเงียบลด 90% เหมาะทำงานออฟฟิศ',
        'ถ่าน AA 1 ก้อน ใช้ได้นาน 18 เดือน',
        'เชื่อมต่อผ่าน USB Nano Receiver',
        'ปรับ DPI ได้ 1000/1600/2400',
        'ใช้ได้กับ Windows, macOS, Linux',
      ],
    ),
    Product(
      name: 'แท่นชาร์จไร้สาย',
      description: 'ที่ชาร์จ Wireless 15W สำหรับมือถือ',
      price: 590,
      imageEmoji: '🔋',
      rating: 4.6,
      isOfficial: true,
      storeName: 'Anker Official Store',
      features: [
        'ชาร์จไร้สายสูงสุด 15W (Qi2)',
        'รองรับ iPhone, Samsung, Pixel',
        'ตรวจจับสิ่งแปลกปลอมอัตโนมัติ',
        'LED แสดงสถานะการชาร์จ',
        'มาพร้อม Adapter 20W ในกล่อง',
      ],
    ),
    Product(
      name: 'กระเป๋าเป้',
      description: 'กระเป๋าเป้กันน้ำ ช่องใส่โน้ตบุ๊ก 15.6"',
      price: 890,
      imageEmoji: '🎒',
      rating: 4.6,
      isOfficial: false,
      storeName: 'BagWorld',
      features: [
        'ผ้ากันน้ำ 600D Oxford สุดทน',
        'ช่องโน้ตบุ๊ก 15.6" บุนวมรอบด้าน',
        'ช่องด้านหน้าใส่ของใช้จุกจิก',
        'สายรัดหน้าอกและเอวปรับได้',
        'พอร์ต USB ชาร์จมือถือได้จากภายนอก',
      ],
    ),
  ],
};

// ─── Category Products Page ─────────────────────────────────────────────────

class CategoryProductsPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryProductsPage({super.key, required this.categoryTitle});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  bool _isSearching = false;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Product> get _products {
    final all = categoryProducts[widget.categoryTitle] ?? [];
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.storeName.toLowerCase().contains(q))
        .toList();
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
                child: _products.isEmpty ? _buildEmpty() : _buildProductGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (_isSearching) {
                    setState(() {
                      _isSearching = false;
                      _searchQuery = '';
                      _searchCtrl.clear();
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isSearching ? Icons.close_rounded : Icons.arrow_back_ios_new_rounded,
                    color: const Color(0xFF3A7CA5),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.categoryTitle,
                      style: const TextStyle(
                        color: Color(0xFF2A5F6F),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_products.length} สินค้า',
                      style: TextStyle(
                        color: const Color(0xFF4A8A9A).withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _isSearching = !_isSearching);
                  if (!_isSearching) {
                    _searchQuery = '';
                    _searchCtrl.clear();
                  }
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _isSearching
                        ? const Color(0xFF3A7CA5).withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF3A7CA5),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          if (_isSearching) ...[
            const SizedBox(height: 10),
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                autofocus: true,
                style: const TextStyle(color: Color(0xFF2A5F6F), fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'ค้นหาสินค้า...',
                  hintStyle: TextStyle(
                    color: const Color(0xFF5BA3B0).withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF5BA3B0), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (v) => setState(() => _searchQuery = v.trim()),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    final isFiltered = _searchQuery.isNotEmpty;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isFiltered ? '🔍' : '📦', style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            isFiltered ? 'ไม่พบสินค้าที่ค้นหา' : 'ยังไม่มีสินค้าในหมวดนี้',
            style: const TextStyle(
              color: Color(0xFF4A8A9A),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isFiltered) ...[
            const SizedBox(height: 6),
            Text(
              '"$_searchQuery"',
              style: TextStyle(
                color: const Color(0xFF4A8A9A).withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.65,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 350 + index * 80),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: _ProductCard(product: _products[index]),
        );
      },
    );
  }
}

// ─── Product Card ───────────────────────────────────────────────────────────

class _ProductCard extends StatefulWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _pressed = false;

  String _formatPrice(double price) {
    if (price == price.toInt().toDouble()) {
      return '฿${price.toInt()}';
    }
    return '฿${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return GestureDetector(
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
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.7),
                blurRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image area with official badge ──────────────────────────
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
                    child: Center(
                      child: Text(
                        p.imageEmoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                  if (p.isOfficial)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A73E8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 10,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Official',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // ── Product Info ────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF2A5F6F),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Store name
                      Row(
                        children: [
                          Icon(
                            Icons.storefront_rounded,
                            size: 11,
                            color: const Color(
                              0xFF4A8A9A,
                            ).withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              p.storeName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(
                                  0xFF4A8A9A,
                                ).withValues(alpha: 0.75),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Rating row
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFF5A623),
                            size: 13,
                          ),
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

                      // Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
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
    );
  }
}

// ─── Product Detail Page ────────────────────────────────────────────────────

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  String _formatPrice(double price) {
    if (price == price.toInt().toDouble()) {
      return '฿${price.toInt()}';
    }
    return '฿${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2D8D8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroImage(),
                    const SizedBox(height: 16),
                    _buildInfoCard(),
                    const SizedBox(height: 14),
                    _buildFeaturesCard(),
                    const SizedBox(height: 20),
                    _buildBuyButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
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
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'รายละเอียดสินค้า',
              style: TextStyle(
                color: Color(0xFF2A5F6F),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7FB5B5).withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              product.imageEmoji,
              style: const TextStyle(fontSize: 90),
            ),
          ),
          if (product.isOfficial)
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.verified_rounded, color: Colors.white, size: 13),
                    SizedBox(width: 5),
                    Text(
                      'Official Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7FB5B5).withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name & rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    color: Color(0xFF2A5F6F),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFF5A623),
                      size: 15,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      product.rating.toString(),
                      style: const TextStyle(
                        color: Color(0xFFE6920A),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Store name
          Row(
            children: [
              Icon(
                Icons.storefront_rounded,
                size: 14,
                color: const Color(0xFF4A8A9A).withValues(alpha: 0.8),
              ),
              const SizedBox(width: 6),
              Text(
                product.storeName,
                style: TextStyle(
                  color: const Color(0xFF4A8A9A).withValues(alpha: 0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (product.isOfficial) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF1A73E8),
                  size: 15,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            product.description,
            style: TextStyle(
              color: const Color(0xFF4A8A9A).withValues(alpha: 0.9),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Price
          Row(
            children: [
              const Text(
                'ราคา',
                style: TextStyle(color: Color(0xFF4A8A9A), fontSize: 14),
              ),
              const Spacer(),
              Text(
                _formatPrice(product.price),
                style: const TextStyle(
                  color: Color(0xFF3A7CA5),
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    if (product.features.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7FB5B5).withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.checklist_rounded, color: Color(0xFF3A7CA5), size: 20),
              SizedBox(width: 8),
              Text(
                'สินค้านี้ทำอะไรได้บ้าง',
                style: TextStyle(
                  color: Color(0xFF2A5F6F),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...product.features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3A7CA5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      f,
                      style: const TextStyle(
                        color: Color(0xFF3A6070),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3A7CA5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_rounded, size: 20),
            SizedBox(width: 10),
            Text(
              'หยิบใส่ตะกร้า',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
