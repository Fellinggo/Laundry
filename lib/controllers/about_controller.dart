import 'package:flutter/material.dart';
import '../models/about_model.dart';

class AboutController
    extends
        ChangeNotifier {
  // Menyimpan data secara const agar hemat memori
  final AboutModel _aboutData = const AboutModel(
    paragraphs: [
      'WushLaundry adalah aplikasi layanan laundry online yang dirancang untuk memudahkan Anda dalam mencuci pakaian tanpa harus keluar rumah. Dengan fitur pemesanan yang praktis dan layanan antar jemput oleh kurir, kami membantu Anda menghemat waktu dan tenaga dalam memenuhi kebutuhan laundry sehari-hari.',
      'Melalui aplikasi ini, Anda dapat memilih berbagai jenis layanan seperti cuci kering, cuci bedcover, dan layanan lainnya dengan harga yang transparan. Selain itu, tersedia juga berbagai promo menarik serta fitur membership yang memberikan keuntungan lebih bagi pengguna.',
      'Kami berkomitmen untuk memberikan pelayanan yang cepat, aman, dan terpercaya dengan kualitas terbaik. WushLaundry hadir sebagai solusi modern untuk gaya hidup yang lebih praktis dan efisien.',
      'Terima kasih telah menggunakan WushLaundry!',
    ],
  );

  // Getter untuk mengambil data dari screen
  AboutModel get aboutData => _aboutData;
}
