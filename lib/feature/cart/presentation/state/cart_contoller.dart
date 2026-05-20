import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/framework.dart';
import '../../data/model/cart_response.dart';
import '../../data/service/cart_service.dart';

final addCartQuantityProvider =
StateProvider.family<int, int>((ref, productId) {
  final cartList = ref.watch(cartProvider).value;
  final productInCard = cartList?.where((item) => item.product.id == productId).firstOrNull;
  final int quantity = productInCard?.quantity ?? 1;
  return quantity;
});

final cartProvider =
AsyncNotifierProvider<CartController, List<CartResponse>>(
  CartController.new,
);

final cartSubtotalProvider = Provider<double>((ref) {
  final cartAsync = ref.watch(cartProvider);

  return cartAsync.when(
    data: (carts) {
      return carts.fold<double>(
        0,
            (sum, item) => sum + (item.product.price * item.quantity),
      );
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

class CartController extends AsyncNotifier<List<CartResponse>> {
  late final CartService cartService;

  @override
  Future<List<CartResponse>> build() async {
    cartService = ref.read(cartServiceProvider);
    return await cartService.getCarts();
  }

  Future<void> addToCart(int productId, int quantity) async {
    try {
      final newItem = await cartService.createCart(productId, quantity);
      final current = state.value ?? [];
      state = AsyncData([...current, newItem]);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> increment(int productId, {int? cartId , bool apiCall = true}) async {
    final current = state.value ?? [];
    int? newQuantity;
    final updated = current.map((item) {
      if (item.product.id == productId) {
        newQuantity = item.quantity + 1;
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    state = AsyncData(updated);

    if (apiCall && cartId != null && newQuantity != null) {
      await Future.delayed(const Duration(seconds: 3));
      await cartService.updateCounter(cartId, newQuantity!);
    }
  }

  Future<void> decrement(int productId, {int? cartId, bool apiCall = true}) async {
    final current = state.value ?? [];
    int? newQuantity;
    final updated = current.map((item) {
      if (item.product.id == productId && item.quantity > 1) {
        newQuantity = item.quantity - 1;
        return item.copyWith(quantity:newQuantity );
      }
      return item;
    }).toList();

    state = AsyncData(updated);

    if (apiCall && cartId != null && newQuantity != null) {
      await Future.delayed(const Duration(seconds: 3));
      await cartService.updateCounter(cartId, newQuantity!);
    }
  }

  Future<void> remove(int id, {bool apiCall = true}) async{
    final current = state.value ?? [];
    final updated = current
        .where((item) => item.id != id)
        .toList();
    state = AsyncData(updated);
    if (apiCall) {
       await cartService.removeCart(id);
    }
  }

  Future<void> refreshCart() async {
    state = const AsyncLoading();

    try {
      final carts = await cartService.getCarts();
      state = AsyncData(carts);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}