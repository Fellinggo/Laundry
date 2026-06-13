class TermsSection {
  final String title;
  final List<
    String
  >
  items;

  TermsSection({
    required this.title,
    required this.items,
  });
}

class TermsModel {
  final List<
    TermsSection
  >
  sections;

  TermsModel({
    required this.sections,
  });

  // Factory method untuk data default
  factory TermsModel.defaultTerms() {
    return TermsModel(
      sections: [
        TermsSection(
          title: 'Syarat Layanan',
          items: [
            'Layanan laundry mencakup cuci, kering, setrika, dan pengantaran sesuai paket yang dipilih.',
            'Estimasi waktu dapat berubah sewaktu-waktu tergantung pada antrean dan cuaca.',
            'Pelanggan wajib memastikan tidak ada barang berharga di dalam kantong cucian.',
          ],
        ),
        TermsSection(
          title: 'Kerusakan & Kehilangan',
          items: [
            'Klaim kerusakan dilaporkan maksimal 24 jam setelah pengantaran.',
            'Kompensasi mengikuti kebijakan internal dan bukti yang valid.',
          ],
        ),
        TermsSection(
          title: 'Pembayaran',
          items: [
            'Pembayaran dilakukan melalui metode yang tersedia di aplikasi.',
            'Promo dan kode diskon tidak dapat digabungkan kecuali diatur lain.',
          ],
        ),
      ],
    );
  }

  // Untuk kemudahan jika nanti ingin mengambil data dari API/local storage
  factory TermsModel.fromJson(
    Map<
      String,
      dynamic
    >
    json,
  ) {
    // Implementasi jika data berasal dari JSON
    // Untuk sekarang return default
    return TermsModel.defaultTerms();
  }

  Map<
    String,
    dynamic
  >
  toJson() {
    return {
      'sections': sections
          .map(
            (
              section,
            ) => {
              'title': section.title,
              'items': section.items,
            },
          )
          .toList(),
    };
  }
}
