class PrivacyPolicySection {
  final String title;
  final List<
    String
  >
  items;
  final bool hasLearnMoreButton;

  PrivacyPolicySection({
    required this.title,
    required this.items,
    this.hasLearnMoreButton = false,
  });
}

class PrivacyPolicyModel {
  final String mainTitle;
  final String mainContent;
  final List<
    PrivacyPolicySection
  >
  sections;

  PrivacyPolicyModel({
    required this.mainTitle,
    required this.mainContent,
    required this.sections,
  });

  // Factory untuk data default
  factory PrivacyPolicyModel.defaultPolicy() {
    return PrivacyPolicyModel(
      mainTitle: 'Kebijakan Privasi',
      mainContent: 'Kami menghormati privasi Anda. Data pribadi digunakan untuk memproses pesanan, komunikasi layanan, dan peningkatan pengalaman aplikasi.',
      sections: [
        PrivacyPolicySection(
          title: 'Pedoman Pengguna',
          items: [
            'Gunakan layanan sesuai ketentuan yang berlaku.',
            'Pastikan informasi alamat dan kontak akurat.',
            'Segala bentuk penyalahgunaan dapat mengakibatkan penangguhan akun.',
          ],
        ),
        PrivacyPolicySection(
          title: 'Penggunaan Data',
          items: [
            'Data lokasi dipakai untuk penjemputan dan pengantaran.',
            'Riwayat pesanan disimpan untuk keperluan garansi layanan.',
          ],
          hasLearnMoreButton: true,
        ),
      ],
    );
  }

  // Untuk mengambil data dari API/local storage
  factory PrivacyPolicyModel.fromJson(
    Map<
      String,
      dynamic
    >
    json,
  ) {
    return PrivacyPolicyModel(
      mainTitle:
          json['mainTitle'] ??
          'Kebijakan Privasi',
      mainContent:
          json['mainContent'] ??
          '',
      sections:
          (json['sections']
                  as List?)
              ?.map(
                (
                  section,
                ) {
                  return PrivacyPolicySection(
                    title:
                        section['title'] ??
                        '',
                    items:
                        (section['items']
                                as List?)
                            ?.cast<
                              String
                            >() ??
                        [],
                    hasLearnMoreButton:
                        section['hasLearnMoreButton'] ??
                        false,
                  );
                },
              )
              .toList() ??
          [],
    );
  }

  Map<
    String,
    dynamic
  >
  toJson() {
    return {
      'mainTitle': mainTitle,
      'mainContent': mainContent,
      'sections': sections
          .map(
            (
              section,
            ) => {
              'title': section.title,
              'items': section.items,
              'hasLearnMoreButton': section.hasLearnMoreButton,
            },
          )
          .toList(),
    };
  }
}
