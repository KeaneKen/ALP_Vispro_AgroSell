import 'package:flutter/material.dart';
import 'view/list_po_view.dart';
import 'view/detail_po_view.dart';
import 'view/form_po_view.dart';
import 'viewmodel/pre_order_model.dart';

class PORoute {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/po-list':
        return MaterialPageRoute(
          builder: (_) => const ListPOView(),
          settings: settings,
        );
      case '/po-detail':
        return MaterialPageRoute(
          builder: (_) => DetailPOView(poId: args as String),
          settings: settings,
        );
      case '/po-form':
        PreOrderModel? poToEdit;
        if (args is PreOrderModel) {
          poToEdit = args;
        }
        return MaterialPageRoute(
          builder: (_) => FormPOView(poToEdit: poToEdit),
          settings: settings,
        );
      default:
        return null;
    }
  }
}