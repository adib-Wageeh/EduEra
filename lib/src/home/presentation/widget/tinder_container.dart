import 'package:cached_network_image/cached_network_image.dart';
import 'package:education_app/core/common/features/course/presentation/views/course_details_screen.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/src/home/presentation/providers/tinder_provider.dart';
import 'package:education_app/src/home/presentation/widget/tinder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:provider/provider.dart';

class TinderContainer extends StatefulWidget {
  const TinderContainer({
    super.key,});

  @override
  State<TinderContainer> createState() => _TinderContainerState();
}

class _TinderContainerState extends State<TinderContainer> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: context.width,
        width: context.width,
        child: Consumer<TinderProvider>(
          builder: (context,provider, __) {
            return TinderSwapCard(
              totalNum: provider.coursesList.length,
              swipeEdge: 4,
              allowSwipe: provider.coursesList.length != 1,
              maxWidth: context.width,
              maxHeight: context.width * .9,
              minWidth: context.width * .71,
              minHeight: context.width * .85,
              swipeCompleteCallback: (CardSwipeOrientation orientation,
                  int index,) {
                if(orientation != CardSwipeOrientation.recover) {
                    provider.add();
                  }
              },

              cardBuilder: (context, index) {
                return GestureDetector(
                onTap: (){
                 Navigator.of(context).pushNamed(
                     CourseDetailsScreen.route,
                    arguments: provider.coursesList[
                    provider.currentIndex+index
                    ],
                 );
                }
                ,child: Stack(
                    children: [
                      Positioned(
                        bottom: 110,
                        right: 0,
                        left: 0,
                        child: TinderCard(
                          course: provider.coursesList[
                            provider.currentIndex+index
                          ],
                          index: index,
                        ),
                      ),
                      if(index == 0 && provider.coursesList[
                      provider.currentIndex+index
                      ].image!.isNotEmpty)
                      Positioned(
                        bottom: 130,
                        right: 20,
                        child: CachedNetworkImage(
                          imageUrl:
                          provider.coursesList[
                          provider.currentIndex+index
                          ].image!,
                          height: 180,
                          width: 149,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
