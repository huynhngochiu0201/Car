import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import '../../components/button/cr_elevated_button.dart';
import '../../models/onboarding_model.dart';
import '../../services/shared_prefs.dart';
import '../auth/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SharedPrefs.isAccessed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          _buildBackground(),
          _buildPageView(),
          _buildIndicator(),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 54.0)
                .copyWith(top: 90.0),
            child: Column(
              children: [
                Text(
                  'Welcome to our service',
                  style: AppStyle.bold_20.copyWith(color: AppColor.black),
                ),
                spaceH16,
                Center(
                  child: Text(
                    onboardings[_currentIndex].text ?? '',
                    style: AppStyle.regular_14.copyWith(color: AppColor.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 351,
          decoration: BoxDecoration(color: AppColor.E464447),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return Positioned(
      bottom: 240.0,
      left: 54.0,
      right: 54.0,
      child: Container(
        height: 391.0,
        decoration: BoxDecoration(
          color: AppColor.E7E8E9,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: onboardings.length,
          itemBuilder: (context, index) {
            return Image.asset(
              onboardings[index].imagePath ?? '',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 190.0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          onboardings.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.white),
                color:
                    index == _currentIndex ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Positioned(
      bottom: 110.0,
      left: 40.0,
      right: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(),
          _buildNextOrStartButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return CrElevatedButton.outline(
      onPressed: _currentIndex > 0
          ? () {
              setState(() {
                _currentIndex--;
              });
              _pageController.animateToPage(
                _currentIndex,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              );
            }
          : null,
      text: 'Back',
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      textColor: _currentIndex > 0 ? AppColor.white : AppColor.white,
      borderColor: _currentIndex > 0 ? AppColor.white : AppColor.E464447,
    );
  }

  Widget _buildNextOrStartButton() {
    return CrElevatedButton(
      onPressed: () {
        if (_currentIndex < onboardings.length - 1) {
          setState(() {
            _currentIndex++;
          });
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      },
      text: _currentIndex == onboardings.length - 1 ? 'Start' : 'Next',
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
    );
  }
}
