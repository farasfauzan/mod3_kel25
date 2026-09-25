import 'package:flutter/material.dart';
import '../data/favorite_store.dart';
import 'detail.dart';
import 'home.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        backgroundColor: const Color.fromARGB(255, 13, 105, 225),
        foregroundColor: Colors.white,
        actions: [
          ValueListenableBuilder<List<Country>>(
            valueListenable: FavoriteStore.instance.items,
            builder: (context, items, _) => IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Hapus semua favorit',
              onPressed:
                  items.isEmpty ? null : () => FavoriteStore.instance.clear(),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Country>>(
        valueListenable: FavoriteStore.instance.items,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(
              child: Text('Belum ada negara favorit'),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final country = items[i];
              return Card(
                child: ListTile(
                  leading: country.flagsPng != null
                      ? Image.network(country.flagsPng!, width: 50)
                      : const SizedBox(width: 50),
                  title: Text(country.name),
                  subtitle: Text(country.region),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Hapus dari favorit',
                    onPressed: () => FavoriteStore.instance.remove(country),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(country: country),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
