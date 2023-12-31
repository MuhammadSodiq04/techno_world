import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:techno_world/ui/route/route_names.dart';
import '../../../data/models/product/product_model.dart';
import '../../../providers/products_provider.dart';
import '../../../utils/ui_utils/shimmer_photo.dart';

class ProductsScreenAdmin extends StatefulWidget {
  const ProductsScreenAdmin({super.key});

  @override
  State<ProductsScreenAdmin> createState() => _ProductsScreenAdminState();
}

class _ProductsScreenAdminState extends State<ProductsScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Products Admin"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.productAdd);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: context.read<ProductsProvider>().getProducts(""),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isNotEmpty
                ? ListView(
                    children: List.generate(
                      snapshot.data!.length,
                      (index) {
                        ProductModel productModel = snapshot.data![index];
                        return ListTile(
                          leading: SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: CachedNetworkImage(
                                      imageUrl: productModel.productImages[0],
                                      placeholder: (context, url) => const ShimmerPhoto(),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.error,
                                          color: Colors.red),
                                      width: 140.w,
                                      fit: BoxFit.cover
                                  )),
                          onLongPress: () {
                            context.read<ProductsProvider>().deleteProduct(
                                  context: context,
                                  productId: productModel.productId,
                                );
                          },
                          title: Text(productModel.productName,
                              style: const TextStyle(color: Colors.black)),
                          subtitle: Text(productModel.description,
                              style: const TextStyle(color: Colors.black)),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RouteNames.productAdd,arguments: productModel);
                            },
                            icon: const Icon(Icons.edit, color: Colors.black),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(child: Text("Product Empty!"));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
