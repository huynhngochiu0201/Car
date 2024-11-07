import 'package:app_car_rescue/gen/assets.gen.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../components/app_dialog/app_dialog.dart';
import '../../../constants/app_color.dart';
import '../../../services/shared_prefs.dart';
import '../../auth/change_password_page.dart';
import '../../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 96),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34.0,
                    backgroundImage: SharedPrefs.user?.avatar != null
                        ? NetworkImage(SharedPrefs.user!.avatar!)
                        : AssetImage(Assets.images.autocarlogo.path)
                            as ImageProvider,
                  ),
                  spaceW20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(color: AppColor.red, fontSize: 20.0),
                      ),
                      Text(
                        SharedPrefs.user?.name ?? '',
                        style: const TextStyle(
                          color: AppColor.brown,
                          fontSize: 16.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            spaceH54,
            Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordPage(),
                              ));
                        },
                        behavior: HitTestBehavior.translucent,
                        child: const Row(
                          children: [
                            Icon(Icons.lock_outline),
                            Text('Change Password'),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordPage(),
                              ));
                        },
                        behavior: HitTestBehavior.translucent,
                        child: const Row(
                          children: [
                            Icon(Icons.lock_outline),
                            Text('Change Password'),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordPage(),
                              ));
                        },
                        behavior: HitTestBehavior.translucent,
                        child: const Row(
                          children: [
                            Icon(Icons.lock_outline),
                            Text('Change Password'),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: InkWell(
                        onTap: () => AppDialog.dialog(
                          context,
                          title: '😍',
                          content: 'Do you want to logout?',
                          action: () async {
                            await FirebaseAuth.instance.signOut();
                            await SharedPrefs.removeSeason();
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            }
                          },
                        ),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: const Row(
                          children: [
                            Icon(Icons.logout),
                            Text(
                              'Logout',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
