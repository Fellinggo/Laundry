import 'package:flutter/material.dart';
import 'package:wushlaundry/controllers/sesrvice_detail_controller.dart';
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

class ServiceDetailScreen
    extends
        StatefulWidget {
  const ServiceDetailScreen({
    super.key,
  });

  @override
  State<
    ServiceDetailScreen
  >
  createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState
    extends
        State<
          ServiceDetailScreen
        > {
  late ServiceDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ServiceDetailController();
    _controller.addListener(
      _onControllerChanged,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(
              context,
            )?.settings.arguments
            as Map<
              String,
              dynamic
            >?;
    _controller.initializeWithArgument(
      args,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(
        () {},
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final model = _controller.model;
    final total = _controller.totalServiceFee;

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Ringkasan Layanan',
        onBack: () => _controller.goBack(
          context,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: RoundedWhitePanel(
              topRadius: AppSpacing.sheetTopRadius,
              padding: const EdgeInsets.all(
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: model.services.length,
                      itemBuilder:
                          (
                            context,
                            i,
                          ) {
                            final service = model.services[i];
                            final isSelected = model.selectedServices.containsKey(
                              i,
                            );

                            return ServiceFilterChip(
                              isSelected: isSelected,
                              icon: service.icon,
                              title: service.title,
                              onSelected:
                                  (
                                    val,
                                  ) => _controller.toggleServiceSelection(
                                    i,
                                    val,
                                  ),
                            );
                          },
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xl,
                  ),
                  Text(
                    'Daftar Layanan Dipilih',
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: !_controller.hasSelectedServices
                        ? const EmptySelectedService()
                        : ListView.builder(
                            itemCount: model.selectedServices.length,
                            itemBuilder:
                                (
                                  context,
                                  index,
                                ) {
                                  final key = model.selectedServices.keys.elementAt(
                                    index,
                                  );
                                  final service = model.services[key];
                                  final qty = model.selectedServices[key]!;

                                  return SelectedServiceItem(
                                    title: service.title,
                                    displayTitle: service.displayTitle,
                                    price: service.price,
                                    image: service.image,
                                    quantity: qty,
                                    priceValue: service.priceValue,
                                    onQuantityChanged:
                                        (
                                          newQty,
                                        ) => _controller.updateQuantity(
                                          key,
                                          newQty,
                                        ),
                                  );
                                },
                          ),
                  ),
                  InfoKvRow(
                    label: 'Total',
                    value: _controller.formatPrice(
                      total,
                    ),
                    valueBold: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  PrimaryButton(
                    label: 'Jadwalkan Penjemputan',
                    onPressed: _controller.hasSelectedServices
                        ? () => _controller.navigateToPickupSchedule(
                            context,
                          )
                        : null,
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
