import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:app_car_rescue/components/button/cr_elevated_button.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/pages/home/profile/language/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguageCode = 'en'; // Ngôn ngữ được chọn mặc định

  void _changeLanguage(BuildContext context, String languageCode) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    // Danh sách các ngôn ngữ hỗ trợ
    final List<Map<String, String>> languages = [
      {'code': 'en', 'image': 'assets/images/usa.png', 'name': 'English'},
      {
        'code': 'vi',
        'image': 'assets/images/vietnam.png',
        'name': 'Tiếng Việt'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Language'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 1.0, color: Colors.grey)),
                    child: RadioListTile<String>(
                      value: language['code']!,
                      groupValue: _selectedLanguageCode,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguageCode = value!;
                        });
                      },
                      title: Text(
                        language['name']!,
                        style: AppStyle.bold_16,
                      ),
                      secondary: Image.asset(
                        language['image']!,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
            child: CrElevatedButton.outline(
              text: 'Done',
              onPressed: () {
                _changeLanguage(context, _selectedLanguageCode);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
