import 'package:flutter/material.dart';
import '../data/history_store.dart';
import 'detail.dart';
import 'home.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Negara'),
        backgroundColor: const Color.fromARGB(255, 13, 105, 225),
        foregroundColor: Colors.white,
        actions: [
          ValueListenableBuilder<List<Country>>(
            valueListenable: HistoryStore.instance.items,
            builder: (context, items, _) => IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Hapus riwayat',
              onPressed: items.isEmpty
                  ? null
                  : () => HistoryStore.instance.clear(),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Country>>(
        valueListenable: HistoryStore.instance.items,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(
              child: Text('Belum ada negara yang dibuka'),
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
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    HistoryStore.instance.add(country);
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
