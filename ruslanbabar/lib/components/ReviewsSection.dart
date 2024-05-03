import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ruslanbabar/components/TopSectionHeader.dart';

class ReviewsSection extends StatelessWidget {
  ReviewsSection({super.key});

  final listOfReview = {
    "Professional":[
      {
        "James":"He is nice guy",
        "James":"He is nice guy",
      }
    ],
    "Clients":[
    {
      "James":"He is nice guy",
      "James":"He is nice guy",
    }
    ],
    "Academic":[
    {
      "James":"He is nice guy",
      "James":"He is nice guy",
    }
    ],
    "Athletic":[
    {
      "James":"He is nice guy",
      "James":"He is nice guy",
    }
    ]
  };
  @override
  Widget build(BuildContext context) {
    final double pad = 28;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.center,
      padding:  EdgeInsets.all( pad),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(13)
      ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text("Feedbacks/Reviews",style: Theme.of(context).textTheme.displaySmall),
      //     Text("What my clients says about me",style: Theme.of(context).textTheme.bodyMedium,),
      //     Container(
      //     padding: const EdgeInsets.symmetric(vertical: 20.0),
      //       width: MediaQuery.of(context).size.width *.2,
      //       child: SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: Row(
      //           children: [
      //               Container(
      //               padding:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      //               decoration: BoxDecoration(
      //                   color: colorScheme.primary,
      //                   borderRadius: BorderRadius.circular(20),
      //                   border: Border.all(color: colorScheme.primary)
      //               ),
      //               child: Text("Professional",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: colorScheme.secondary),),
      //             ),
      //             Container(
      //               padding:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      //               decoration: BoxDecoration(
      //                   color: colorScheme.primary,
      //                   borderRadius: BorderRadius.circular(20),
      //                   border: Border.all(color: colorScheme.primary)
      //               ),
      //               child: Text("Professional",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: colorScheme.secondary),),
      //             ),
      //             Container(
      //               padding:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      //               decoration: BoxDecoration(
      //                   color: colorScheme.primary,
      //                   borderRadius: BorderRadius.circular(20),
      //                   border: Border.all(color: colorScheme.primary)
      //               ),
      //               child: Text("Professional",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: colorScheme.secondary),),
      //             ),
      //           ]
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
