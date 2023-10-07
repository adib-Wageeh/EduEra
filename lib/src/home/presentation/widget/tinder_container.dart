import 'package:cached_network_image/cached_network_image.dart';
import 'package:education_app/core/common/features/course/presentation/views/course_details_screen.dart';
import 'package:education_app/src/home/presentation/providers/tinder_provider.dart';
import 'package:education_app/src/home/presentation/widget/tinder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final size = MediaQuery.of(context).size;
    return Center(
      child: Consumer<TinderProvider>(
        builder: (context,provider, __) {
          return SizedBox(
            height: size.width,
            width: size.width,
            child: TinderSwapCard(
              totalNum: provider.coursesList.length,
              swipeEdge: 4,
              allowSwipe: provider.coursesList.length != 1,
              maxWidth: size.width,
              maxHeight: size.width * .9,
              minWidth: size.width * 0.71,
              minHeight: size.width * .85,
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
                        top: size.width*0.25,
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
                        top: size.width*0.05,
                        right: 20.w,
                        child: CachedNetworkImage(
                          imageUrl:
                          provider.coursesList[
                          provider.currentIndex+index
                          ].image!,
                          height: 160.h,
                          width: 130.w,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
