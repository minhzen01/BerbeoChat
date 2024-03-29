import 'package:flutter/material.dart';
import '../../constants.dart';

class HeaderSignIn extends StatelessWidget {
  const HeaderSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                "Welcome to",
                style: txtSemiBold(18),
              ),
              Text(
                "Berbeo Chat",
                style: txtSemiBold(32, primaryColor),
              )
            ],
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: Hero(
                    tag: amzChatIcon,
                    child: Image.asset(amzChatIcon),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
