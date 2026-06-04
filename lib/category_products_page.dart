import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show CustomSemanticsAction;
import 'package:url_launcher/url_launcher.dart';
import 'services/favorites_service.dart';

// ─── Platform Enum ───────────────────────────────────────────────────────────

/// Platform ที่สินค้าวางขาย
enum ShopPlatform {
  shopee,
  lazada,
  tiktok,
  amazon,
  other;

  String get label {
    switch (this) {
      case ShopPlatform.shopee:
        return 'Shopee';
      case ShopPlatform.lazada:
        return 'Lazada';
      case ShopPlatform.tiktok:
        return 'TikTok Shop';
      case ShopPlatform.amazon:
        return 'Amazon';
      case ShopPlatform.other:
        return 'อื่นๆ';
    }
  }

  String get emoji {
    switch (this) {
      case ShopPlatform.shopee:
        return '🛒';
      case ShopPlatform.lazada:
        return '🛍️';
      case ShopPlatform.tiktok:
        return '🎵';
      case ShopPlatform.amazon:
        return '📦';
      case ShopPlatform.other:
        return '🏪';
    }
  }

  /// Brand color ของแต่ละ platform
  Color get color {
    switch (this) {
      case ShopPlatform.shopee:
        return const Color(0xFFEE4D2D);
      case ShopPlatform.lazada:
        return const Color(0xFF0F146D);
      case ShopPlatform.tiktok:
        return const Color(0xFF010101);
      case ShopPlatform.amazon:
        return const Color(0xFFFF9900);
      case ShopPlatform.other:
        return const Color(0xFF4A8A9A);
    }
  }

