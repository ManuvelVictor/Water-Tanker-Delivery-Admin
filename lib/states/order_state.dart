import 'package:equatable/equatable.dart';

class OrderState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<Map<String, dynamic>> orders;

  const OrderState({this.isLoading = false, this.error, this.orders = const []});

  OrderState copyWith({bool? isLoading, String? error, List<Map<String, dynamic>>? orders}) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, orders];
}