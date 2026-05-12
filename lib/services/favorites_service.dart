import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../category_products_page.dart';

/// Manages the current user's favorite products in Firestore.
/// Collection path: users/{uid}/favorites/{productKey}
class FavoritesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Returns the favorites sub-collection for the signed-in user,
  /// or null when no user is authenticated.
  CollectionReference<Map<String, dynamic>>? get _col {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('favorites');
  }

  /// A stable document key derived from the product name (lowercased, spaces → _).
  String _key(Product p) =>
      p.name.toLowerCase().replaceAll(RegExp(r'\s+'), '_');

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Streams whether [product] is currently in the user's favorites.
  Stream<bool> isFavorite(Product product) {
    final col = _col;
    if (col == null) return Stream.value(false);
    return col
        .doc(_key(product))
        .snapshots()
        .map((snap) => snap.exists);
  }

  /// Adds or removes [product] from the user's favorites.
  /// Returns the new state: `true` = added, `false` = removed.
  Future<bool> toggleFavorite(Product product) async {
    final col = _col;
    if (col == null) return false;

    final ref = col.doc(_key(product));
    final snap = await ref.get();

    if (snap.exists) {
      await ref.delete();
      return false;
    } else {
      await ref.set({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageEmoji': product.imageEmoji,
        'imageUrl': product.imageUrl,
        'shopUrl': product.shopUrl,
        'rating': product.rating,
        'isOfficial': product.isOfficial,
        'storeName': product.storeName,
        'features': product.features,
        'savedAt': FieldValue.serverTimestamp(),
      });
      return true;
    }
  }

  /// Streams the list of all favorited products for the current user,
  /// ordered by the time they were saved (newest first).
  Stream<List<Product>> getFavorites() {
    final col = _col;
    if (col == null) return Stream.value([]);
    return col
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_docToProduct).toList());
  }

  // ── Conversion ─────────────────────────────────────────────────────────────

  Product _docToProduct(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Product(
      name: d['name'] as String? ?? '',
      description: d['description'] as String? ?? '',
      price: (d['price'] as num?)?.toDouble() ?? 0,
      imageEmoji: d['imageEmoji'] as String? ?? '📦',
      imageUrl: d['imageUrl'] as String?,
      shopUrl: d['shopUrl'] as String?,
      rating: (d['rating'] as num?)?.toDouble() ?? 0,
      isOfficial: d['isOfficial'] as bool? ?? false,
      storeName: d['storeName'] as String? ?? '',
      features: List<String>.from(d['features'] as List? ?? []),
    );
  }
}
