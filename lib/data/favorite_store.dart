import 'package:flutter/foundation.dart';
import '../screens/home.dart';

/// Penyimpanan negara yang ditandai favorit.
///
/// Dibuat dengan pola yang sama seperti HistoryStore supaya halaman Home dan
/// halaman Favorit membaca daftar yang sama tanpa melewatkan parameter.
class FavoriteStore {
  FavoriteStore._();

  static final FavoriteStore instance = FavoriteStore._();

  final ValueNotifier<List<Country>> items = ValueNotifier<List<Country>>([]);

  bool contains(Country country) =>
      items.value.any((c) => c.name == country.name);

  /// Menambahkan atau melepas tanda favorit pada satu negara.
  void toggle(Country country) {
    final list = List<Country>.from(items.value);
    if (list.any((c) => c.name == country.name)) {
      list.removeWhere((c) => c.name == country.name);
    } else {
      list.insert(0, country);
    }
    items.value = list;
  }

  void remove(Country country) {
    final list = List<Country>.from(items.value)
      ..removeWhere((c) => c.name == country.name);
    items.value = list;
  }

  void clear() {
    items.value = [];
  }
}
