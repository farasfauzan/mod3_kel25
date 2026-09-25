import 'package:flutter/foundation.dart';
import '../screens/home.dart';

/// Penyimpanan riwayat negara yang pernah dibuka.
///
/// Dibuat singleton supaya halaman Home dan halaman Riwayat membaca
/// daftar yang sama tanpa perlu oper parameter antar halaman.
class HistoryStore {
  HistoryStore._();

  static final HistoryStore instance = HistoryStore._();

  /// Negara terbaru ada di urutan paling atas.
  final ValueNotifier<List<Country>> items = ValueNotifier<List<Country>>([]);

  void add(Country country) {
    final list = List<Country>.from(items.value);
    // Negara yang sama tidak diduplikasi, cukup dipindah ke paling atas.
    list.removeWhere((c) => c.name == country.name);
    list.insert(0, country);
    items.value = list;
  }

  void clear() {
    items.value = [];
  }
}
