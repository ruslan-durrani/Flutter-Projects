import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

getImageWithLoadingBuilder(BuildContext context,String imgUrl ){
  return Image.network(
    imgUrl,
    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child;
      } else {
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      }
    },
  );
}