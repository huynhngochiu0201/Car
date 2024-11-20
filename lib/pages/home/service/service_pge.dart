import 'package:app_car_rescue/components/button/cr_elevated_button.dart';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:flutter/material.dart';
import '../../../components/app_bar/custom_app_bar.dart';
import '../../../components/text_field/cr_text_field.dart';
import '../../../constants/app_style.dart';
import '../../../gen/assets.gen.dart';
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
  final TextEditingController utomotiveController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Map<String, String>> languages = [
    {
      'code': 'r',
      'image': 'assets/images/car_truck_standard.png',
      'name': 'Rescue'
    },
    {
      'code': 'ct',
      'image': 'assets/images/icob_lop.png',
      'name': 'Replace tire'
    }
  ];

  String? selectedArea = 'In the city <12 Km';
  String? selectedPayload = 'Under 0.5 tons';
  String selectedService = 'r';

  final List<String> area = [
    'In the city <12 Km',
    'Out of city >12 Km',
    'On the highway',
  ];

  final List<String> payload = [
    'Under 0.5 tons',
    '0.5 to 1.5 tons',
    '1.5 to <5 tons',
    '5 to 11 tons',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)?.service ?? 'Service',
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0)
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
                    children: languages.map((language) {
                      return RadioListTile<String>(
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
                        labelText: AppLocalizations.of(context)?.firstName ??
                            'First name',
                        textInputAction: TextInputAction.next,
                        validator: Validator.required,
                      ),
                      spaceH30,
                      CrTextField(
                        controller: addressController,
                        labelText:
                            AppLocalizations.of(context)?.address ?? 'Address',
                        textInputAction: TextInputAction.next,
                        validator: Validator.required,
                      ),
                      spaceH30,
                      CrTextField(
                        controller: phoneController,
                        labelText: AppLocalizations.of(context)?.phoneNumber ??
                            'Phone Number',
                        textInputAction: TextInputAction.next,
                        validator: Validator.phoneNumber,
                      ),
                      spaceH30,
                      CrTextField(
                        controller: noteController,
                        labelText: AppLocalizations.of(context)?.note ?? 'Note',
                        textInputAction: TextInputAction.done,
                        validator: Validator.required,
                      ),
                      spaceH30,
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              borderRadius: BorderRadius.circular(20.0),
                              dropdownColor: AppColor.white,
                              value: selectedArea,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)?.area ??
                                    'Area',
                                // contentPadding:
                                //     EdgeInsets.symmetric(horizontal: 12.0),
                              ),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedArea = newValue!;
                                });
                              },
                              items: area.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          spaceW20,
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              borderRadius: BorderRadius.circular(20.0),
                              dropdownColor: AppColor.white,
                              value: selectedPayload,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)?.payload ??
                                        'Payload',
                                // contentPadding:
                                //     EdgeInsets.symmetric(horizontal: 12.0),
                              ),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedPayload = newValue!;
                                });
                              },
                              items: payload.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  spaceH30,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: CrElevatedButton(
                      text: AppLocalizations.of(context)?.submit ?? 'Submit',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission
                        }
                      },
                    ),
                  ),
                  spaceH30,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
