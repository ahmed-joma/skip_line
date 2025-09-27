class OrderResponseModel {
  final bool status;
  final int code;
  final String msg;
  final Map<String, dynamic>? data;

  OrderResponseModel({
    required this.status,
    required this.code,
    required this.msg,
    this.data,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      status: json['status'] ?? false,
      code: json['code'] is String ? int.parse(json['code']) : json['code'],
      msg: json['msg'] ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'code': code, 'msg': msg, 'data': data};
  }

  bool get isSuccess => status && code >= 200 && code < 300;

  // Helper methods to access order data
  int? get orderId => data?['order']?['id'];
  double? get orderTotal => data?['order']?['total']?.toDouble();
  String? get orderStatus => data?['order']?['status'];
}
