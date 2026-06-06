import 'package:flutter/material.dart';
import 'package:wushlaundry/views/widgets/address_selector_widget.dart';
import 'package:wushlaundry/views/widgets/schedule_date_field_widget.dart';
import 'package:wushlaundry/views/widgets/schedule_timePicker_widget.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_white_panel.dart';
import '../widgets/schedule_icon_field.dart';
import '../../controllers/pickup_schedule_controller.dart';

class PickupScheduleScreen
    extends
        StatefulWidget {
  const PickupScheduleScreen({
    super.key,
  });

  @override
  State<
    PickupScheduleScreen
  >
  createState() => _PickupScheduleScreenState();
}

class _PickupScheduleScreenState
    extends
        State<
          PickupScheduleScreen
        > {
  late PickupScheduleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PickupScheduleController();
    _controller.addListener(
      _onControllerChanged,
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
    // Perbaikan: tambahkan tipe generic untuk args
    final args =
        ModalRoute.of(
              context,
            )?.settings.arguments
            as Map<
              String,
              dynamic
            >? ??
        {};
    final data = _controller.data;

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Pengambilan dan Pengantaran',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Waktu Pengambilan',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: ScheduleDateField(
                              text: 'Hari ini',
                              icon: Icons.calendar_today_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ScheduleTimePicker(
                            selectedTime: data.pickupTime,
                            hasError: data.pickupError,
                            onTap: () => _controller.pickTime(
                              context,
                              true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ScheduleIconField(
                      text: 'Dijemput',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(
                      height: AppSpacing.xl,
                    ),
                    Text(
                      'Waktu Pengantaran',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: ScheduleDateField(
                              text: 'Besok',
                              icon: Icons.calendar_today_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ScheduleTimePicker(
                            selectedTime: data.deliveryTime,
                            hasError: data.deliveryError,
                            onTap: () => _controller.pickTime(
                              context,
                              false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ScheduleIconField(
                      text: 'Diantar',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(
                      height: AppSpacing.xl,
                    ),
                    Text(
                      'Alamat Pengiriman',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AddressSelector(
                      addresses: data.addresses,
                      selectedAddressType: data.selectedAddressType,
                      showAddressOptions: data.showAddressOptions,
                      isLoadingAddresses: data.isLoadingAddresses,
                      customAddressController: _controller.customAddressController,
                      onAddressTap: _controller.toggleAddressOptions,
                      onAddressSelected: _controller.selectAddressType,
                      onUseCustomAddress: _controller.useCustomAddress,
                      // Perbaikan: tambahkan arrow function dan context
                      onNavigateToProfile: () => _controller.navigateToProfile(
                        context,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.xl,
                    ),
                    Text(
                      'Tambah catatan',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      maxLines: 4,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        hintText: 'Tulis disini',
                        filled: true,
                        fillColor: AppColors.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.inputRadius,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.xxl,
                    ),
                    PrimaryButton(
                      label: 'Selanjutnya',
                      onPressed: () => _controller.validateAndNavigate(
                        context,
                        args,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
