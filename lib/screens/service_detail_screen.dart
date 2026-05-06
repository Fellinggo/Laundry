import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/info_kv_row.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/quantity_stepper.dart';
import '../widgets/rounded_white_panel.dart';
import '../data/service_dummy.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  bool _isInit = true;

  late final List<Map<String, dynamic>> services;

  final Map<int, int> selectedServices = {};

  @override
  void initState() {
    super.initState();

    services = serviceDummy.map((e) {
      return {
        'title': e.title,
        'displayTitle': e.title == 'Cuci Bedcover / Selimut / Sprei'
            ? 'Cuci Bedcover /\nSelimut / Sprei'
            : e.title,
        'price': e.price,
        'image': e.imagePath,
        'icon': _getIcon(e.title),
      };
    }).toList();
  }

  IconData _getIcon(String title) {
    switch (title) {
      case 'Cuci Regular':
        return Icons.local_laundry_service;
      case 'Cuci Setrika':
        return Icons.iron;
      case 'Cuci Kering':
        return Icons.dry_cleaning_outlined;
      case 'Paket Service':
        return Icons.inventory_2_outlined;
      case 'Cuci Jas / Gaun':
        return Icons.checkroom;
      case 'Setrika Saja':
        return Icons.iron_outlined;
      case 'Cuci Bedcover / Selimut / Sprei':
        return Icons.bed;
      case 'Cuci Sepatu':
        return Icons.hiking;
      default:
        return Icons.local_laundry_service;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args['title'] != null) {
        final index = services.indexWhere((s) => s['title'] == args['title']);

        if (index != -1) {
          selectedServices[index] = 1;
        }
      }

      _isInit = false;
    }
  }

  int _parsePrice(String price) {
    return int.parse(price.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  String _formatRp(int value) {
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  int get totalServiceFee {
    int total = 0;
    selectedServices.forEach((index, qty) {
      final int price = _parsePrice(services[index]['price']);
      total += price * qty;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final int total = totalServiceFee;

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Ringkasan Layanan',
        onBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: RoundedWhitePanel(
              topRadius: AppSpacing.sheetTopRadius,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: services.length,
                      itemBuilder: (context, i) {
                        final s = services[i];
                        final selected = selectedServices.containsKey(i);
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FilterChip(
                            selected: selected,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  selectedServices[i] = 1;
                                } else {
                                  selectedServices.remove(i);
                                }
                              });
                            },
                            label: Row(
                              children: [
                                Icon(s['icon'], size: 18),
                                const SizedBox(width: 6),
                                Text(s['title']),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    'Daftar Layanan Dipilih',
                    style: AppTextStyles.sectionTitle,
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: selectedServices.isEmpty
                        ? const Center(child: Text('Belum ada layanan dipilih'))
                        : ListView.builder(
                            itemCount: selectedServices.length,
                            itemBuilder: (context, index) {
                              final key = selectedServices.keys.elementAt(
                                index,
                              );
                              final service = services[key];
                              final int qty = selectedServices[key]!;

                              final int price = _parsePrice(service['price']);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        service['image'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service['displayTitle'] ??
                                                service['title'],
                                            style: AppTextStyles.sectionTitle
                                                .copyWith(fontSize: 14),
                                          ),
                                          Text(
                                            '${_formatRp(price)}',
                                            style: AppTextStyles.bodyMuted,
                                          ),
                                        ],
                                      ),
                                    ),

                                    QuantityStepper(
                                      value: qty,
                                      onChanged: (v) {
                                        setState(() {
                                          selectedServices[key] = v;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),

                  InfoKvRow(
                    label: 'Total',
                    value: _formatRp(total),
                    valueBold: true,
                  ),

                  const SizedBox(height: 12),

                  PrimaryButton(
                    label: 'Jadwalkan Penjemputan',
                    onPressed: selectedServices.isEmpty
                        ? null
                        : () {
                            final List<Map<String, dynamic>> orderItems = [];

                            int serviceFee = 0;

                            selectedServices.forEach((index, qty) {
                              final service = services[index];

                              final int price = _parsePrice(service['price']);
                              final int subtotal = price * qty;

                              serviceFee += subtotal;

                              orderItems.add({
                                'title': service['title'],
                                'price': price,
                                'qty': qty,
                                'subtotal': subtotal,
                                'image': service['image'],
                              });
                            });

                            const int deliveryFee = 5000;
                            final int total = serviceFee + deliveryFee;

                            Navigator.pushNamed(
                              context,
                              '/pickup-schedule',
                              arguments: {
                                'items': orderItems,
                                'serviceFee': serviceFee,
                                'deliveryFee': deliveryFee,
                                'total': total,
                              },
                            );
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
