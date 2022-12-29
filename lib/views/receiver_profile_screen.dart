import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/app_user.dart';
import '../resources/constants.dart';
import '../resources/utils/utils.dart';

class ReceiverProfileScreen extends StatelessWidget {
  const ReceiverProfileScreen({
    Key? key,
    required this.receiver,
  }) : super(key: key);
  final AppUser receiver;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                  backIcon,
                  width: 30,
                  height: 30,
                  color: primaryColor
              ),
            ),
          ),
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.withOpacity(0.6),
              backgroundImage: receiver.photoUrl != null ?
              NetworkImage(receiver.photoUrl!) : null,
              child: receiver.photoUrl != null ? null :
              Text(
                  Utils.nameInit(receiver.displayName ?? ""),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                  )
              ),
            ),
          ),
          const SizedBox(height: 15,),
          Center(
            child: Text(
                receiver.displayName ?? "",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                )
            ),
          ),
          const SizedBox(height: 10,),
          Center(
            child: Text(
              receiver.email ?? "",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
