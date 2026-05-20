import '../../data/models/product_response.dart';

class ProductState {
  final bool isLoading;
  final List<ProductResponse> products;
  final String? error;

  ProductState({
    this.isLoading = false,
    this.products = const [],
    this.error,
  });

  ProductState copyWith({
    bool? isLoading,
    List<ProductResponse>? products,
    String? error,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
    );
  }
}