import 'package:education_app/core/common/features/course/features/videos/data/models/video_model.dart';
import 'package:education_app/core/extensions/string_extensions.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_metadata/youtube_metadata.dart';

class VideoUtils{

  const VideoUtils._();

  static Future<VideoModel?> getVideoFromYT(BuildContext context,
    {required String url,})async{
    void showSnack(String message)=>CoreUtils.showSnackBar(context, message,);
    try {
      final metaData = await YoutubeMetaData.getData(url);
      
      if(metaData.title == null || metaData.authorName == null ||
      metaData.thumbnailUrl == null){
        final missing = <String>[];
        if(metaData.title == null) missing.add('title');
        if(metaData.thumbnailUrl == null) missing.add('thumbnailUrl');
        if(metaData.authorName == null) missing.add('authorName');

        final message = "Couldn't get video data please try again later\n"
            'missing data are ${missing.fold
          ('', (previousValue, element) => '$previousValue$element, ',)}';
        showSnack(message);
        return null;
      }
      return VideoModel.empty()
          .copyWith(
        title: metaData.title,
        tutor: metaData.authorName,
        thumbnail: metaData.thumbnailUrl,
        videoUrl: url,
      );
    }catch(e){
      showSnack('PLEASE TRY AGAIN \n$e');
      return null;

    }

  }

  static Future<void> playVideo(BuildContext context,String videoUrl)async{

      if(videoUrl.checkIfYoutube){

        if(!await launchUrl(Uri.parse(videoUrl),mode:
        LaunchMode.externalApplication,)){
          CoreUtils.showSnackBar(context, "couldn't launch $videoUrl");
        }

      }else{
        // context.pushTab(VideoPlayerView());
      }

  }

}
