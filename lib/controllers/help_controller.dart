import '../models/help_model.dart';

class HelpController {
  HelpModel getHelpData() {
    return const HelpModel(
      paragraphs: [
        'Jika anda mengalami kendala saat menggunakan aplikasi, silahkan hubungi layanan pelanggan kami melalui kontak yang tersedia. Tim kami akan membantu menyelesaikan masalah secepat mungkin.',

        'Pengguna juga dapat melihat informasi status layanan dan status pesanan di riwayat transaksi melalui aplikasi. Jika terjadi kesalahan data atau pesanan, segera hubungi pihak laundry untuk mendapatkan bantuan.',
      ],
    );
  }
}
