import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/constants/app_colors.dart';
import 'package:wushlaundry/constants/app_spacing.dart';
import 'package:wushlaundry/constants/app_text_styles.dart';
import 'package:wushlaundry/views/widgets/navy_app_bar.dart';
import 'package:wushlaundry/views/widgets/primary_button.dart';
import 'package:wushlaundry/views/widgets/rounded_white_panel.dart';

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
  TimeOfDay? _pickupTime;
  TimeOfDay? _deliveryTime;

  bool _showAddressOptions = false;
  bool _deliveryError = false;
  bool _pickupError = false;

  final TextEditingController _customAddressController = TextEditingController();

  String _selectedAddressType = 'Rumah';

  Map<
    String,
    String
  >
  _addresses = {};
  bool _isLoadingAddresses = true;

  @override
  void initState() {
    super.initState();
    _loadAddressesFromPrefs();
  }

  Future<
    void
  >
  _loadAddressesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final isLoggedIn =
        prefs.getBool(
          'isLoggedIn',
        ) ??
        false;
    final email =
        prefs.getString(
          'userEmail',
        ) ??
        '';

    if (!isLoggedIn) {
      setState(
        () {
          _addresses = {};
          _selectedAddressType = '';
          _isLoadingAddresses = false;
        },
      );
      return;
    }

    final addressKey = 'userAddresses_$email';
    final titlesKey = 'userAddressTitles_$email';

    final savedAddresses =
        prefs.getStringList(
          addressKey,
        ) ??
        [];
    final savedTitles =
        prefs.getStringList(
          titlesKey,
        ) ??
        [];

    setState(
      () {
        if (savedAddresses.isNotEmpty) {
          _addresses = {};
          for (
            int i = 0;
            i <
                savedAddresses.length;
            i++
          ) {
            final title =
                i <
                    savedTitles.length
                ? savedTitles[i]
                : 'Alamat ${i + 1}';
            _addresses[title] = savedAddresses[i];
          }
          _selectedAddressType = savedTitles.isNotEmpty
              ? savedTitles[0]
              : 'Alamat 1';
        } else {
          _addresses = {};
          _selectedAddressType = '';
        }
        _isLoadingAddresses = false;
      },
    );
  }

  String _formatTime(
    TimeOfDay? time,
  ) {
    if (time ==
        null)
      return 'Pilih jam';
    final h = time.hour.toString().padLeft(
      2,
      '0',
    );
    final m = time.minute.toString().padLeft(
      2,
      '0',
    );
    return '$h:$m';
  }

  Future<
    void
  >
  _pickTime({
    required bool isPickup,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked !=
        null) {
      setState(
        () {
          if (isPickup) {
            _pickupTime = picked;
            _pickupError = false;
          } else {
            _deliveryTime = picked;
            _deliveryError = false;
          }
        },
      );
    }
  }

  Widget _addressOption(
    String key,
  ) {
    return ListTile(
      leading: const Icon(
        Icons.home_outlined,
      ),
      title: Text(
        key,
      ),
      subtitle: Text(
        _addresses[key]!,
      ),
      onTap: () {
        setState(
          () {
            _selectedAddressType = key;
            _showAddressOptions = false;
          },
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final args =
        ModalRoute.of(
              context,
            )?.settings.arguments
            as Map? ??
        {};

    final selectedAddress =
        _selectedAddressType ==
            'Custom'
        ? _customAddressController.text
        : (_selectedAddressType.isNotEmpty &&
                  _addresses.containsKey(
                    _selectedAddressType,
                  )
              ? _addresses[_selectedAddressType]!
              : '');

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Pengambilan dan Pengantaran',
        onBack: () => Navigator.pop(
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
                            child: _dateField(
                              'Hari ini',
                              Icons.calendar_today_outlined,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(
                              isPickup: true,
                            ),
                            child: SizedBox(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 52,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.inputFill,
                                      borderRadius: BorderRadius.circular(
                                        14,
                                      ),
                                      border: Border.all(
                                        color: _pickupError
                                            ? Colors.red
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Text(
                                            _formatTime(
                                              _pickupTime,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  SizedBox(
                                    height: 14,
                                    child: _pickupError
                                        ? const Text(
                                            'Wajib diisi',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    _iconField(
                      'Dijemput',
                      Icons.person_outline,
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
                            child: _dateField(
                              'Besok',
                              Icons.calendar_today_outlined,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(
                              isPickup: false,
                            ),
                            child: SizedBox(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 52,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.inputFill,
                                      borderRadius: BorderRadius.circular(
                                        14,
                                      ),
                                      border: Border.all(
                                        color: _deliveryError
                                            ? Colors.red
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Text(
                                            _formatTime(
                                              _deliveryTime,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  SizedBox(
                                    height: 14,
                                    child: _deliveryError
                                        ? const Text(
                                            'Wajib diisi',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    _iconField(
                      'Diantar',
                      Icons.person_outline,
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
                    if (_isLoadingAddresses)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    else if (_addresses.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(
                          16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.location_off_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Belum ada alamat tersimpan',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/profile',
                                );
                              },
                              child: const Text(
                                'Tambah Alamat di Profil',
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              _showAddressOptions = !_showAddressOptions;
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.inputFill,
                            borderRadius: BorderRadius.circular(
                              14,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedAddressType,
                                      style: AppTextStyles.sectionTitle.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      selectedAddress,
                                      style: AppTextStyles.bodyMuted,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (!_isLoadingAddresses &&
                        _addresses.isNotEmpty)
                      AnimatedCrossFade(
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        crossFadeState: _showAddressOptions
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const SizedBox.shrink(),
                        secondChild: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ..._addresses.keys.map(
                              (
                                key,
                              ) => _addressOption(
                                key,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            TextField(
                              controller: _customAddressController,
                              decoration: InputDecoration(
                                hintText: 'Atau masukkan alamat lain...',
                                filled: true,
                                fillColor: AppColors.inputFill,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    14,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged:
                                  (
                                    _,
                                  ) => setState(
                                    () {},
                                  ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            PrimaryButton(
                              label: 'Gunakan alamat ini',
                              onPressed: () {
                                if (_customAddressController.text.isNotEmpty) {
                                  setState(
                                    () {
                                      _selectedAddressType = 'Custom';
                                      _addresses['Custom'] = _customAddressController.text;
                                      _showAddressOptions = false;
                                    },
                                  );
                                }
                              },
                            ),
                          ],
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
                      onPressed: () {
                        setState(
                          () {
                            _pickupError =
                                _pickupTime ==
                                null;
                            _deliveryError =
                                _deliveryTime ==
                                null;
                          },
                        );

                        if (_pickupError ||
                            _deliveryError)
                          return;

                        if (selectedAddress.isEmpty) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Silakan pilih alamat terlebih dahulu',
                              ),
                            ),
                          );
                          return;
                        }

                        final items =
                            args['items'] ??
                            [];
                        final serviceFee =
                            args['serviceFee'] ??
                            0;
                        final deliveryFee =
                            args['deliveryFee'] ??
                            5000;
                        final total =
                            args['total'] ??
                            (serviceFee +
                                deliveryFee);

                        Navigator.pushNamed(
                          context,
                          '/order-review',
                          arguments: {
                            'items': items,
                            'serviceFee': serviceFee,
                            'deliveryFee': deliveryFee,
                            'total': total,
                            'pickupTime': _formatTime(
                              _pickupTime,
                            ),
                            'deliveryTime': _formatTime(
                              _deliveryTime,
                            ),
                            'address': selectedAddress,
                            'addressType': _selectedAddressType,
                          },
                        );
                      },
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

  Widget _dateField(
    String text,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(
          14,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconField(
    String text,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(
          14,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
          ),
        ],
      ),
    );
  }
}
