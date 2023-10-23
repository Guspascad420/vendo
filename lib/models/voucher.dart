
import 'package:vendo/models/category.dart';

class Voucher {
  final String title;
  final double discountPercentage;
  final int maxDiscount;
  final int minimumOrder;
  final Category category;

  const Voucher(this.title, this.discountPercentage, this.maxDiscount,
      this.minimumOrder, this.category);
}

class DummyVoucherData {
  static List<Voucher> getVouchers() {
    return [
      const Voucher("Diskon User Baru 50%, Maks 5rb", 0.5, 5000, 20000, Category.all),
      const Voucher("Diskon Spesial 20%, Maks 10rb", 0.2, 10000, 10000, Category.foodOrBeverage),
      const Voucher("Diskon Bareng 10%, Maks 20rb", 0.1, 20000, 30000, Category.foodOrBeverage),
      const Voucher("Diskon Fashion 10%, Maks 20rb", 0.1, 20000, 200000, Category.fashion)
    ];
  }
}