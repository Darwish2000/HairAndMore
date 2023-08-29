import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair_and_more/Views/userPages/userProfilPage.dart';
import '../../utils/user_preferences.dart';
import '../Authentication/sign_in_page.dart';
import 'Appointments.dart';

class SideMenu extends StatelessWidget {

  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      backgroundColor: Colors.blueGrey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 26.0, left: 13.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/logo.png', scale: 2.8,),

              const SizedBox(
                height: 50.0,
              ),

              InkWell(
                  onTap: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserProfilePage(),));
                  },
                  child: drawerChild(Icons.person_outline_rounded, 'Profile')),
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Appointments(),));
                  },
                  child: drawerChild(Icons.featured_play_list_outlined, 'Bookings history')),
                  // drawerChild(Icons.history_outlined, 'Booking history'),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: MaterialButton(onPressed: () async {
                  await UserPreferences.clearStorage();
                print('-----------------------logout----------------------------------');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
                },
                  color: Colors.grey[700],
                  child: const Text('Logout', style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w900,
                  ),),),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerChild(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30.0,
            color: Colors.white,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
