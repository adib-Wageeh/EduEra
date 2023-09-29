import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/features/videos/data/models/video_model.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/utils/video_utils.dart';
import 'package:education_app/core/common/widgets/course_picker.dart';
import 'package:education_app/core/common/widgets/information_field.dart';
import 'package:education_app/core/common/widgets/reactive_button.dart';
import 'package:education_app/core/common/widgets/video_tile.dart';
import 'package:education_app/core/enums/notification.dart';
import 'package:education_app/core/extensions/string_extensions.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/notification/presentation/widgets/notification_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';


class AddVideoView extends StatefulWidget {
  const AddVideoView({super.key});

  static const route = '/add-video';

  @override
  State<AddVideoView> createState() => _AddVideoViewState();
}

class _AddVideoViewState extends State<AddVideoView> {

  final urlController = TextEditingController();
  final authorController = TextEditingController(text: 'adib');
  final titleController = TextEditingController();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  final formKey = GlobalKey<FormState>();

  final authorFocusNode = FocusNode();
  final titleFocusNode = FocusNode();
  final urlFocusNode = FocusNode();
  VideoModel? video;
  PreviewData? previewData;

  bool getMoreDetails = false;

  bool get isYouTube => urlController.text.trim().checkIfYoutube;

  bool thumbNailIsFile = false;
  bool loading = false;
  bool showingDialog = false;

  void reset(){

    setState(() {
      urlController.clear();
      authorController.text = 'adib';
      titleController.clear();
      getMoreDetails = false;
      loading = false;
      video = null;
      previewData = null;
    });
  }

  @override
  void initState() {
    super.initState();

    urlController.addListener(() {
      if(urlController.text.trim().isEmpty) reset();
    });
    authorController.addListener(() {
      video = video?.copyWith(
        tutor: authorController.text.trim(),
      );
    });
    titleController.addListener(() {
      video = video?.copyWith(
        title: titleController.text.trim(),
      );
    });
  }

  @override
  void dispose() {
    urlController.dispose();
    authorController.dispose();
    titleController.dispose();
    courseController.dispose();
    courseNotifier.dispose();
    authorFocusNode.dispose();
    titleFocusNode.dispose();
    urlFocusNode.dispose();
    super.dispose();
  }

  Future<void> fetchVideo()async{

    if(urlController.text.trim().isEmpty) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      getMoreDetails = false;
      loading = false;
      thumbNailIsFile = false;
      video = null;
      previewData = null;
    });
    setState(() {
      loading = true;
    });
    if(isYouTube) {
      video = await VideoUtils.getVideoFromYT(context,
          url: urlController.text.trim(),);
      setState(() {
        loading = false;
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onNotificationSent: (){
        Navigator.of(context).pop();
      },
      child: BlocListener<VideoCubit, VideoState>(
  listener: (context, state) {

      if(showingDialog){
        Navigator.pop(context);
        showingDialog = false;
      }
      if(state is AddingVideo){
        CoreUtils.showLoadingDialog(context);
        showingDialog = true;
      }
      if(state is VideoError){
        CoreUtils.showSnackBar(context,state.message);
      }
      if (state is VideoAdded) {
        CoreUtils.showSnackBar(context, 'Video added successfully');
        CoreUtils.sendNotification(
           'New ${courseNotifier.value!.title} video',
          'A new video has been added for '
              '${courseNotifier.value!.title}',
           NotificationCategory.VIDEO,
          context,
        );
      }

  },
  child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Add Video'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            Form(
              key: formKey,
              child: CoursePicker(controller: courseController,
              courseNotifier: courseNotifier,),
            ),
            const SizedBox(
              height: 20,
            ),
            InfoField(
              controller: urlController,
              hintText: 'Enter video url',
              onEditingComplete: fetchVideo,
              focusNode: urlFocusNode,
              onTapOutside: (_)=>urlFocusNode.unfocus(),
              autoFocus: true,
              keyboardType: TextInputType.url,
            ),
            ListenableBuilder(listenable: urlController, builder: (_,__){
              return Column(
                children: [
                  if(urlController.text.isNotEmpty)...[
                    const SizedBox(height: 20,),
                    ElevatedButton(onPressed: fetchVideo,
                        child: const Text('Fetch Video'),),
                  ]
                ],
              );
            },),
            if(loading && !isYouTube)
              LinkPreview(onPreviewDataFetched: (data)async{
                  setState(() {
                      thumbNailIsFile = false;
                      video = VideoModel.empty()
                      .copyWith(thumbnail: data.image?.url,
                      videoUrl: urlController.text.trim(),
                        title: data.title ?? 'No Title',
                      );
                      if(data.image?.url != null){
                        loading = false;
                      }
                      getMoreDetails = true;
                      titleController.text = data.title ?? '';
                      loading = false;
                  });
              }, previewData: previewData, text: '', width: 0,),
            if(video != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: VideoTile(video: video!,
                isFile: thumbNailIsFile,
                uploadTimePrefix: '~',
                ),
              ),
            if(getMoreDetails)
              ...[
              InfoField(controller: authorController,
              keyboardType: TextInputType.name,
              autoFocus: true,
              focusNode: authorFocusNode,
              labelText: 'Tutor name',
               onEditingComplete: (){
                setState((){
                });
                  titleFocusNode.requestFocus();
                  },
                 ),
                 InfoField(controller: titleController,
              focusNode: titleFocusNode,
              onEditingComplete: (){
              setState((){
              });
              FocusManager.instance.primaryFocus?.unfocus();
              },
              labelText: 'Video title',
            ),
              ],
            const SizedBox(height: 20),
            Center(
              child: ReactiveButton(
                disabled: video == null,
                loading: loading,
                text: 'Submit',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (courseNotifier.value == null) {
                      CoreUtils.showSnackBar(context, 'Please Pick a course');
                      return;
                    }
                    if (courseNotifier.value != null &&
                        video != null &&
                        video!.tutor == null &&
                        authorController.text.trim().isNotEmpty) {
                      video = video!.copyWith(
                        tutor: authorController.text.trim(),
                      );
                    }
                    if (video != null &&
                        video!.tutor != null && video!.title != null &&
                        video!.title!.isNotEmpty) {
                      video = video?.copyWith(
                        thumbnailIsAFile: thumbNailIsFile,
                        courseId: courseNotifier.value!.id,
                        uploadDate: DateTime.now(),
                      );
                      context.read<VideoCubit>().addVideo(video!);
                    } else {
                      CoreUtils.showSnackBar(
                        context,
                        'Please Fill all fields',
                      );
                    }
                  }
                },
              ),
            ),

          ],
        ),
      ),
),
    );
  }
}
