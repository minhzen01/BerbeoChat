import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import '../../utils/strings.dart';

class HeaderEdit extends StatelessWidget {
  const HeaderEdit({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10),
      child: Row(
        children: [
          InkWell(
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
          const SizedBox(width: 10),
          Text(
            EDIT_PROFILE,
            style: txtSemiBold(18),
          )
        ],
      ),
    );
  }
}
