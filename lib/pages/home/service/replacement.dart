// import 'package:app_car_rescue/components/button/cr_elevated_button.dart';
// import 'package:flutter/material.dart';
// import '../../../components/text_field/cr_text_field.dart';
// import '../../../constants/app_color.dart';
// import '../../../constants/app_style.dart';
// import '../../../utils/spaces.dart';
// import '../../../utils/validator.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class Replacement extends StatefulWidget {
//   const Replacement({super.key});

//   @override
//   State<Replacement> createState() => _ReplacementState();
// }

// class _ReplacementState extends State<Replacement> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController utomotiveController = TextEditingController();
//   final TextEditingController sizeController = TextEditingController();
//   final TextEditingController noteController = TextEditingController();

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   String? selectedSize = '13 - 14 inch';
//   String? selectedArea = 'In the city <12 Km';

//   final List<String> size = [
//     '13 - 14 inch',
//     '15 - 17 inch',
//     '18 - 19 inch',
//     '20 - 22 inch',
//   ];
//   final List<String> area = [
//     'In the city <12 Km',
//     'Out of city >12 Km',
//     'On the highway',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   AppLocalizations.of(context)?.rescueAddress ??
//                       'Rescue address',
//                   style: AppStyle.bold_20,
//                 ),
//                 spaceH20,
//                 Column(
//                   children: [
//                     CrTextField(
//                       controller: nameController,
//                       labelText: AppLocalizations.of(context)?.firstName ??
//                           'First name',
//                       textInputAction: TextInputAction.next,
//                       validator: Validator.required,
//                     ),
//                     spaceH30,
//                     CrTextField(
//                       controller: addressController,
//                       labelText:
//                           AppLocalizations.of(context)?.address ?? 'Address',
//                       textInputAction: TextInputAction.next,
//                       validator: Validator.required,
//                     ),
//                     spaceH30,
//                     CrTextField(
//                       controller: phoneController,
//                       labelText: AppLocalizations.of(context)?.phoneNumber ??
//                           'Phone Number',
//                       textInputAction: TextInputAction.next,
//                       validator: Validator.phoneNumber,
//                     ),
//                     spaceH30,
//                     CrTextField(
//                       controller: noteController,
//                       labelText: AppLocalizations.of(context)?.note ?? 'Note',
//                       textInputAction: TextInputAction.done,
//                       validator: Validator.required,
//                     ),
//                     spaceH30,
//                     Row(
//                       children: [
//                         Expanded(
//                           child: DropdownButtonFormField<String>(
//                             borderRadius: BorderRadius.circular(20.0),
//                             dropdownColor: AppColor.white,
//                             value: selectedSize,
//                             decoration: InputDecoration(
//                               labelText:
//                                   AppLocalizations.of(context)?.wheelSize ??
//                                       'Wheel Size',
//                               // contentPadding:
//                               //     EdgeInsets.symmetric(horizontal: 12.0),
//                             ),
//                             icon: Icon(Icons.arrow_drop_down),
//                             iconSize: 24,
//                             elevation: 16,
//                             style: TextStyle(color: Colors.black, fontSize: 16),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedSize = newValue!;
//                               });
//                             },
//                             items: size
//                                 .map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                         spaceW20,
//                         Expanded(
//                           child: DropdownButtonFormField<String>(
//                             borderRadius: BorderRadius.circular(20.0),
//                             dropdownColor: AppColor.white,
//                             value: selectedArea,
//                             decoration: InputDecoration(
//                               labelText:
//                                   AppLocalizations.of(context)?.area ?? 'Area',
//                               // contentPadding:
//                               //     EdgeInsets.symmetric(horizontal: 12.0),
//                             ),
//                             icon: Icon(Icons.arrow_drop_down),
//                             iconSize: 24,
//                             elevation: 16,
//                             style: TextStyle(color: Colors.black, fontSize: 16),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedArea = newValue!;
//                               });
//                             },
//                             items: area
//                                 .map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 spaceH30,
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                   child: CrElevatedButton(
//                     text: AppLocalizations.of(context)?.submit ?? 'Submit',
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         // Handle form submission
//                       }
//                     },
//                   ),
//                 ),
//                 spaceH30,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
