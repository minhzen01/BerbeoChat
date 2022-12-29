import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/firebase_auth_controller.dart';
import '../controllers/search_controller.dart';
import '../resources/constants.dart';
import '../resources/widgets/search/header_search.dart';
import '../resources/widgets/search/search_result_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthController>().appUser;
    return ChangeNotifierProvider<SearchController>(
      create: (_) => SearchController(user!.uid!),
      builder: (context, child) {
        final controller = context.watch<SearchController>();
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderSearch(),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 2),
                  child: Text("List User:", style: txtMedium(16))
                ),
                Expanded(
                  child: controller.listSearchUser.isNotEmpty ?
                  ListView.builder(
                    itemCount: controller.listSearchUser.length,
                    itemBuilder: (context, index) => SearchResultUserItem(
                          appUser: controller.listSearchUser[index]),
                        ) :
                  ListView.builder(
                    itemCount: controller.listAllUser.length,
                    itemBuilder: (context, index) => SearchResultUserItem(
                        appUser: controller.listAllUser[index]),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
