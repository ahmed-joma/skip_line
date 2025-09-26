import 'product_model.dart';

class ProductsResponseModel {
  final bool status;
  final int code;
  final String msg;
  final ProductsData data;

  ProductsResponseModel({
    required this.status,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsResponseModel(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: ProductsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'code': code, 'msg': msg, 'data': data.toJson()};
  }

  @override
  String toString() {
    return 'ProductsResponseModel(status: $status, code: $code, msg: $msg, data: $data)';
  }
}

class ProductsData {
  final List<ProductModel> bestSellers;
  final List<ProductModel> exclusiveOffers;

  ProductsData({required this.bestSellers, required this.exclusiveOffers});

  factory ProductsData.fromJson(Map<String, dynamic> json) {
    return ProductsData(
      bestSellers:
          (json['best_sellers'] as List<dynamic>?)
              ?.map((item) => ProductModel.fromJson(item))
              .toList() ??
          [],
      exclusiveOffers:
          (json['exclusiveOffers'] as List<dynamic>?)
              ?.map((item) => ProductModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'best_sellers': bestSellers.map((item) => item.toJson()).toList(),
      'exclusiveOffers': exclusiveOffers.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ProductsData(bestSellers: ${bestSellers.length}, exclusiveOffers: ${exclusiveOffers.length})';
  }
}
