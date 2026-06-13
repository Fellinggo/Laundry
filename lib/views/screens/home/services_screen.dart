// lib/views/screens/services_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/controllers/home/service_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../widgets/navy_app_bar.dart';
import '../../widgets/service_grid_card.dart';
import '../../widgets/service_wide_card.dart';
import '../../widgets/service_section_header.dart';

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
    
    // Mendengarkan loading, error, dan data
    final isLoading = context.select<ServicesController, bool>(
      (c) => c.isLoading,
    );
    final errorMessage = context.select<ServicesController, String?>(
      (c) => c.errorMessage,
    );
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
          child: RefreshIndicator(
            onRefresh: () => controller.refreshServices(),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Loading State
                    if (isLoading && gridServices.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    // Error State
                    else if (errorMessage != null && gridServices.isEmpty)
                      _buildErrorWidget(context, controller, errorMessage)
                    // Data Display
                    else
                      _buildServicesContent(
                        gridServices: gridServices,
                        wideServices: wideServices,
                        controller: controller,
                        context: context,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildServicesContent({
    required List gridServices,
    required List wideServices,
    required ServicesController controller,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ServiceSectionHeader(title: 'Layanan Lainnya'),
        const SizedBox(height: 16),
        
        // Grid Services Section
        if (gridServices.isNotEmpty)
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
                imageKeyword: service.imageKeyword, // Menggunakan imageKeyword
                onTap: () => controller.handleServiceTap(context, service.title),
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
              imageKeyword: service.imageKeyword, // Menggunakan imageKeyword
              onTap: () => controller.handleServiceTap(context, service.title),
            ),
          );
        }),
        
        const SizedBox(height: 80),
      ],
    );
  }
  
  Widget _buildErrorWidget(
    BuildContext context,
    ServicesController controller,
    String errorMessage,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat layanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => controller.refreshServices(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.headerNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}