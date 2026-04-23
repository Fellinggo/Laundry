import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/widgets/rounded_white_panel.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.embedded = false,
  });

  final bool embedded;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Guest';
  String email = '-';
  bool isLoggedIn = false;
  List<Map<String, String>> addresses = [];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUser();
  }

  // ============================================
  // GET STORAGE KEY BERDASARKAN EMAIL
  // ============================================
  String get _addressKey => 'userAddresses_$email';
  String get _titlesKey => 'userAddressTitles_$email';

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        name = prefs.getString('userName') ?? 'User';
        email = prefs.getString('userEmail') ?? '-';

        // ============================================
        // LOAD ALAMAT BERDASARKAN EMAIL
        // ============================================
        final savedAddresses = prefs.getStringList(_addressKey) ?? [];
        final savedTitles = prefs.getStringList(_titlesKey) ?? [];

        if (savedAddresses.isNotEmpty) {
          // Load alamat yang sudah tersimpan untuk email ini
          addresses = List.generate(savedAddresses.length, (i) {
            return {
              'title': i < savedTitles.length ? savedTitles[i] : 'Alamat',
              'address': savedAddresses[i],
            };
          });
        } else {
          // Tidak ada alamat tersimpan untuk email ini
          final isSignup = prefs.getBool('isSignup') ?? false;

          if (isSignup) {
            // SIGNUP → ALAMAT KOSONG
            addresses = [];
          } else {
            // LOGIN → 2 ALAMAT DEFAULT
            addresses = [
              {
                'title': 'Rumah',
                'address': 'Jl. Melati No. 12, Jakarta Selatan',
              },
              {
                'title': 'Kantor',
                'address': 'Gedung Aurora Lt. 5, Jl. Sudirman',
              },
            ];
            // Simpan alamat default ke SharedPreferences
            _saveAddressesToPrefs();
          }
        }
      } else {
        // BELUM LOGIN → KOSONG
        name = 'Belum Login';
        email = 'Silakan login terlebih dahulu';
        addresses = [];
      }
    });
  }

  // ============================================
  // SIMPAN ALAMAT DENGAN KEY BERDASARKAN EMAIL
  // ============================================
  Future<void> _saveAddressesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    final addressList = addresses.map((addr) => addr['address']!).toList();
    final titleList = addresses.map((addr) => addr['title']!).toList();
    
    // Simpan dengan key berdasarkan email
    await prefs.setStringList(_addressKey, addressList);
    await prefs.setStringList(_titlesKey, titleList);
  }

  void _handleProtectedAction(VoidCallback action) {
    if (!isLoggedIn) {
      Navigator.pushNamed(context, '/login').then((_) {
        loadUser();
      });
    } else {
      action();
    }
  }

  void _deleteAddress(int index) async {
    setState(() {
      addresses.removeAt(index);
    });
    await _saveAddressesToPrefs();
  }

  Future<void> _addNewAddress() async {
    final result = await Navigator.pushNamed(
      context,
      '/add-address',
    );

    if (result != null && result is Map) {
      setState(() {
        addresses.add({
          'title': result['title'],
          'address': result['address'],
        });
      });
      await _saveAddressesToPrefs();
    }
  }

  Future<void> _editAddress(int index) async {
    final result = await Navigator.pushNamed(
      context,
      '/edit-address',
      arguments: {
        'index': index,
        'title': addresses[index]['title']!,
        'address': addresses[index]['address']!,
      },
    );

    if (result != null && result is Map) {
      setState(() {
        addresses[index] = {
          'title': result['title'],
          'address': result['address'],
        };
      });
      await _saveAddressesToPrefs();
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = Column(
      children: [
        SafeArea(
          bottom: false,
          child: Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Profil Saya',
                  style: AppTextStyles.screenTitleWhite.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/settings').then((_) {
                          loadUser();
                        }),
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: GestureDetector(
            onTap: () => _handleProtectedAction(() {
              debugPrint("Edit profil");
            }),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.iconCircle,
                  child: Icon(Icons.person,
                      size: 40, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: AppTextStyles.bodyMuted.copyWith(
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    final sheet = RoundedWhitePanel(
      topRadius: 28,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alamat Pengantaran',
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 15),
              ),
              IconButton(
                onPressed: () => _handleProtectedAction(() {
                  _addNewAddress();
                }),
                icon: const Icon(Icons.add, color: AppColors.primaryNavy),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ================= ALAMAT LIST =================
          if (isLoggedIn && addresses.isNotEmpty)
            ...List.generate(addresses.length, (i) {
              return Column(
                children: [
                  _addressCard(
                    index: i,
                    title: addresses[i]['title']!,
                    address: addresses[i]['address']!,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            })
          else if (isLoggedIn && addresses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Belum ada alamat tersimpan\nTap + untuk menambahkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.location_off_outlined,
                      color: Colors.grey,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Silakan login untuk melihat alamat',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login').then((_) {
                          loadUser();
                        });
                      },
                      child: const Text('Login Sekarang'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    final bodyContent = Column(
      children: [
        top,
        const SizedBox(height: 24),
        Expanded(child: sheet),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      body: bodyContent,
    );
  }

  Widget _addressCard({
    required int index,
    required String title,
    required String address,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined,
              color: AppColors.actionBlue),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () => _editAddress(index),
            child: const Icon(
              Icons.edit_outlined,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: () => _deleteAddress(index),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}