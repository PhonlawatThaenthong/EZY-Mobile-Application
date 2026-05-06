import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Product Data Model ─────────────────────────────────────────────────────

class Product {
  final String name;
  final String description;
  final double price;
  final String imageEmoji;
  // Network URL (https://...) or local asset path (assets/...). Falls back to imageEmoji if null/error.
  final String? imageUrl;
  // External shop link e.g. Shopee, Lazada. Opens in browser when tapping the buy button.
  final String? shopUrl;
  final double rating;
  final bool isOfficial;
  final String storeName;
  final List<String> features;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageEmoji,
    this.imageUrl,
    this.shopUrl,
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
      price: 129,
      imageEmoji: '🎧',
      // ใส่ imageUrl เป็น URL รูปจาก Line หรือ path ของ assets ได้เลย เช่น:
      imageUrl:
          'https://down-th.img.susercontent.com/file/sg-11134201-7renm-m860w0hl1a5jbe@resize_w900_nl.webp',
      // imageUrl: 'assets/images/headphone.png',
      shopUrl:
          'https://shopee.co.th/X55-TWS-%E0%B8%AB%E0%B8%B9%E0%B8%9F%E0%B8%B1%E0%B8%87%E0%B9%84%E0%B8%A3%E0%B9%89%E0%B8%AA%E0%B8%B2%E0%B8%A2%E0%B8%AA%E0%B9%80%E0%B8%95%E0%B8%AD%E0%B8%A3%E0%B8%B4%E0%B9%82%E0%B8%AD-%E0%B8%81%E0%B8%B1%E0%B8%99%E0%B8%99%E0%B9%89%E0%B8%B3-i.1587426339.41465035967?extraParams=%7B%22display_model_id%22%3A281244495223%2C%22model_selection_logic%22%3A3%7D&rModelId=281244495223&sp_atk=0e926dc7-450c-421c-b7ca-90008d7b38db&vItemId=43819134795&vModelId=291568677719&vShopId=1449018616&xptdk=0e926dc7-450c-421c-b7ca-90008d7b38db',
      rating: 4.9,
      isOfficial: false,
      storeName: 'dongbao',
      features: [
        'หูฟังไร้สาย TWS X55 สำหรับการฟังเพลงระหว่างนอนหลับ ด้วยการออกแบบที่สวมใส่สบาย ไม่ก่อให้เกิดการระคายเคือง เหมาะสำหรับการฟังเพลงหรือเสียงผ่อนคลายขณะนอนหลับ 🎶 เพิ่มความสะดวกสบายในการใช้งานด้วยฟังก์ชันชาร์จเร็ว ⚡ ทนทานต่อน้ำด้วยระดับ IPX5 ทำให้สามารถใช้งานได้ในสภาพอากาศที่หลากหลาย 💧 ตัวเลือกสี: สีกากี, สีชมพู, สีม่วง, สีฟ้า, สีขาว และสีดำ 🎨 เหมาะสำหรับการใช้งานทั่วไปและการออกกำลังกาย 🏋️‍♂️',
      ],
    ),
    Product(
      name: 'เคสมือถือ',
      description: 'เคสกันกระแทก สำหรับ iPhone/Android',
      price: 129,
      imageEmoji: '📱',
      imageUrl:
          'https://down-th.img.susercontent.com/file/cn-11134207-7ras8-m7k9w3oyfj1qbe@resize_w900_nl.webp',
      shopUrl:
          'https://shopee.co.th/POP-MART-DIMOO-WORLD-%C3%97-DISNEY-Series-Phone-Case-for-iPhone-15-Pro-Max-16-Pro-16-Pro-Max-i.569947420.26230225539?extraParams=%7B%7D',
      rating: 5.0,
      isOfficial: true,
      storeName: 'popmartofficial.th',
      features: [
        'Product Name: DIMOO WORLD x DISNEY Series-Phone Case',
        'Main Material: Silicone/PVC/Aluminum Sheet',
        'ขอบนูนป้องกันหน้าจอและกล้อง',
        'Product Size: Mobile Phone Same Size',
      ],
    ),
    Product(
      name: 'สายชาร์จ USB-C',
      description: 'สายชาร์จเร็ว 65W ยาว 1.5m',
      price: 4,
      imageEmoji: '🔌',
      imageUrl:
          'https://down-th.img.susercontent.com/file/th-11134207-7r98x-m015hgs4sip53c@resize_w900_nl.webp',
      shopUrl:
          'https://shopee.co.th/UGREEN-Uno-%E0%B8%AA%E0%B8%B2%E0%B8%A2%E0%B8%8A%E0%B8%B2%E0%B8%A3%E0%B9%8C%E0%B8%88-100W-USB-C-to-USB-C-%E0%B8%A3%E0%B8%AD%E0%B8%87%E0%B8%A3%E0%B8%B1%E0%B8%9A-PD-%E0%B8%8A%E0%B8%B2%E0%B8%A3%E0%B9%8C%E0%B8%88%E0%B9%80%E0%B8%A3%E0%B9%87%E0%B8%A7-%E0%B8%AA%E0%B9%8D%E0%B8%B2%E0%B8%AB%E0%B8%A3%E0%B8%B1%E0%B8%9A-iPhone-16-Series-Samsung-S24-%E0%B8%A3%E0%B8%B8%E0%B9%88%E0%B8%99-L509-i.361518092.26011039280?extraParams=%7B%22display_model_id%22%3A241569812660%2C%22model_selection_logic%22%3A3%7D&sp_atk=5f9dac49-e8a6-435c-9be3-a3fa1520c0da&xptdk=5f9dac49-e8a6-435c-9be3-a3fa1520c0da',
      rating: 5.0,
      isOfficial: true,
      storeName: 'Ugreen Thailand',
      features: [
        '1.ชาร์จเร็ว 100W : รองรับการชาร์จเร็วสูงสุด 100W สามารถชาร์จ MacBook Pro ได้ถึง 55% ภายใน 35 นาที',
        '2.ดีไซน์แข็งแรงและทนทาน : สายเคเบิลถูกทดสอบการงอมากกว่า 10,000 ครั้ง พร้อมการเชื่อมด้วยเลเซอร์ เพื่อเพิ่มความทนทานต่อการใช้งานระยะยาว',
        '3.รองรับอุปกรณ์หลากหลาย : สาย USB-C to USB-C รองรับการชาร์จและโอนถ่ายข้อมูลให้กับอุปกรณ์กว่า 1,000 รุ่น เช่น โทรศัพท์, แล็ปท็อป, แท็บเล็ต',
        '4.ชิพ E-Marker อัจฉริยะ : มาพร้อมชิพ E-Marker ที่ตรวจสอบและปรับกำลังไฟอัตโนมัติ รองรับกำลังไฟ 87W, 65W, 30W, และ 20W ตามที่อุปกรณ์ต้องการ',
        '5.โอนถ่ายข้อมูลความเร็วสูง : รองรับการโอนถ่ายข้อมูลที่ความเร็วสูงสุด 480 Mbps',
        '6.รองรับ PD 3.0 : สามารถชาร์จ iPhone 16 Pro จาก 0% ถึง 42% ในเวลาเพียง 30 นาที ด้วยการรองรับ Power Delivery 3.0',
        '7.สายถักเพื่อความยืดหยุ่นและป้องกันการขาด : ตัวสายถักเพิ่มความยืดหยุ่นและป้องกันการพันหรือขาดง่าย',
      ],
    ),
    Product(
      name: 'เมาส์ไร้สาย Logitech Gaming Mouse Pro 2 Lightspeed Wireless',
      description: 'เมาส์ Wireless เงียบ ประหยัดถ่าน',
      price: 4590,
      imageEmoji: '🖱️',
      imageUrl:
          'https://down-th.img.susercontent.com/file/th-11134207-81zte-mgbvhqcnuv4a42.webp',
      shopUrl:
          'https://shopee.co.th/%E0%B9%80%E0%B8%A1%E0%B8%B2%E0%B8%AA%E0%B9%8C%E0%B9%80%E0%B8%81%E0%B8%A1%E0%B8%A1%E0%B8%B4%E0%B9%88%E0%B8%87-Logitech-Gaming-Mouse-Pro-2-Lightspeed-Wireless-by-Banana-IT-i.22507473.47300599741?extraParams=%7B%22display_model_id%22%3A297112671580%2C%22model_selection_logic%22%3A3%7D&sp_atk=9e0358e4-acbb-4e5d-b96d-a378619139be&xptdk=9e0358e4-acbb-4e5d-b96d-a378619139be',
      rating: 0,
      isOfficial: false,
      storeName: 'BaNANA Online SHOP',
      features: [
        '• Wireless technology : 2.4GHz Wireless • Sensor technology : HERO 2 • Sensor Resolution : Up to 44,000 DPI • Number of buttons : 4-8 buttons • Scroll Whell : >88 G 2Tested on Logitech G640 Gaming Mouse Pad • Tilt scroll function : N/A • Battery Life : (constant motion) 5Battery life varies with use conditions Default lighting : 60 h , Lighting off : 95 h • Battery Type : N/A • Wireless Operating Distance : 2.4GHz Wireless • Interface : PC with Windows 10 or later and USB 2.0 port (Optional) Internet access for Logitech G HUB Software • Dimensions W x D x H : 125 x 63.5 x 40 mm. • Color : Black / White • Warranty : 2-Year Limited Hardware Warranty • Option : Technical Specifications Onboard memory 1Advanced features require Logitech G HUB Software available for download at logitechg.com/ghub • Macro Keys : N/A • Click life span : N/A',
      ],
    ),
    Product(
      name: 'HOCO CW63 แท่นชาร์จไร้สาย',
      description: 'ที่ชาร์จ Wireless 15W สำหรับมือถือ',
      price: 1320,
      imageEmoji: '🔋',
      imageUrl:
          'https://down-th.img.susercontent.com/file/sg-11134201-7rdyv-mbxp87hntu8e35@resize_w900_nl.webp',
      shopUrl:
          'https://shopee.co.th/HOCO-CW63-%E0%B9%81%E0%B8%97%E0%B9%88%E0%B8%99%E0%B8%8A%E0%B8%B2%E0%B8%A3%E0%B9%8C%E0%B8%88%E0%B9%84%E0%B8%A3%E0%B9%89%E0%B8%AA%E0%B8%B2%E0%B8%A2-Qi2-%E0%B8%8A%E0%B8%B2%E0%B8%A3%E0%B9%8C%E0%B8%88%E0%B9%80%E0%B8%A3%E0%B9%87%E0%B8%A7%E0%B8%AA%E0%B8%B9%E0%B8%87%E0%B8%AA%E0%B8%B8%E0%B8%94-15W-%E0%B9%81%E0%B8%A1%E0%B9%88%E0%B9%80%E0%B8%AB%E0%B8%A5%E0%B9%87%E0%B8%81%E0%B8%94%E0%B8%B9%E0%B8%94%E0%B9%81%E0%B8%99%E0%B9%88%E0%B8%99-%E0%B9%83%E0%B8%8A%E0%B9%89%E0%B8%87%E0%B8%B2%E0%B8%99%E0%B8%87%E0%B9%88%E0%B8%B2%E0%B8%A2-Wireless-Charger-hc6-i.1218278547.40157754763?extraParams=%7B%22display_model_id%22%3A258607998183%2C%22model_selection_logic%22%3A3%7D&sp_atk=d9e0e809-96e5-4cc6-8c88-190757cde1ab&xptdk=d9e0e809-96e5-4cc6-8c88-190757cde1ab',
      rating: 4.8,
      isOfficial: true,
      storeName: 'HOCO',
      features: [
        '- ชาร์จเร็วไร้สายสูงสุด 15W รองรับมาตรฐาน Qi2 Wireless Protocol ชาร์จไวทันใจ - ระบบจ่ายไฟอัจฉริยะ ปรับกำลังไฟอัตโนมัติตามอุปกรณ์ - แม่เหล็กดูดแน่น จัดตำแหน่งชาร์จง่ายไม่เลื่อนหลุด - ดีไซน์บางเฉียบ น้ำหนักเบา แค่ 55 กรัม พกพาสะดวก - วัสดุอลูมิเนียมอัลลอย แข็งแรง ทนทาน ระบายความร้อนได้ดี - สาย Type-C ยาว 1.2 เมตร ใช้งานยืดหยุ่น - ดีไซน์สวยหรู เข้ากับ iPhone และสมาร์ทโฟนที่รองรับการชาร์จไร้สาย',
      ],
    ),
    Product(
      name: 'MENSPE ผู้ชายแล็ปท็อปกระเป๋าเป้สะพายหลัง',
      description: 'กระเป๋าเป้กันน้ำ ช่องใส่โน้ตบุ๊ก 15.6"',
      price: 300,
      imageEmoji: '🎒',
      imageUrl:
          'https://down-th.img.susercontent.com/file/cn-11134207-7ras8-md4gpjwsiye400@resize_w900_nl.webp',
      shopUrl:
          'https://shopee.co.th/MENSPE-%E0%B8%9C%E0%B8%B9%E0%B9%89%E0%B8%8A%E0%B8%B2%E0%B8%A2%E0%B9%81%E0%B8%A5%E0%B9%87%E0%B8%9B%E0%B8%97%E0%B9%87%E0%B8%AD%E0%B8%9B%E0%B8%81%E0%B8%A3%E0%B8%B0%E0%B9%80%E0%B8%9B%E0%B9%8B%E0%B8%B2%E0%B9%80%E0%B8%9B%E0%B9%89%E0%B8%AA%E0%B8%B0%E0%B8%9E%E0%B8%B2%E0%B8%A2%E0%B8%AB%E0%B8%A5%E0%B8%B1%E0%B8%87%E0%B9%80%E0%B8%94%E0%B8%B4%E0%B8%99%E0%B8%97%E0%B8%B2%E0%B8%87%E0%B8%81%E0%B8%A3%E0%B8%B0%E0%B9%80%E0%B8%9B%E0%B9%8B%E0%B8%B2%E0%B9%80%E0%B8%9B%E0%B9%89%E0%B8%AA%E0%B8%B0%E0%B8%9E%E0%B8%B2%E0%B8%A2%E0%B8%AB%E0%B8%A5%E0%B8%B1%E0%B8%87%E0%B8%98%E0%B8%B8%E0%B8%A3%E0%B8%81%E0%B8%B4%E0%B8%88%E0%B8%81%E0%B8%A3%E0%B8%B0%E0%B9%80%E0%B8%9B%E0%B9%8B%E0%B8%B2%E0%B8%A7%E0%B8%B4%E0%B8%97%E0%B8%A2%E0%B8%B2%E0%B8%A5%E0%B8%B1%E0%B8%A2%E0%B8%81%E0%B8%A3%E0%B8%B0%E0%B9%80%E0%B8%9B%E0%B9%8B%E0%B8%B2%E0%B9%80%E0%B8%9B%E0%B9%89%E0%B8%AA%E0%B8%B0%E0%B8%9E%E0%B8%B2%E0%B8%A2%E0%B8%AB%E0%B8%A5%E0%B8%B1%E0%B8%87-%E0%B8%A2%E0%B8%B9%E0%B9%80%E0%B8%AD%E0%B8%AA%E0%B8%9A%E0%B8%B5-%E0%B8%8A%E0%B8%B2%E0%B8%A3%E0%B9%8C%E0%B8%88%E0%B8%81%E0%B8%A3%E0%B8%B0%E0%B9%80%E0%B8%9B%E0%B9%8B%E0%B8%B2%E0%B8%AA%E0%B8%B0%E0%B8%9E%E0%B8%B2%E0%B8%A2%E0%B9%84%E0%B8%AB%E0%B8%A5%E0%B9%88%E0%B9%80%E0%B8%94-i.881968656.25846274686?extraParams=%7B%22display_model_id%22%3A260994779081%2C%22model_selection_logic%22%3A3%7D&sp_atk=26d466f5-5fad-4c06-a34f-547838f67f93&xptdk=26d466f5-5fad-4c06-a34f-547838f67f93',
      rating: 4.8,
      isOfficial: true,
      storeName: 'MENSPE',
      features: [
        'วัสดุคุณภาพสูง: ผลิตจากผ้าโพลีเอสเตอร์คุณภาพสูงน้ำหนักเบาและระบายอากาศได้ดีทนต่อการสึกหรอและป้องกันรอยขีดข่วนกันน้ำ น้ำหนักเบาและความจุขนาดใหญ่: ไม่เพียง แต่สามารถใส่ของใช้ในชีวิตประจำวันเช่นแล็ปท็อปเสื้อผ้าร่มหนังสือ ฯลฯ ►ความจุขนาดใหญ่: กระเป๋าเป้มีกระเป๋าซิปสามช่องช่องใส่คอมพิวเตอร์และกระเป๋าด้านข้างหนึ่งช่องและสไตล์สีทึบด้านนอกของกระเป๋าแสดงถึงแฟชั่นและบุคลิกภาพ กระเป๋าเป้สำหรับผู้ชายและผู้หญิงนี้เหมาะสำหรับทุกโอกาส: กระเป๋าเป้สำหรับผู้ชายและผู้หญิงนี้เหมาะสำหรับโรงเรียนทำงานท่องเที่ยวเดินป่าปีนเขาและตั้งแคมป์',
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
              Semantics(
                label: _isSearching ? 'ปิดการค้นหา' : 'ย้อนกลับ',
                button: true,
                child: GestureDetector(
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

  String _priceLabel(double price) {
    final amount = price == price.toInt().toDouble()
        ? '${price.toInt()}'
        : price.toStringAsFixed(2);
    return 'ราคา $amount บาท';
  }

  Widget _buildImage(Product p, double emojiSize) {
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
                  child: Text(
                    p.imageEmoji,
                    style: TextStyle(fontSize: emojiSize),
                  ),
                ),
              )
            : Image.asset(
                p.imageUrl!,
                width: double.infinity,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Center(
                  child: Text(
                    p.imageEmoji,
                    style: TextStyle(fontSize: emojiSize),
                  ),
                ),
              ),
      );
    }
    return Center(
      child: Text(p.imageEmoji, style: TextStyle(fontSize: emojiSize)),
    );
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
                    child: _buildImage(p, 48),
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
                      Semantics(
                        label: 'คะแนนรีวิว ${p.rating} คะแนน',
                        excludeSemantics: true,
                        child: Row(
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
                      ),
                      const SizedBox(height: 6),

                      // Price
                      Semantics(
                        label: _priceLabel(p.price),
                        excludeSemantics: true,
                        child: Container(
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

  String _priceLabel(double price) {
    final amount = price == price.toInt().toDouble()
        ? '${price.toInt()}'
        : price.toStringAsFixed(2);
    return 'ราคา $amount บาท';
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

  Widget _buildDetailImage() {
    if (product.imageUrl != null) {
      final isNetwork = product.imageUrl!.startsWith('http');
      return isNetwork
          ? Image.network(
              product.imageUrl!,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Center(
                child: Text(
                  product.imageEmoji,
                  style: const TextStyle(fontSize: 90),
                ),
              ),
            )
          : Image.asset(
              product.imageUrl!,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Center(
                child: Text(
                  product.imageEmoji,
                  style: const TextStyle(fontSize: 90),
                ),
              ),
            );
    }
    return Center(
      child: Text(product.imageEmoji, style: const TextStyle(fontSize: 90)),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: _buildDetailImage(),
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
              Semantics(
                label: 'คะแนนรีวิว ${product.rating} คะแนน',
                excludeSemantics: true,
                child: Container(
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
          Semantics(
            label: _priceLabel(product.price),
            excludeSemantics: true,
            child: Row(
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
    final hasLink = product.shopUrl != null;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: hasLink
            ? () async {
                final messenger = ScaffoldMessenger.of(context);
                final uri = Uri.parse(product.shopUrl!);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('ไม่สามารถเปิดลิงค์ได้')),
                  );
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3A7CA5),
          disabledBackgroundColor: const Color(
            0xFF3A7CA5,
          ).withValues(alpha: 0.4),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasLink ? Icons.open_in_new_rounded : Icons.link_off_rounded,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              hasLink ? 'สั่งซื้อสินค้า' : 'ไม่มีลิงค์สั่งซื้อ',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
