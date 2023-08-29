import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:hair_and_more/Views/userPages/topBarberCard.dart';
import 'package:hair_and_more/Views/userPages/userProfilPage.dart';
import 'package:hair_and_more/controllers/homePageProv.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../utils/colorsApp.dart';
import '../../utils/textStyle.dart';
import 'barbersCard.dart';
import 'barbersPage.dart';
import 'drawer.dart';

class HomePage extends StatelessWidget {
  final _advancedDrawerController = AdvancedDrawerController();

  TextEditingController textController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePageProv(),
      builder: (context, child) => Consumer<HomePageProv>(
          builder: (context, prov, child) => !prov.isLoading
              ? AdvancedDrawer(
                  backdropColor: Colors.blueGrey,
                  controller: _advancedDrawerController,
                  animationCurve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 400),
                  animateChildDecoration: true,
                  rtlOpening: false,
                  //openScale: 1.0,
                  disabledGestures: false,
                  childDecoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  drawer: const SideMenu(),
                  child: Scaffold(
                    appBar: AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.white,
                      leading: InkWell(
                        onTap: () {
                          _advancedDrawerController.showDrawer();
                        },
                        child: const Icon(
                          Icons.short_text,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      actions: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserProfilePage(),
                                ));
                          },
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(13)),
                            child: !prov.isFirebaseImage
                                ? Container(
                                    height: 40,
                                    width: 60,
                                    child: Image.asset("images/logo.png",
                                        fit: BoxFit.fill),
                                  )
                                : Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image:
                                                NetworkImage(prov.imageUrl!)))),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        )
                      ],
                    ),
                    backgroundColor: Colors.white,
                    body: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello,",
                              style: TextStyles.title,
                            ),
                            Text('${prov.firstName} ${prov.lastName}',
                                style: TextStyles.h1Style),
                            SizedBox(
                              height: 2.h,
                            ),
                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(13)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: LightColor.grey.withOpacity(.8),
                                    blurRadius: 15,
                                    offset: Offset(5, 5),
                                  )
                                ],
                              ),
                              child: TextField(
                                controller: textController,
                                onChanged: (value) {
                                  print('hello');
                                  prov.barberSearch(textController.text);
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  border: InputBorder.none,
                                  hintText: "Search...",
                                  // hintStyle: TextStyles.body.subTitleColor,
                                  suffixIcon: SizedBox(
                                      width: 50,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.blueGrey,
                                          ))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            !prov.isSearch ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Top Barbers',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                SizedBox(
                                  height: 20.h,
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: prov.barbers.length,
                                    itemBuilder: (context, index) =>
                                        TopBarberCard(prov.barbers[index]),
                                  ),

                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'all barbers',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BarbersPage(prov.barbers),
                                            ));
                                      },
                                      child: const Icon(
                                        Icons.short_text,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                              ],
                            ) : const SizedBox(),
                            !prov.isSearch ?SizedBox(
                              height: 26.h,
                              width: double.maxFinite,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: prov.barbers.length,
                                itemBuilder: (context, index) =>
                                    BarbersCard(prov.barbers[index]),
                              ),

                            ) : SizedBox(
                              height: 66.h,
                              width: double.maxFinite,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: prov.filteredList.length,
                                itemBuilder: (context, index) =>
                                    BarbersCard(prov.filteredList[index]),
                              ),
                            )
                            ,
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )),
    );
  }
}
