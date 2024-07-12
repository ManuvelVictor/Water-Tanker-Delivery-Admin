import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class FetchOrders extends OrderEvent {}

class AssignOrder extends OrderEvent {
  final String orderId;

  const AssignOrder(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class TrackOrder extends OrderEvent {
  final String orderId;

  const TrackOrder(this.orderId);

  @override
  List<Object> get props => [orderId];
}