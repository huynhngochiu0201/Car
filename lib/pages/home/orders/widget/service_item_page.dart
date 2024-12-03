import 'package:app_car_rescue/constants/double_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_style.dart';
import '../../../../models/service_model.dart';
import '../../../../services/remote/service.dart';

class ServiceItemPage extends StatefulWidget {
  const ServiceItemPage({super.key});

  @override
  State<ServiceItemPage> createState() => _ServiceItemPageState();
}

class _ServiceItemPageState extends State<ServiceItemPage> {
  @override
  Widget build(BuildContext context) {
    final serviceRequestService = ServiceRequestService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: StreamBuilder<List<ServiceModel>>(
            stream: serviceRequestService
                .streamServicesByUserId(serviceRequestService.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No services available.'));
              }

              final services = snapshot.data!;

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 23.0),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Service# ${service.nameservice}',
                                style: AppStyle.bold_18,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('dd/MM/yyyy').format(service.createdAt),
                          style: AppStyle.regular_14,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal: ${(service.totalPrice.toVND())}',
                              style: AppStyle.regular_14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              service.status,
                              style: AppStyle.regular_14.copyWith(
                                color: AppColor.ECF6212,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 20.0);
                },
                itemCount: services.length,
              );
            },
          )),
    );
  }
}
