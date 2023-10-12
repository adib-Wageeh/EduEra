import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/views/course_materials_view.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/views/course_videos_view.dart';
import 'package:education_app/core/common/widgets/course_info_tile.dart';
import 'package:education_app/core/common/widgets/expandable_text.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:flutter/material.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({
  required this.course,super.key,});
  static const route = '/course-details';
  final Course course;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const NestedBackButton(),
        title: Text(course.title),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: GradientBackground(image: MediaRes.homeGradientBackground,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SizedBox(
                height: context.height*0.3,
                child: CoreUtils.imageType(course.image!,
                dimensions: context.height*0.25,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                  const SizedBox(height: 10,),
                  if(course.description != null)
                    ExpandableText(context,text: course.description!,),
                    if( course.numberOfMaterials > 0
                        || course.numberOfVideos > 0
                    || course.numberOfExams > 0)
                      ...[
                        const SizedBox(height: 20,),
                        const Text(
                          'Subject Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if(course.numberOfVideos > 0)
                          ...[
                            const SizedBox(height: 10,),
                            CourseInfoTile(
                              title: '${course.numberOfVideos} Video(s)',
                              subTitle: 'watch our tutorial videos for ${
                              course.title
                              }',
                              onPressed: () => Navigator.of(context).pushNamed(
                                CourseVideosView.route,
                                arguments: course,
                              ),
                              image: MediaRes.courseInfoVideo,
                            ),
                          ],
                        if (course.numberOfExams > 0) ...[
                          const SizedBox(height: 10),
                          CourseInfoTile(
                            image: MediaRes.courseInfoExam,
                            title: '${course.numberOfExams} Exam(s)',
                            subTitle: 'Take our exams for ${course.title}',
                            onPressed: () => Navigator.of(context).pushNamed(
                              '/unknown-route',
                              arguments: course,
                            ),
                          ),
                        ],
                        if (course.numberOfMaterials > 0) ...[
                          const SizedBox(height: 10),
                          CourseInfoTile(
                            image: MediaRes.courseInfoMaterial,
                            title: '${course.numberOfMaterials} Material(s)',
                            subTitle: 'Access to '
                                '${course.numberOfMaterials} materials '
                                'for ${course.title}',
                            onPressed: () => Navigator.of(context).pushNamed(
                              CourseMaterialsView.route,
                              arguments: course,
                            ),
                          ),
                        ],

                      ],

                ],
              ),
            ],
          ),),),
    );
  }
}
