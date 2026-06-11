import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/controllers/service_detail_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_white_panel.dart';
import '../widgets/info_kv_row.dart';
import '../widgets/service_filter_chip.dart';
import '../widgets/selected_service_item.dart';
import '../widgets/empty_selected_service.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return ChangeNotifierProvider<ServiceDetailController>(
      create: (_) => ServiceDetailController()..initializeWithArgument(args),
      child: const _ServiceDetailContent(),
    );
  }
}

class _ServiceDetailContent extends StatelessWidget {
  const _ServiceDetailContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ServiceDetailController>();

    // Pemilihan state reaktif menggunakan context.select (efisien & anti-rebuild massal)
    final total = context.select<ServiceDetailController, int>(
      (c) => c.totalServiceFee,
    );
    final hasSelectedServices = context.select<ServiceDetailController, bool>(
      (c) => c.hasSelectedServices,
    );
    final servicesLength = context.select<ServiceDetailController, int>(
      (c) => c.model.services.length,
    );
    final selectedServicesMap = context.select<ServiceDetailController, Map<int, int>>(
      (c) => c.model.selectedServices,
    );

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Ringkasan Layanan',
        onBack: () => controller.goBack(context),
      ),
      body: ScrollConfiguration(
        behavior: const _NoOverscrollBehavior(),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: RoundedWhitePanel(
                topRadius: AppSpacing.sheetTopRadius,
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal Filter Chip List - DIPERBAIKI
                    SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: servicesLength,
                        itemBuilder: (context, i) {
                          // PERBAIKAN: Gunakan Selector widget atau watch
                          return Selector<ServiceDetailController, bool>(
                            selector: (_, c) => c.model.selectedServices.containsKey(i),
                            builder: (context, isSelected, child) {
                              final currentController = context.read<ServiceDetailController>();
                              final service = currentController.model.services[i];

                              return ServiceFilterChip(
                                isSelected: isSelected,
                                icon: service.icon,
                                title: service.title,
                                onSelected: (val) => currentController.toggleServiceSelection(i, val),
                              );
                            },
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

                    // Selected Items List / Empty State
                    Expanded(
                      child: !hasSelectedServices
                          ? const EmptySelectedService()
                          : ListView.builder(
                              itemCount: selectedServicesMap.length,
                              itemBuilder: (context, index) {
                                final key = selectedServicesMap.keys.elementAt(index);
                                final service = controller.model.services[key];
                                final qty = selectedServicesMap[key]!;

                                return SelectedServiceItem(
                                  title: service.title,
                                  displayTitle: service.displayTitle,
                                  price: service.price,
                                  image: service.image,
                                  quantity: qty,
                                  priceValue: service.priceValue,
                                  onQuantityChanged: (newQty) => controller.updateQuantity(key, newQty),
                                );
                              },
                            ),
                    ),
                    InfoKvRow(
                      label: 'Total',
                      value: controller.formatPrice(total),
                      valueBold: true,
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: 'Jadwalkan Penjemputan',
                      onPressed: hasSelectedServices
                          ? () => controller.navigateToPickupSchedule(context)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoOverscrollBehavior extends ScrollBehavior {
  const _NoOverscrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}