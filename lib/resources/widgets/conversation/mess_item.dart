import 'package:flutter/material.dart';
import '../../constants.dart';

class MessItem extends StatelessWidget {
  const MessItem({
    Key? key,
    required this.isMe,
    required this.isMidle,
    required this.isLast,
    required this.message
  }) : super(key: key);
  final bool isMe;
  final bool isMidle;
  final bool isLast;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingItem(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: isMe ? primaryColor : secondaryColor,
                borderRadius: messageBorderRadius(isMe, isMidle, isLast)
            ),
            child: Text(
              message,
              style: isMe ? txtMedium(16, Colors.white) : txtMedium(16),
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsetsGeometry paddingItem() {
    if (isMidle) {
      return const EdgeInsets.symmetric(vertical: 1, horizontal: 16);
    }
    if (isLast) {
      return const EdgeInsets.only(bottom: 1, top: 8, left: 16, right: 16);
    }
    return const EdgeInsets.only(top: 2, left: 16, right: 16);
  }

  BorderRadiusGeometry messageBorderRadius(
      bool isMe, bool isMidle, bool isLast) {
    if (isMe) {
      if (isMidle) {
        return const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        );
      }
      if (isLast) {
        return const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        );
      }
      return const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10)
      );
    } else {
      if (isMidle) {
        return const BorderRadius.only(
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        );
      }
      if (isLast) {
        return const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        );
      }
      return const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10)
      );
    }
  }
}
