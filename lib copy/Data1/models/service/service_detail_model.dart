import '../order/order_item_model.dart';

class ServiceDetailModel {
  final List<OrderItemModel> services;
  final Map<int, int> selectedServices;

  ServiceDetailModel({required this.services, required this.selectedServices});

  int get totalServiceFee {
    int total = 0;
    selectedServices.forEach((index, qty) {
      total += services[index].priceValue * qty;
    });
    return total;
  }

  int get deliveryFee => 5000;

  int get grandTotal => totalServiceFee + deliveryFee;

  List<Map<String, dynamic>> get orderItems {
    final items = <Map<String, dynamic>>[];
    selectedServices.forEach((index, qty) {
      final service = services[index];
      items.add({
        'title': service.title,
        'price': service.priceValue,
        'qty': qty,
        'subtotal': service.priceValue * qty,
        'image': service.image,
      });
    });
    return items;
  }

  bool get hasSelectedServices => selectedServices.isNotEmpty;

  ServiceDetailModel copyWith({
    List<OrderItemModel>? services,
    Map<int, int>? selectedServices,
  }) {
    return ServiceDetailModel(
      services: services ?? this.services,
      selectedServices: selectedServices ?? this.selectedServices,
    );
  }
}
