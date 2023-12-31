import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/order/order_model.dart';
import '../../../providers/order_provider.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basket"),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: context
            .read<OrderProvider>()
            .listenOrdersList(FirebaseAuth.instance.currentUser!.uid),
        builder:
            (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isNotEmpty
                ? ListView(
              children: List.generate(
                snapshot.data!.length,
                    (index) {
                  OrderModel orderModel = snapshot.data![index];
                  return ListTile(
                    onLongPress: (){
                      context.read<OrderProvider>().deleteOrder(context: context, orderId: orderModel.orderId);
                    },
                    title: Text(orderModel.productName),
                    subtitle: Text(orderModel.count.toString()),
                    trailing: Text(orderModel.orderStatus),
                  );
                },
              ),
            )
                : const Center(child: Text("Empty!"));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
