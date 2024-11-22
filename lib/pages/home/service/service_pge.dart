import 'package:app_car_rescue/components/button/cr_elevated_button.dart';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/models/area_model.dart';
import 'package:app_car_rescue/models/payload_model.dart';
import 'package:app_car_rescue/models/wheel_size_model.dart';
import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:app_car_rescue/services/remote/wheel_size_service.dart';
import 'package:flutter/material.dart';
import '../../../components/app_bar/custom_app_bar.dart';
import '../../../components/text_field/cr_text_field.dart';
import '../../../constants/app_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../models/service_model.dart';
import '../../../services/remote/area_service.dart';
import '../../../services/remote/payload_service.dart';
import '../../../services/remote/service.dart';
import '../../../utils/spaces.dart';
import '../../../utils/validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServicePge extends StatefulWidget {
  const ServicePge({super.key});

  @override
  State<ServicePge> createState() => _ServicePgeState();
}

class _ServicePgeState extends State<ServicePge> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final ServiceRequestService _serviceRequestService = ServiceRequestService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<AreaModel> areaList = [];
  List<PayloadModel> payloadList = [];
  List<WheelSizeModel> wheelSizeList = [];
  String? selectedArea;
  String? selectedPayload;
  String? selectedWheelSize;
  String selectedService = 'rescue';
  late Future<void> _dataFuture;

  double areaPrice = 0;
  double payloadPrice = 0;
  double wheelSizePrice = 0;
  double get totalPrice => areaPrice + payloadPrice + wheelSizePrice;

  final List<Map<String, String>> service = [
    {
      'code': 'rescue',
      'image': 'assets/images/car_truck_standard.png',
      'name': 'Rescue'
    },
    {
      'code': 'replace_tire',
      'image': 'assets/images/icob_lop.png',
      'name': 'Replace tire'
    }
  ];

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final futures = await Future.wait([
      AreaService().fetchAllAreasByCreateAt(),
      PayloadService().fetchAllPayloadsByCreateAt(),
      WheelSizeService().fetchAllWheelSizesByCreateAt(),
    ]);

    setState(() {
      areaList = futures[0] as List<AreaModel>;
      payloadList = futures[1] as List<PayloadModel>;
      wheelSizeList = futures[2] as List<WheelSizeModel>;
    });
  }

  void _updatePrices() {
    setState(() {
      areaPrice = 0;
      payloadPrice = 0;
      wheelSizePrice = 0;

      if (selectedArea != null) {
        final area = areaList.firstWhere((a) => a.id == selectedArea);
        areaPrice = area.price ?? 0;
      }

      if (selectedService == 'rescue' && selectedPayload != null) {
        final payload = payloadList.firstWhere((p) => p.id == selectedPayload);
        payloadPrice = payload.price ?? 0;
      }

      if (selectedService == 'replace_tire' && selectedWheelSize != null) {
        final wheelSize =
            wheelSizeList.firstWhere((w) => w.id == selectedWheelSize);
        wheelSizePrice = wheelSize.price ?? 0;
      }
    });
  }

  Future<void> _submitForm() async {
    try {
      final request = ServiceModel(
        userId: _serviceRequestService.userId,
        status: 'Pending',
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        phone: phoneController.text.trim(),
        note: noteController.text.trim(),
        service: selectedService,
        area: selectedArea,
        payload: selectedPayload,
        wheelSize: selectedWheelSize,
        totalPrice: totalPrice,
        createdAt: DateTime.now(),
      );

      // Gửi dữ liệu lên Firestore qua Service
      await ServiceRequestService().submitRequest(request);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted successfully!')),
      );

      // Reset form sau khi gửi
      _formKey.currentState?.reset();
      setState(() {
        selectedArea = null;
        selectedPayload = null;
        selectedWheelSize = null;
        areaPrice = 0;
        payloadPrice = 0;
        wheelSizePrice = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit request: $e')),
      );
    }
  }

  InputDecoration _getDropdownDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.E43484B, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: CustomAppBar(
              title: AppLocalizations.of(context)?.serviceRescue ?? 'Service',
            ),
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 92.0,
                          decoration: BoxDecoration(
                            color: AppColor.E575757.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0)
                                    .copyWith(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your order is delivered',
                                      style: AppStyle.bold_16
                                          .copyWith(color: AppColor.white),
                                    ),
                                    Text(
                                      'We appreciate your positive feedback.',
                                      style: AppStyle.semibold_11,
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  Assets.images.pngegg1.path,
                                  color: AppColor.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        spaceH10,
                        Column(
                          children: service.map((language) {
                            return RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: [
                                  Text(language['name']!),
                                  Spacer(),
                                  Image.asset(
                                    language['image']!,
                                    width: 40,
                                    height: 40,
                                  ),
                                ],
                              ),
                              value: language['code']!,
                              groupValue: selectedService,
                              onChanged: (value) {
                                setState(() {
                                  selectedService = value!;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        spaceH10,
                        DropdownButtonFormField<String>(
                          value: selectedArea,
                          decoration: _getDropdownDecoration(context,
                              AppLocalizations.of(context)?.area ?? 'Area'),
                          icon: Icon(Icons.arrow_drop_down,
                              color: AppColor.E43484B),
                          dropdownColor: Colors.white,
                          items: areaList.map((area) {
                            return DropdownMenuItem<String>(
                              value: area.id,
                              child: Text(area.name ?? '',
                                  style: AppStyle.regular_14),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedArea = value;
                              _updatePrices();
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select an area' : null,
                        ),
                        spaceH30,
                        if (selectedService == 'rescue') ...[
                          DropdownButtonFormField<String>(
                            value: selectedPayload,
                            decoration: _getDropdownDecoration(
                                context,
                                AppLocalizations.of(context)?.payload ??
                                    'Payload'),
                            icon: Icon(Icons.arrow_drop_down,
                                color: AppColor.E43484B),
                            dropdownColor: Colors.white,
                            items: payloadList.map((payload) {
                              return DropdownMenuItem<String>(
                                value: payload.id,
                                child: Text(payload.name ?? '',
                                    style: AppStyle.regular_14),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPayload = value;
                                _updatePrices();
                              });
                            },
                            validator: (value) => value == null
                                ? 'Please select a payload'
                                : null,
                          ),
                          spaceH30,
                        ],
                        if (selectedService == 'replace_tire') ...[
                          DropdownButtonFormField<String>(
                            value: selectedWheelSize,
                            decoration: _getDropdownDecoration(
                                context,
                                AppLocalizations.of(context)?.wheelSize ??
                                    'Wheel Size'),
                            icon: Icon(Icons.arrow_drop_down,
                                color: AppColor.E43484B),
                            dropdownColor: Colors.white,
                            items: wheelSizeList.map((wheelSize) {
                              return DropdownMenuItem<String>(
                                value: wheelSize.id,
                                child: Text(wheelSize.name ?? '',
                                    style: AppStyle.regular_14),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedWheelSize = value;
                                _updatePrices();
                              });
                            },
                            validator: (value) => value == null
                                ? 'Please select a wheel size'
                                : null,
                          ),
                          spaceH30,
                        ],
                        spaceH20,
                        Text(
                          AppLocalizations.of(context)?.rescueAddress ??
                              'Rescue address',
                          style: AppStyle.bold_20,
                        ),
                        spaceH20,
                        Column(
                          children: [
                            CrTextField(
                              controller: nameController,
                              labelText:
                                  AppLocalizations.of(context)?.firstName ??
                                      'First name',
                              textInputAction: TextInputAction.next,
                              validator: Validator.required,
                            ),
                            spaceH30,
                            CrTextField(
                              controller: addressController,
                              labelText:
                                  AppLocalizations.of(context)?.address ??
                                      'Address',
                              textInputAction: TextInputAction.next,
                              validator: Validator.required,
                            ),
                            spaceH30,
                            CrTextField(
                              controller: phoneController,
                              labelText:
                                  AppLocalizations.of(context)?.phoneNumber ??
                                      'Phone Number',
                              textInputAction: TextInputAction.next,
                              validator: Validator.phoneNumber,
                            ),
                            spaceH30,
                            CrTextField(
                              controller: noteController,
                              labelText:
                                  AppLocalizations.of(context)?.note ?? 'Note',
                              textInputAction: TextInputAction.done,
                              validator: Validator.required,
                            ),
                            spaceH100,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: CrElevatedButton(
                    text:
                        '${AppLocalizations.of(context)?.submit ?? 'Submit'} ( ${totalPrice.toVND()} )',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _submitForm();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
