import 'package:appchat/controllers/firebase_auth_controller.dart';
import 'package:appchat/resources/widgets/home/AllUserItem.dart';
import 'package:appchat/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/search_controller.dart';
import '../data_sources/firebase_services.dart';
import '../resources/widgets/home/body_home.dart';
import '../resources/widgets/home/header_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FirebaseAuthController>().appUser;
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  child: HeaderHome(user: user!)
              ),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(1),
                      backgroundColor: MaterialStateProperty.all(Colors.white54),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            // side: BorderSide(color: Color)
                        )
                      )
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Colors.black,),
                        SizedBox(width: 7,),
                        Text("Search", style: TextStyle(fontSize: 16, color: Colors.black),),
                      ],
                    )
                ),
              ),
              const SizedBox(height: 15,),
              SizedBox(
                height: 100,
                child: ChangeNotifierProvider<SearchController>(
                    create: (_) => SearchController(user.uid!),
                    builder: (context, child) {
                      final controller = context.watch<SearchController>();
                      return Scaffold(
                        body: SafeArea(
                          child: Column(
                            children: [
                              Expanded(
                                child: controller.listSearchUser.isNotEmpty ?
                                ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.listSearchUser.length,
                                  itemBuilder: (context, index) => AllUserItem(
                                      appUser: controller.listSearchUser[index]),
                                ) :
                                ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.listAllUser.length,
                                  itemBuilder: (context, index) => AllUserItem(
                                      appUser: controller.listAllUser[index]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                )
              ),
              Expanded(
                  child: BodyHome(firebaseServices: firebaseServices, user: user)
              ),
            ],
          ),
        ));
  }
}
