import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/search_controller.dart';

class HeaderSearch extends StatelessWidget {
  const HeaderSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SizedBox(
        height: 45,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // width: SizeConfig.screenWidth,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Color.fromRGBO(142, 142, 147, 0.30196078431372547),
          ),
          child: TextField(
            autofocus: true,
            onChanged: (val) {
              context.read<SearchController>().searchUser(val);
            },
            decoration: const InputDecoration(
              icon: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              border: InputBorder.none,
              hintText: "Search here...",
              hintStyle: TextStyle(
                  color: Colors.black
              ),
            ),
          ),
        ),
      ),
    );
  }
}
