import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onHomeTap;

  const ProfilePage({super.key, this.onHomeTap});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, String>> teamMembers = [
    {'Nama': 'Aufan Damays Marsuki', 'NIM': '21120124140163'},
    {'Nama': 'Zikri Arribath Vadila', 'NIM': '21120124130089'},
    {'Nama': 'Faras Fauzan Attaqi', 'NIM': '21120124140119'},
    {'Nama': 'Hening Wijaya Imanda', 'NIM': '21120124120036'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 13, 105, 225),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: widget.onHomeTap,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Tinggi latar = separuh tinggi area isi, dipakai juga untuk
          // menempatkan foto profil tepat di batas latar.
          final bannerHeight = constraints.maxHeight * 0.5;

          return Stack(
            children: [
              SizedBox(
                height: bannerHeight,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/background.png'),
                    ),
                    color: const Color.fromARGB(255, 255, 252, 252)
                        .withValues(alpha: 0.5),
                  ),
                ),
              ),
              // Isi dibuat dapat digulir agar seluruh anggota tetap terbaca
              // ketika jumlahnya banyak dan layar tidak cukup tinggi.
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: bannerHeight - 50.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 24.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/profile.jpg'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    for (var member in teamMembers)
                      Column(
                        children: [
                          Text(
                            member['Nama'] ?? 'No Name',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            member['NIM'] ?? 'No NIM',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 8.0),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