  /// Background color อ่อนๆ สำหรับ badge
  Color get bgColor {
    switch (this) {
      case ShopPlatform.shopee:
        return const Color(0xFFFFEDEA);
      case ShopPlatform.lazada:
        return const Color(0xFFE8E9F8);
      case ShopPlatform.tiktok:
        return const Color(0xFFE8E8E8);
      case ShopPlatform.amazon:
        return const Color(0xFFFFF3D6);
      case ShopPlatform.other:
        return const Color(0xFFE8F4F4);
    }
  }
}

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
  // Platform ที่สินค้าวางขาย เช่น Shopee, Lazada
  final ShopPlatform platform;

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
    this.platform = ShopPlatform.other,
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
      platform: ShopPlatform.shopee,
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
      platform: ShopPlatform.shopee,
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
      platform: ShopPlatform.shopee,
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
      platform: ShopPlatform.shopee,
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
      platform: ShopPlatform.shopee,
      features: [
        '- ชาร์จเร็วไร้สายสูงสุด 15W รองรับมาตรฐาน Qi2 Wireless Protocol ชาร์จไวทันใจ - ระบบจ่ายไฟอัจฉริยะ ปรับกำลังไฟอัตโนมัติตามอุปกรณ์ - แม่เหล็กดูดแน่น จัดตำแหน่งชาร์จง่ายไม่เลื่อนหลุด - ดีไซน์บางเฉียบ น้ำหนักเบา แค่ 55 กรัม พกพาสะดวก - วัสดุอลูมิเนียมอัลลอย แข็งแรง ทนทาน ระบายความร้อนได้ดี - สาย Type-C ยาว 1.2 เมตร ใช้งานยืดหยุ่น - ดีไซน์สวยหรู เข้ากับ iPhone และสมาร์ทโฟนที่รองรับการชาร์จไร้สาย',
      ],
    ),
    Product(
      name: 'คีย์บอร์ด Keychron K1X QMK ',
      description: 'Wireless Mechanical Keyboard ขนาด 80% - TH / EN',
      price: 3060,
      imageEmoji: '⌨️',
      imageUrl:
          'https://img.lazcdn.com/g/p/36068399309fab79ea97547972d5d35d.jpg_720x720q80.jpg',
      shopUrl:
          'https://www.lazada.co.th/products/keychron-k1x-qmk-wireless-mechanical-keyboard-80-th-en-i5711097064.html',
      rating: 4.8,
      isOfficial: false,
      storeName: 'iStudio by SPVi',
      platform: ShopPlatform.lazada,
      features: [
        'สัมผัสกับความพรีเมียมในขนาด TKL 80% ไปกับ คีย์บอร์ด Keychron K1 Max Wireless Mechanical Keyboard (EN/TH) ที่มาในสไตล์เรียบง่าย โคตรมินิมอล กับหน้าตาแบบ Low Profile ปุ่มแบนที่บางกว่าคีย์บอร์ดทั่ว ๆ ไปถึง 31% มากับสวิตช์ Low-Profile Gateron ให้สัมผัสการกดที่สนุกแม้จะบางเฉียบขนาดนี้ โดยจุดเด่นของเขาคือฟังก์ชันการตั้งค่าปุ่มกดผ่าน QMK และ VIA ที่สามารถตั้งค่าปุ่มกดได้อย่างอิสระ อยากให้ปุ่มไหนทำอะไรก็สามารถตั้งได้เลย ทุกปุ่ม! รวมไปถึงเอฟเฟกต์การเล่นของไฟ RGB ด้วย ซึ่งใครที่ชอบพกคีย์บอร์ดไปทำงานนอกบ้านก็บอกเลยว่าต้องหลงรักครับ เพราะเบาเพียง 609 กรัมที่มากับแบตอึดกว่า 1550 mAh ที่รองรับการใช้งานไร้สายได้นานกว่า 166 ชั่วโมง และเพื่อให้ตอบโจทย์การนั่งพิมพ์งานตลอดวัน จึงได้รับการออกแบบมาให้ Ergonomic ด้วยขาตั้งที่ปรับได้ 3 ระดับ ยกความสูงให้พิมพ์ได้สบายที่สุด นอกจากนี้ยังรองรับการใช้งานกับทุกระบบปฎิบัติการทั้ง Window MacOS และ Linux รวมไปถึงใช้งานกับอุปกรณ์สมาร์ทโฟนได้ด้วย เรียกได้ว่านี่คืออีก 1 แมคคานิคอลคีย์บอร์ดไร้สายที่บางที่สุดในโลก ที่คนชอบความกระทัดรัดปุ่มแบนไม่ควรพลาด',
      ],
    ),
    Product(
      name: 'ATK|เมาส์เกมมิ่งไร้สายแบบเออร์โกโนมิกส์สำหรับมืออาชีพ',
      description:
          'เมาส์เกมมิ่งไร้สายออกแบบตามหลักสรีรศาสตร์ เพื่อความสะดวกสบายในการใช้งานระยะยาว',
      price: 1676.68,
      imageEmoji: '',
      imageUrl:
          'https://img.lazcdn.com/g/p/e82f748d68a140ec546fe7fc87468138.png_360x360q80.png',
      shopUrl:
          'https://www.lazada.co.th/products/pdp-i6028296999-s26068473692.html?c=&channelLpJumpArgs=&clickTrackInfo=query%253Amouse%252Bgaming%253Bnid%253A6028296999%253Bsrc%253ALazadaMainSrp%253Brn%253A03e43957d813060fe12f4ea11010b010%253Bregion%253Ath%253Bsku%253A6028296999_TH%253Bprice%253A1862.98%253Bclient%253Adesktop%253Bsupplier_id%253A100218378775%253Bsession_id%253A%253Bbiz_source%253Ah5_hp%253Bslot%253A0%253Butlog_bucket_id%253A470687%253Basc_category_id%253A7436%253Bitem_id%253A6028296999%253Bsku_id%253A26068473692%253Bshop_id%253A3347322%253BtemplateInfo%253A-1_A3_C%2523155383_D_E_G%2523&freeshipping=1&fs_ab=2&fuse_fs=&lang=th&location=Hong%20Kong&price=1862.98&priceCompare=skuId%3A26068473692%3Bsource%3Alazada-search-voucher%3Bsn%3A03e43957d813060fe12f4ea11010b010%3BoriginPrice%3A186298%3BdisplayPrice%3A186298%3BisGray%3Afalse%3BsinglePromotionId%3A900000896862011%3BsingleToolCode%3AmillionSubsidy%3BvoucherPricePlugin%3A0%3Btimestamp%3A1780387538181&qSellingPoint=p--gaming&ratingscore=4.809210526315789&request_id=03e43957d813060fe12f4ea11010b010&review=252&sale=993&search=1&source=search&spm=a2o4m.searchlist.list.0&stock=1',
      rating: 4.8,
      isOfficial: true,
      storeName: 'ElecHome Concept Store',
      platform: ShopPlatform.lazada,
      features: [
        'เมาส์เกมมิ่งไร้สายออกแบบตามหลักสรีรศาสตร์ เพื่อความสะดวกสบายในการใช้งานระยะยาว ความละเอียดเซ็นเซอร์สูงถึง 8000 DPI ตอบสนองอย่างแม่นยำสำหรับเกมเมอร์มืออาชีพ เชื่อมต่อแบบไร้สายช่วยเพิ่มความคล่องตัวและลดความยุ่งยากจากสายเคเบิล เหมาะสำหรับการเล่นเกมและการทำงานที่ต้องการความแม่นยำและความรวดเร็ว',
      ],
    ),
    Product(
      name: 'HOCO CW63 แท่นชาร์จไร้สายยย',
      description: 'ที่ชาร์จ Wireless 15W สำหรับมือถือ',
      price: 392,
      imageEmoji: '🔋',
      imageUrl:
          'https://img.lazcdn.com/g/ff/kf/Sd953ae8383d540dbbbd1a9ed99aec5b9q.jpg_960x960q80.jpg_.webp',
      shopUrl:
          'https://www.lazada.co.th/products/hoco-cw63-15w-qi2-c-dock-12m-tws-ip16-15-13-pro-max-i5837130194.html',
      rating: 5,
      isOfficial: true,
      storeName: 'hoco by Firemax',
      platform: ShopPlatform.lazada,
      features: [
        '- ชาร์จเร็วไร้สายสูงสุด 15W รองรับมาตรฐาน Qi2 Wireless Protocol ชาร์จไวทันใจ - ระบบจ่ายไฟอัจฉริยะ ปรับกำลังไฟอัตโนมัติตามอุปกรณ์ - แม่เหล็กดูดแน่น จัดตำแหน่งชาร์จง่ายไม่เลื่อนหลุด - ดีไซน์บางเฉียบ น้ำหนักเบา แค่ 55 กรัม พกพาสะดวก - วัสดุอลูมิเนียมอัลลอย แข็งแรง ทนทาน ระบายความร้อนได้ดี - สาย Type-C ยาว 1.2 เมตร ใช้งานยืดหยุ่น - ดีไซน์สวยหรู เข้ากับ iPhone และสมาร์ทโฟนที่รองรับการชาร์จไร้สาย',
      ],
    ),
    Product(
      name: 'ปลั๊กไฟสามตา พร้อมช่อง USB ปลั๊กไฟ 4ช่อง',
      description:
          'พร้อมส่งปลั๊กไฟสามตา พร้อมช่อง USB ปลั๊กไฟ 4ช่อง ปลั๊กพ่วง ปลั๊กไฟUSB รางปลั๊กไฟ กันไฟสองชั้นปลั๊กไฟ 3ม./5ม./8ม PW739',
      price: 60,
      imageEmoji: '',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcSU1PwEHPBbJVje0mRmTr2TRDK508ADJbtONIxizGKr7Z5knxRfVWUqMS0e4mEDLE9orH9Xng3VblR8vTSajQ1kXwtmg9-3X_VsYVk8mcntaJpqQVihjHHVO4xsfDLE&usqp=CAc',
      shopUrl:
          'https://www.lazada.co.th/products/pdp-i5760133807-s24539728116.html?pvid=a08b1f10-cc9b-41d3-94c8-d75df63c141a&search=jfy&scm=1007.17519.492200.0&priceCompare=skuId%3A24539728116%3Bsource%3Atpp-recommend-plugin-32104%3Bsn%3Aa08b1f10-cc9b-41d3-94c8-d75df63c141a%3BoriginPrice%3A6000%3BdisplayPrice%3A6000%3BsinglePromotionId%3A-1%3BsingleToolCode%3AmockedSalePrice%3BvoucherPricePlugin%3A0%3Btimestamp%3A1780542129883&spm=a2o4m.homepage.just4u.d_5760133807',
      rating: 5,
      isOfficial: true,
      storeName: 'hodo',
      platform: ShopPlatform.lazada,
      features: [
        'สายยาว 3/5/8 เมตรเต็ม ปลั๊กไฟบ้าน ช่องเสียบ USB แรงดันสูงสุด 10 แอมป์ 250V ใช้ไฟบ้าน Max 2300W วัสดุแข็งแรงสวยงาม สายไฟหนาแข็งแรง มีช่องเสียบ พร้อมแสดงสถานะการทำงาน ขั่วสัมผัส L/N วัสดุทองแดงแท้ นำไฟฟ้าได้ดี เต้ารับป้องกันไม่ลามไฟ สวิตช์แยกช่องใช้งาน พร้อมแบรกเกอร์ ตัดไฟ กำลังไฟสูงสุดที่รองรับ 2300 วัตต์ สายไฟขนาดมาตราฐาน 5*0.75 mm. แข็งแรงทนทาน ใช้งานภายในอาคารห้ามโดยน้ำ หลังเลิกใช้งานควรถอดเก็บให้เรียบร้อย ห้ามสัมผัสขนาดมือเปียก เสียบปลั๊กให้แน่นทุกครั้ง หากุดสายไฟเกิดความร้อนควรหยุดใช้งาน ไม่ควรต่อพ่วงกับสายไฟฟ้าแรงสูง สามารถใช้กับคอมพิวเตอร์, ทีวี, ตู้เย็น, โทรศัพท์และเครื่องใช้ไฟฟ้าทั่วไปทั้งหมด ข้อควรระวัง 1. ควรปิดสวิตต์เครื่องใช้ไฟฟ้าก่อนเสียบปลั๊กทุกครั้ง ถอดปลั๊กทุกครั้งหลังใช้งานเสร็จ 2. ไม่ควรนำรางปลั๊กพ่วงไปยึดติดแบบถาวร 3. ไม่ควรใช้งานขณะปลั๊กหรือสายไฟชำรุด 4. ไม่ควรใช้ปลั๊กพ่วงกับเครื่องใช้ไฟฟ้าขนาดใหญ่',
      ],
    ),
    Product(
      name: 'Mitsubishi รีโมทแอร์',
      description:
          'Mitsubishi รีโมทแอร์ ใช้กับแอร์มิตซูบิชิ รุ่น ขอบจอสีบรอนซ์เงิน ตัวรีโมทสีขาว',
      price: 200,
      imageEmoji: '',
      imageUrl:
          'data:image/webp;base64,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',
      shopUrl:
          'https://www.lazada.co.th/products/pdp-i1453900837-s3788874817.html?pvid=6434ace7-b3ea-471a-98bb-324592a10cfd&search=jfy&scm=1007.17519.492200.0&priceCompare=skuId%3A3788874817%3Bsource%3Atpp-recommend-plugin-32104%3Bsn%3A6434ace7-b3ea-471a-98bb-324592a10cfd%3BoriginPrice%3A7200%3BdisplayPrice%3A7200%3BsinglePromotionId%3A-1%3BsingleToolCode%3AmockedSalePrice%3BvoucherPricePlugin%3A0%3Btimestamp%3A1780546452545&spm=a2o4m.homepage.just4u.d_1453900837',
      rating: 4.8,
      isOfficial: false,
      storeName: 'SUNFAY STUDIO',
      platform: ShopPlatform.lazada,
      features: [
        'รีโมทแอร์ มิตซูบิชิ Mitsubishi รุ่นMr.Slim Econo Air การใช้งาน : ใช้งานแทนรีโมทที่เสีย/หาย ใส่ถ่านใช้งานได้เลย**',
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
      platform: ShopPlatform.shopee,
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
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q) ||
              p.storeName.toLowerCase().contains(q),
        )
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
                  ],
                ),
              ),
              Semantics(
                label: _isSearching ? 'ปิดการค้นหา' : 'ค้นหาสินค้า',
                button: true,
                child: GestureDetector(
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
                      Icons.search_rounded,
                      color: Color(0xFF3A7CA5),
                      size: 22,
                    ),
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
              child: Semantics(
                label: 'ช่องค้นหาสินค้า',
                textField: true,
                excludeSemantics: true,
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  style: const TextStyle(
                    color: Color(0xFF2A5F6F),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ค้นหาสินค้า...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF5BA3B0).withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                    prefixIcon: ExcludeSemantics(
                      child: Icon(
                        Icons.search_rounded,
                        color: Color(0xFF5BA3B0),
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                ),
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
  final _favService = FavoritesService();

  String _formatPrice(double price) {
    if (price == price.toInt().toDouble()) {
      return '฿${price.toInt()}';
    }
    return '฿${price.toStringAsFixed(2)}';
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

  Future<void> _toggleFav(BuildContext context, Product p) async {
    final added = await _favService.toggleFavorite(p);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            added
                ? 'เพิ่ม "${p.name}" ในรายการโปรดแล้ว'
                : 'ลบ "${p.name}" ออกจากรายการโปรดแล้ว',
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
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return StreamBuilder<bool>(
      stream: _favService.isFavorite(p),
      builder: (context, snap) {
        final isFav = snap.data ?? false;
        final cardLabel = [
          p.name,
          'ร้าน ${p.storeName}',
          if (p.isOfficial) 'ร้านค้าทางการ',
          'วางขายบน ${p.platform.label}',
          'คะแนนรีวิว ${p.rating} จาก 5',
          'ราคา ${p.price == p.price.toInt().toDouble() ? p.price.toInt() : p.price.toStringAsFixed(2)} บาท',
        ].join(', ');

        return Semantics(
          label: cardLabel,
          button: true,
          excludeSemantics: true,
          customSemanticsActions: {
            CustomSemanticsAction(
              label: isFav ? 'ลบออกจากรายการโปรด' : 'เพิ่มในรายการโปรด',
            ): () =>
                _toggleFav(context, p),
          },
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
            ),
            child: AnimatedScale(
              scale: _pressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
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
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 110,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFE8F4F4,
                            ).withValues(alpha: 0.6),
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
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                letterSpacing: 0.1,
                              ),
                            ),
                            const SizedBox(height: 3),
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
                            const SizedBox(height: 4),
                            _PlatformBadge(platform: p.platform, compact: true),
                            const Spacer(),
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
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF3A7CA5,
                                      ).withValues(alpha: 0.1),
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
                                const SizedBox(width: 6),
                                ExcludeSemantics(
                                  child: GestureDetector(
                                    onTap: () => _toggleFav(context, p),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: isFav
                                            ? const Color(
                                                0xFFE05C7A,
                                              ).withValues(alpha: 0.15)
                                            : Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.08,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isFav
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        color: const Color(0xFFE05C7A),
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
      },
    );
  }
}

// ─── Product Detail Page ────────────────────────────────────────────────────

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _favService = FavoritesService();

  Product get product => widget.product;

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
            child: Text(
              'รายละเอียดสินค้า',
              style: TextStyle(
                color: Color(0xFF2A5F6F),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // ── Favorite button in detail header ─────────────────────────
          StreamBuilder<bool>(
            stream: _favService.isFavorite(product),
            builder: (context, snap) {
              final isFav = snap.data ?? false;
              return Semantics(
                label: 'รายการโปรด',
                button: true,
                onTap: () async {
                  final added = await _favService.toggleFavorite(product);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          added
                              ? 'เพิ่ม "${product.name}" ในรายการโปรดแล้ว'
                              : 'ลบ "${product.name}" ออกจากรายการโปรดแล้ว',
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
                // ExcludeSemantics ป้องกัน GestureDetector สร้าง node ซ้ำ
                child: ExcludeSemantics(
                  child: GestureDetector(
                    onTap: () async {
                      final added = await _favService.toggleFavorite(product);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              added
                                  ? 'เพิ่ม "${product.name}" ในรายการโปรดแล้ว'
                                  : 'ลบ "${product.name}" ออกจากรายการโปรดแล้ว',
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isFav
                            ? const Color(0xFFE05C7A).withValues(alpha: 0.12)
                            : Colors.white.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isFav
                              ? const Color(0xFFE05C7A).withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: const Color(0xFFE05C7A),
                        size: 22,
                      ),
                    ),
                  ), // GestureDetector
                ), // ExcludeSemantics
              );
            },
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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

          // Platform badge
          _PlatformBadge(platform: product.platform),
          const SizedBox(height: 12),

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

// ─── Platform Badge Widget ────────────────────────────────────────────────────────

class _PlatformBadge extends StatelessWidget {
  final ShopPlatform platform;

  /// compact = true สำหรับใน product card (ขนาดเล็ก)
  final bool compact;

  const _PlatformBadge({required this.platform, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final color = platform.color;
    final bg = platform.bgColor;
    final label = platform.label;
    final semanticLabel = 'วางขายบน $label';

    if (compact) {
      return Semantics(
        label: semanticLabel,
        excludeSemantics: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      );
    }

    // Full size สำหรับ detail page
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'วางขายบน',
              style: TextStyle(
                color: color.withValues(alpha: 0.75),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
