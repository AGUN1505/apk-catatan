// Import paket intl untuk pemformatan angka dan mata uang
import 'package:intl/intl.dart';

// Kelas untuk memformat mata uang ke format Rupiah Indonesia
class CurrencyFormat {
  // Metode statis untuk mengkonversi angka ke format Rupiah
  static String convertToIdr(dynamic number) {
    // Membuat objek NumberFormat untuk pemformatan mata uang
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id', // Menggunakan locale Indonesia
      symbol: 'Rp ', // Menambahkan simbol Rupiah
      decimalDigits: 2, // Menampilkan 2 angka di belakang koma
    );
    // Mengembalikan string hasil pemformatan
    return currencyFormatter.format(number);
  }
}
