import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/order_event.dart';
import '../states/order_state.dart';

class OrdersBloc extends Bloc<OrderEvent, OrderState> {
  OrdersBloc() : super(const OrderState(isLoading: true, orders: [])) {
    on<FetchOrders>(_onFetchOrders);
    on<AssignOrder>(_onAssignOrder);
    on<TrackOrder>(_onTrackOrder);
  }

  Future<void> _onFetchOrders(FetchOrders event, Emitter<OrderState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final snapshot = await FirebaseFirestore.instance.collection('orders').get();
      final orders = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      emit(state.copyWith(isLoading: false, orders: orders));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onAssignOrder(AssignOrder event, Emitter<OrderState> emit) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(event.orderId).update({
        'status': 'assigned',
        'assignedWorkerId': 'default_worker_id',
      });
      add(FetchOrders());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onTrackOrder(TrackOrder event, Emitter<OrderState> emit) {
    // To do
  }
}
