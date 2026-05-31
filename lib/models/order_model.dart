class Order {
  final String id;
  final String customerName;
  final String serviceName;
  final int quantity;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.customerName,
    required this.serviceName,
    required this.quantity,
    required this.status,
    required this.createdAt,
  });

  // Factory default (untuk dummy / init)
  factory Order.empty() {
    return Order(
      id: '',
      customerName: '',
      serviceName: '',
      quantity: 0,
      status: 'pending',
      createdAt: DateTime.now(),
    );
  }

  // CopyWith (WAJIB untuk update data dari API / Provider)
  Order copyWith({
    String? id,
    String? customerName,
    String? serviceName,
    int? quantity,
    String? status,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      serviceName: serviceName ?? this.serviceName,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Parsing dari API / Database
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      customerName: json['customer_name'] ?? '',
      serviceName: json['service_name'] ?? '',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 0,
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  // Convert ke JSON (untuk API / Database)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'service_name': serviceName,
      'quantity': quantity,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}