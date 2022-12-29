import 'package:appchat/views/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/message.dart';
import '../../constants.dart';


class LocationItem extends StatefulWidget {
  const LocationItem({
    Key? key,
    required this.isMe,
    required this.isMidle,
    required this.isLast,
    required this.message
  }) : super(key: key);
  final bool isMe;
  final bool isMidle;
  final bool isLast;
  final Message message;

  @override
  State<LocationItem> createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.45),
                  borderRadius: messageBorderRadius(widget.isMe, widget.isMidle, widget.isLast)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: SvgPicture.asset(
                          location,
                          width: 30,
                          height: 30,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Vị trí trực tiếp", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              "${widget.message.senderName} đã bắt đầu chia sẻ",
                              softWrap: true,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Center(
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          String vt = "+";
                          // final startIndex = locationMessage.indexOf(vt);
                          // var myInt = double.parse(locationMessage.substring(startIndex + 1, locationMessage.length));
                          // assert(myInt is double);
                          // print(myInt);
                          var lati = double.parse(widget.message.message!.substring(0, widget.message.message!.indexOf(vt)));
                          assert(lati is double);
                          var long = double.parse(widget.message.message!.substring(widget.message.message!.indexOf(vt) + 1, widget.message.message!.length));
                          assert(long is double);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => LocationScreen(lati: lati, long: long)
                              )
                          );
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                        child: const Text(
                          "Xem vị trí",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    );
  }

  EdgeInsetsGeometry paddingItem() {
    if (widget.isMidle) {
      return const EdgeInsets.symmetric(vertical: 1, horizontal: 16);
    }
    if (widget.isLast) {
      return const EdgeInsets.only(bottom: 1, top: 8, left: 16, right: 16);
    }
    return const EdgeInsets.only(top: 1, left: 16, right: 16);
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
