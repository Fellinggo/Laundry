import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../shared/widgets/navy_app_bar.dart';
import '../../shared/widgets/service_grid_card.dart';
import '../../shared/widgets/service_section_header.dart';
import '../../shared/widgets/service_wide_card.dart';
import '../controllers/service_controller.dart';


class ServicesScreen extends StatelessWidget {
  const ServicesScreen({
    super.key,
    this.onOpenNotifications,
    this.loggedIn = false,
  });

  final VoidCallback? onOpenNotifications;
  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    // Menggunakan ProxyProvider untuk menyinkronkan parameter luar ke dalam Controller secara dinamis
    return ChangeNotifierProxyProvider0<ServicesController>(
      create: (_) => ServicesController(
        loggedIn: loggedIn,
        onOpenNotifications: onOpenNotifications,
      ),
      update: (_, controller) {
        return controller!..updateDependencies(
          loggedIn: loggedIn,
          onOpenNotifications: onOpenNotifications,
        );
      },
      child: const _ServicesContent(),
    );
  }
}

class _ServicesContent extends StatelessWidget {
  const _ServicesContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ServicesController>();

    // Mengambil data list secara atomik (Hanya merender ulang jika isi list berubah)
    final gridServices = context.select<ServicesController, List>(
      (c) => c.gridServices,
    );
    final wideServices = context.select<ServicesController, List>(
      (c) => c.wideServices,
    );

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyCenterTitleAppBar(
        title: 'Layanan',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => controller.handleNotificationTap(context),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 12),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ServiceSectionHeader(title: 'Layanan Lainnya'),
                  const SizedBox(height: 16),

                  // Grid Services Section
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: gridServices.map((service) {
                      return ServiceGridCard(
                        title: service.title,
                        price: service.price,
                        eta: service.eta,
                        etaType: service.etaType,
                        imagePath: service.imagePath,
                        onTap: () =>
                            controller.handleServiceTap(context, service.title),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Wide Services Section
                  ...wideServices.map((service) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ServiceWideCard(
                        title: service.title,
                        price: service.price,
                        eta: service.eta,
                        imagePath: service.imagePath,
                        onTap: () =>
                            controller.handleServiceTap(context, service.title),
                      ),
                    );
                  }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
