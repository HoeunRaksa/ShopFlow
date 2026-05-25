class ResultMessage<T> {
  final int code;
  final int status;
  final String message;
  final T? data;

  ResultMessage({
    required this.code,
    required this.status,
    required this.message,
    this.data,
  });

  factory ResultMessage.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,
      ) {
    return ResultMessage<T>(
      code: json['code'] ?? 0,
      status: json['status'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
    );
  }

  Map<String, dynamic> toJson(
      dynamic Function(T value)? toJsonT,
      ) {
    return {
      "code": code,
      "status": status,
      "message": message,
      "data": data != null && toJsonT != null
          ? toJsonT(data as T)
          : data,
    };
  }

  bool get isSuccess => status == 200;

  bool get isError => status != 200;
}