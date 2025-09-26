class ApiResponseModel<T> {
  final bool status;
  final int code;
  final String msg;
  final T? data;
  final String? errors;

  ApiResponseModel({
    required this.status,
    required this.code,
    required this.msg,
    this.data,
    this.errors,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponseModel<T>(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'],
      errors: json['errors'],
    );
  }

  // Check if response is successful
  bool get isSuccess => status && code >= 200 && code < 300;

  // Check if response has errors
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  @override
  String toString() {
    return 'ApiResponseModel(status: $status, code: $code, msg: $msg, data: $data)';
  }
}
