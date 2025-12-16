import 'package:flutter/foundation.dart';

class DeliveryStatusViewModel extends ChangeNotifier {
  bool isLoading = false;

  void loadDeliveryData() {
    isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      isLoading = false;
      notifyListeners();
    });
  }
}