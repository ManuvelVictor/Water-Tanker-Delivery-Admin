import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_bloc.dart';
import '../events/order_event.dart';
import '../states/order_state.dart';
import 'assign_order_screen.dart';
import 'track_order_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  OrdersScreenState createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> {
  late OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();
    _ordersBloc = OrdersBloc();
    _ordersBloc.add(FetchOrders());
  }

  Future<void> _refreshOrders() async {
    _ordersBloc.add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ordersBloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Orders',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: BlocBuilder<OrdersBloc, OrderState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state.orders.isEmpty) {
              return const Center(child: Text('No orders found.'));
            } else {
              final orders = state.orders;
              return defaultTargetPlatform == TargetPlatform.iOS
                  ? CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: _refreshOrders,
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final order = orders[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 16.0),
                                        title: Text(
                                          'Order by: ${order['userName']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (order['status'] != 'assigned')
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      _ordersBloc.add(
                                                          AssignOrder(
                                                              order['id']));
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AssignOrderScreen(
                                                            orderId:
                                                                order['id'],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                        'Assign Order'),
                                                  ),
                                                ),
                                              ),
                                            if (order['status'] == 'assigned')
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      _ordersBloc.add(
                                                          TrackOrder(
                                                              order['id']));
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              TrackOrderScreen(
                                                            orderId:
                                                                order['id'],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                        'Track Order'),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        isThreeLine: true,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: orders.length,
                          ),
                        ),
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshOrders,
                      child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    title: Text(
                                      'Order by: ${order['userName']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Tanks: ${order['numberOfTanks']}'),
                                        Text('Location: ${order['location']}'),
                                        if (order['status'] != 'assigned')
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _ordersBloc.add(
                                                      AssignOrder(order['id']));
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AssignOrderScreen(
                                                        orderId: order['id'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'Assign Order',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (order['status'] == 'assigned')
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _ordersBloc.add(
                                                      TrackOrder(order['id']));
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TrackOrderScreen(
                                                        orderId: order['id'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'Track Order',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    isThreeLine: true,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
            }
          },
        ),
      ),
    );
  }
}
