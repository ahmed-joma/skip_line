import 'product_model.dart';

class ProductDetailResponseModel {
  final bool status;
  final int code;
  final String msg;
  final ProductDetailData data;

  ProductDetailResponseModel({
    required this.status,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory ProductDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponseModel(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: ProductDetailData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'code': code, 'msg': msg, 'data': data.toJson()};
  }

  @override
  String toString() {
    return 'ProductDetailResponseModel(status: $status, code: $code, msg: $msg, data: $data)';
  }
}

class ProductDetailData {
  final ProductModel product;

  ProductDetailData({required this.product});

  factory ProductDetailData.fromJson(Map<String, dynamic> json) {
    return ProductDetailData(
      product: ProductModel.fromJson(json['product'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'product': product.toJson()};
  }

  @override
  String toString() {
    return 'ProductDetailData(product: $product)';
  }
}
