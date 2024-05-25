import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/features/dashboard/repository/social_media_repository.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ArticleView extends ConsumerStatefulWidget {
  final String articleTitle;
  final String articleDes;
  final String videoUrl;
  final IconData iconData;
  const ArticleView({
    super.key,
    required this.articleTitle,
    required this.articleDes,
    required this.iconData,
    required this.videoUrl,
  });

  @override
  ConsumerState<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends ConsumerState<ArticleView> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false));
  }

  Future bookMarkArticle() async {
    if (ref
        .read(profileRepositoryProvider)
        .profile!
        .bookMarkArticles
        .contains(widget.articleTitle)) {
      await ref
          .read(socialMediaRepositoryProvider)
          .unBookMarkArticles(widget.articleTitle);
    } else {
      await ref
          .read(socialMediaRepositoryProvider)
          .bookMarkArticle(widget.articleTitle);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
            height: MediaQuery.of(context).size.height *.2,
            decoration:  BoxDecoration(
              color: EColors.primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.arrow_back,color: Colors.white,),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // width: MediaQuery.of(context).size.width *.8,
                                child: Text(
                                  "ARTICLE VIEW",
                                  style: GoogleFonts.openSans(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${DateTime.now().day} ${DateTime.now().month},${DateTime.now().year}",
                                style: GoogleFonts.openSans(
                                    color: Colors.grey[300], fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => bookMarkArticle(),
                        icon: Icon(
                          ref
                              .read(profileRepositoryProvider)
                              .profile!
                              .bookMarkArticles
                              .contains(widget.articleTitle)
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15.0),
            height: MediaQuery.of(context).size.height * 0.8,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: EColors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: EColors.primaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Icon(
                    widget.iconData,
                    color: EColors.primaryColor,
                    size: 50,
                  ),
                ),
                Container(
                  padding:EdgeInsets.symmetric(vertical: 20) ,child: Text(
                  "Article Description",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: EColors.textPrimary),
                ),
                ),

                Text(
                  widget.articleDes,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: EColors.textSecondary,fontWeight: FontWeight.w100),
                ),
                const SizedBox(
                  height: 20,
                ),
                  Container(
                    padding:EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                    "Recommended Video",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: EColors.textPrimary),
                  ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
