import 'dart:io';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/utils/video_utils.dart';
import 'package:education_app/core/common/widgets/time_tile.dart';
import 'package:education_app/core/extensions/string_extensions.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        height: 108.h,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: 130.w,
                  height: 108.h,
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
                    width: 130.w,
                    height: 108.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Center(
                      child: (video.videoUrl.checkIfYoutube)?
                      Image.asset(MediaRes.youtube,height: 40.h,):
                      Icon(Icons.play_arrow_rounded,size: 40.sp,
                          color: Colors.white,),
                    ),

                  ),
              ],
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      video.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'By ${video.tutor}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(
                        fontSize: 12.sp,
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
