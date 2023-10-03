import 'dart:io';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/utils/video_utils.dart';
import 'package:education_app/core/common/widgets/time_tile.dart';
import 'package:education_app/core/extensions/string_extensions.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';

class VideoTile extends StatelessWidget {
  const VideoTile({
  required this.video,
    this.isFile = false,
  this.tappable = false,
  this.uploadTimePrefix = 'Uploaded'
  ,super.key,});
  final Video video;
  final bool isFile;
  final bool tappable;
  final String uploadTimePrefix;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: tappable
          ? () => VideoUtils.playVideo(context, video.videoUrl):null
    ,child: Container(
        margin: const EdgeInsets.only(bottom: 20,),
        height: 108,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: 130,
                  height: 108,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: video.thumbnail == null?
                     const AssetImage(MediaRes.thumbnailPlaceholder)
                    : isFile ? FileImage(File(video.thumbnail!)):
                            NetworkImage(video.thumbnail!)
                            as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                if(tappable)
                  Container(
                    width: 130,
                    height: 108,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Center(
                      child: (video.videoUrl.checkIfYoutube)?
                      Image.asset(MediaRes.youtube,height: 40,):
                          const Icon(Icons.play_arrow_rounded,size: 40,
                          color: Colors.white,),
                    ),

                  )
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      video.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'By ${video.tutor}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colours.neutralTextColour,
                      ),
                    ),
                  ),
                  Flexible(
                    child: TimeTile(
                      video.uploadDate,
                      prefixText: uploadTimePrefix,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
