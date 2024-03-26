import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../common/constants/colors.dart';

class MessageItem extends StatefulWidget {
  final bool isReceiver;
  final String message;
  final String photoUrl;
  final bool isRead;

  MessageItem({
    super.key,
    required this.isReceiver,
    required this.message,
    this.photoUrl = "",
    this.isRead = false,
  });

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: widget.isReceiver ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          crossAxisAlignment: widget.isReceiver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(

              padding: widget.photoUrl.isEmpty ? EdgeInsets.symmetric(horizontal: 10, vertical: 8) : EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: widget.isReceiver ? Colors.grey[300] : AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: widget.isReceiver ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: widget.isReceiver ? Radius.circular(12) : Radius.circular(0),
                ),
              ),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              child: widget.photoUrl.isEmpty ? _buildTextMessage() : _buildImageMessage(),
            ),
            if (!widget.isReceiver) // Showing read receipt only for sent messages
              Icon(
                widget.isRead ? Icons.done_all : Icons.done,
                size: 12,
                color: widget.isRead ? Colors.blue : Colors.blue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextMessage() {
    return Column(
      children: [
        Text(
          widget.message,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: widget.isReceiver ? Colors.black87 : Colors.white)
        ),

      ],
    );
  }

  Widget _buildImageMessage() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: widget.photoUrl,
            placeholder: (context, url) => const SpinKitFadingCircle(
              color: AppColors.primaryColor,
              size: 50.0,
            ),
          ),
          // child: Image.network(
          //   widget.photoUrl,
          //   fit: BoxFit.cover,
          //   loadingBuilder: (context, child, loadingProgress) {
          //     if (loadingProgress == null) return child;
          //     return Center(child: CircularProgressIndicator());
          //   },
          //   errorBuilder: (context, error, stackTrace) {
          //     return Text('Unable to load image');
          //   },
          // ),
        ),

      ],
    );
  }
}
