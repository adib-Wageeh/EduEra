import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:education_app/core/common/views/loading_view.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/common/widgets/video_tile.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseVideosView extends StatefulWidget {
  const CourseVideosView({
  required this.course
  ,super.key,});
  final Course course;
  static const route = '/course-videos';

  @override
  State<CourseVideosView> createState() => _CourseVideosViewState();
}

class _CourseVideosViewState extends State<CourseVideosView> {

  void getVideos(){
    context.read<VideoCubit>().getVideos(widget.course.id);
  }

  @override
  void initState() {
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.course.title),
        centerTitle: false,
        leading: const NestedBackButton(),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search))
        ],
      ),
      body: GradientBackground(
          image: MediaRes.homeGradientBackground,
          child:
        BlocConsumer<VideoCubit,VideoState>(
          listener: (_,state){
            if(state is VideoError){
              CoreUtils.showSnackBar(context, state.message);
            }
          },
          builder: (context,state){
          if (state is LoadingVideos) {
            return const LoadingView();
          } else if ((state is VideosLoaded && state.videos.isEmpty) ||
          state is VideoError) {
            return NotFoundText(
            text:
            'No videos found for ${widget.course.title}',
            );
          } else if (state is VideosLoaded) {
            final videos = state.videos..sort((a,b)=> b.uploadDate
            .compareTo(a.uploadDate,),);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.course.title} Videos',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                  Text('${widget.course.numberOfVideos} video(s) found',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colours.neutralTextColour,
                  ),
                  ),
                  Expanded(child: ListView.builder(
                      itemBuilder: (context,index){
                        return VideoTile(video: videos[index],
                        tappable: true,);
                      },
                  itemCount: state.videos.length,
                  ),)
                ],
              ),
            );
          }
            return const SizedBox.shrink();
          },
        )
        ,),
    );
  }
}