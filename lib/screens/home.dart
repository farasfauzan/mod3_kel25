import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/favorite_store.dart';
import '../data/history_store.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countries;

  /// null = semua benua.
  String? _selectedRegion;
  _SortMode _sortMode = _SortMode.nameAsc;

  /// Kata kunci pencarian nama negara.
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://www.apicountries.com/countries');
    // Header User-Agent agar tidak kena 403 dari server API.
    // Di Web header ini tidak boleh di-set manual (browser yang isi sendiri),
    // jadi hanya ditambahkan di non-Web (Android/Desktop).
    final headers = <String, String>{};
    if (!kIsWeb) {
      headers['Accept'] = 'application/json';
      headers['User-Agent'] = 'Mozilla/5.0 (Flutter; mod3_kel25)';
    }
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((j) => Country.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  void _applySort(List<Country> list) {
    final comparator = switch (_sortMode) {
      _SortMode.nameAsc => (Country a, Country b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      _SortMode.nameDesc => (Country a, Country b) =>
          b.name.toLowerCase().compareTo(a.name.toLowerCase()),
      _SortMode.populationDesc => (Country a, Country b) =>
          b.population.compareTo(a.population),
      _SortMode.populationAsc => (Country a, Country b) =>
          a.population.compareTo(b.population),
    };
    list.sort(comparator);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value.trim()),
        decoration: InputDecoration(
          hintText: 'Cari negara',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Hapus pencarian',
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                ),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(List<String> regions) {
    // Chip pertama = "Semua" (null), diikuti tiap benua dari data API.
    final chips = <String?>[null, ...regions];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 58,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: chips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final region = chips[i];
              return ChoiceChip(
                label: Text(region ?? 'Semua'),
                selected: _selectedRegion == region,
                onSelected: (_) => setState(() => _selectedRegion = region),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          PopupMenuButton<_SortMode>(
            icon: const Icon(Icons.sort),
            tooltip: 'Urutkan',
            initialValue: _sortMode,
            onSelected: (mode) => setState(() => _sortMode = mode),
            itemBuilder: (context) => [
              for (final mode in _SortMode.values)
                PopupMenuItem(value: mode, child: Text(mode.label)),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Country>>(
        future: countries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No countries found'));
          }

          final all = snapshot.data!;
          final regions = all.map((c) => c.region).toSet().toList()..sort();

          // Kalau benua terpilih tidak ada lagi di data, kembali ke "Semua".
          final selected =
              regions.contains(_selectedRegion) ? _selectedRegion : null;

          final list = all
              .where((c) => selected == null || c.region == selected)
              .where((c) =>
                  _query.isEmpty ||
                  c.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();
          _applySort(list);

          return Column(
            children: [
              _buildSearchBar(),
              _buildFilterBar(regions),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${list.length} negara'
                    '${selected == null ? '' : ' • $selected'}'
                    ' • ${_sortMode.label}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text('Tidak ada negara yang cocok'))
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final country = list[i];
                          return Card(
                            child: ListTile(
                              leading: country.flagsPng != null
                                  ? Image.network(country.flagsPng!, width: 50)
                                  : const SizedBox(width: 50),
                              title: Text(country.name),
                              subtitle: Text(country.region),
                              trailing: ValueListenableBuilder<List<Country>>(
                                valueListenable: FavoriteStore.instance.items,
                                builder: (context, favorites, _) {
                                  final isFav = favorites
                                      .any((c) => c.name == country.name);
                                  return IconButton(
                                    icon: Icon(isFav
                                        ? Icons.star
                                        : Icons.star_border),
                                    color: isFav ? Colors.amber : null,
                                    tooltip: isFav
                                        ? 'Hapus dari favorit'
                                        : 'Tambah ke favorit',
                                    onPressed: () => FavoriteStore.instance
                                        .toggle(country),
                                  );
                                },
                              ),
                              onTap: () {
                                HistoryStore.instance.add(country);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(country: country),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _SortMode {
  nameAsc('Nama A-Z'),
  nameDesc('Nama Z-A'),
  populationDesc('Populasi terbanyak'),
  populationAsc('Populasi tersedikit');

  const _SortMode(this.label);

  final String label;
}

class Country {
  final String name;
  final String region;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<dynamic>? languages;
  final List<dynamic>? currencies;

  Country({
    required this.name,
    required this.region,
    required this.population,
    this.capital,
    this.flagsPng,
    this.languages,
    this.currencies,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    List<dynamic>? langs;
    if (json['languages'] != null) {
      langs = (json['languages'] as List)
          .map((l) => l['name'].toString())
          .toList();
    }

    List<dynamic>? cur;
    if (json['currencies'] != null) {
      cur = (json['currencies'] as List)
          .map((c) => c['name'].toString())
          .toList();
    }

    return Country(
      name: json['name'] ?? 'N/A',
      region: json['region'] ?? 'N/A',
      population: json['population'] ?? 0,
      capital: json['capital'],
      flagsPng: json['flags'] != null ? json['flags']['png'] : null,
      languages: langs,
      currencies: cur,
    );
  }
}
