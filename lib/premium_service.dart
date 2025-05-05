
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumService {
  static final PremiumService _instance = PremiumService._internal();
  bool isPremium = false;

  factory PremiumService() {
    return _instance;
  }

  PremiumService._internal();

  Future<void> checkPurchase() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) return;

    final QueryPurchaseDetailsResponse response =
        await InAppPurchase.instance.queryPastPurchases();

    for (var purchase in response.pastPurchases) {
      if (purchase.productID == 'premium_avatar_access' &&
          purchase.status == PurchaseStatus.purchased) {
        isPremium = true;
      }
    }
  }
}
