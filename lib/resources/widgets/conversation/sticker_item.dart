import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/message_controller.dart';

class StickerItem extends StatelessWidget {
  const StickerItem({Key? key, required this.url, required this.path}) : super(key: key);
  final String url;
  final String path;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () =>
          context.read<MessageController>().onSendSticker(
              url: [url],
              type: 'sticker'
          ),
      child: Image.asset(
        path,
        width: 65,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }
}
