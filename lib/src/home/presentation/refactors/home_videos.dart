import 'package:education_app/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:education_app/core/common/views/loading_view.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/common/widgets/video_tile.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/home/presentation/widget/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeVideos extends StatefulWidget {
  const HomeVideos({super.key});

  @override
  State<HomeVideos> createState() => _HomeVideosState();
}

class _HomeVideosState extends State<HomeVideos> {

  void getVideos() {
    final courseOfTheDay = context.read<CourseOfTheDayNotifier>();
    context.read<VideoCubit>().getVideos(courseOfTheDay.course!.id);
  }

  @override
  void initState() {
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    final courseOfTheDay = context.read<CourseOfTheDayNotifier>();

    return BlocConsumer<VideoCubit, VideoState>(
      listener: (context, state) {
        if (state is VideoError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is LoadingVideos) {
          return const LoadingView();
        } else if ((state is VideosLoaded && state.videos.isEmpty) ||
            state is VideoError) {
          return NotFoundText(
            text:
            'No videos found for ${courseOfTheDay.course!.title}',
          );
        } else if (state is VideosLoaded) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                sectionTitle: '${courseOfTheDay.course!.title} Videos',
                seeAll: state.videos.length > 4,
                onPressed: () => context.pushTab(
                  BlocProvider(
                    create: (_) => sl<VideoCubit>(),
                    // child: CourseVideosView(),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              for(final video in state.videos.take(5))
                 VideoTile(video: video,tappable: true),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
