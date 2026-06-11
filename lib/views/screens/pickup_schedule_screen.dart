import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/controllers/address_selector_controller.dart';
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

class PickupScheduleScreen extends StatelessWidget {
  const PickupScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PickupScheduleController>(
          create: (_) => PickupScheduleController(),
        ),
        ChangeNotifierProvider<AddressSelectorController>(
          create: (_) => AddressSelectorController()..loadAddresses(),
        ),
      ],
      child: Consumer<PickupScheduleController>(
        builder: (context, controller, child) {
          final data = controller.data;

          return Scaffold(
            backgroundColor: AppColors.headerNavy,
            appBar: NavyBackAppBar(
              title: 'Pengambilan dan Pengantaran',
              onBack: () => controller.goBack(context),
            ),
            body: Column(
              children: [
                const SizedBox(height: 8),
                Expanded(
                  child: RoundedWhitePanel(
                    topRadius: AppSpacing.sheetTopRadius,
                    child: ScrollConfiguration(
                      behavior: const _NoOverscrollBehavior(),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Waktu Pengambilan',
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: SizedBox(
                                    height: 70,
                                    child: ScheduleDateField(
                                      text: 'Hari ini',
                                      icon: Icons.calendar_today_outlined,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ScheduleTimePicker(
                                    selectedTime: data.pickupTime,
                                    hasError: data.pickupError,
                                    onTap: () =>
                                        controller.pickTime(context, true),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const ScheduleIconField(
                              text: 'Dijemput',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Text(
                              'Waktu Pengantaran',
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: SizedBox(
                                    height: 70,
                                    child: ScheduleDateField(
                                      text: 'Besok',
                                      icon: Icons.calendar_today_outlined,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ScheduleTimePicker(
                                    selectedTime: data.deliveryTime,
                                    hasError: data.deliveryError,
                                    onTap: () =>
                                        controller.pickTime(context, false),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const ScheduleIconField(
                              text: 'Diantar',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Text(
                              'Alamat Pengiriman',
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const AddressSelector(),
                            const SizedBox(height: AppSpacing.xl),
                            Text(
                              'Tambah catatan',
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                            const SizedBox(height: AppSpacing.xxl),
                            PrimaryButton(
                              label: 'Selanjutnya',
                              onPressed: () =>
                                  controller.validateAndNavigate(context, args),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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