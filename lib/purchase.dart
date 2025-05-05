
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = false;
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _available = await _iap.isAvailable();
    if (_available) {
      const Set<String> _ids = {'premium_avatar_access'};
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(_ids);
      if (response.notFoundIDs.isEmpty) {
        setState(() {
          _products = response.productDetails;
        });
      }
    }
  }

  void _buyProduct(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upgrade")),
      body: _available
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: _products
                  .map((product) => Card(
                        child: ListTile(
                          title: Text(product.title),
                          subtitle: Text(product.description),
                          trailing: TextButton(
                            child: Text(product.price),
                            onPressed: () => _buyProduct(product),
                          ),
                        ),
                      ))
                  .toList(),
            )
          : const Center(child: Text("In-App-Käufe nicht verfügbar")),
    );
  }
}
