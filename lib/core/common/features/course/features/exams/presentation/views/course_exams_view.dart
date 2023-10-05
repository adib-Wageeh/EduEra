import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/views/exam_details_view.dart';
import 'package:education_app/core/common/views/loading_view.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/extensions/int_extensions.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseExamsView extends StatefulWidget {
  const CourseExamsView({
  required this.course
  ,super.key,});
  final Course course;
  static const route = '/course-exams';

  @override
  State<CourseExamsView> createState() => _CourseExamsViewState();
}

class _CourseExamsViewState extends State<CourseExamsView> {

  void getMaterials(){
    context.read<ExamCubit>().getExams(widget.course.id);
  }

  @override
  void initState() {
    super.initState();
    getMaterials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('${widget.course.title} Exams'),
    centerTitle: false,
    leading: const NestedBackButton(),
    ),
    backgroundColor: Colors.white,
    extendBodyBehindAppBar: true,
    body: BlocConsumer<ExamCubit,ExamState>(
    listener: (context,state){
    if(state is ExamError){
    CoreUtils.showSnackBar(context, state.message);
    }
    },
      builder: (context,state){
        if(state is GettingExams){
          return const LoadingView();
        }else if( state is ExamsLoaded && state.exams.isNotEmpty){
          return SafeArea(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context,index){
                    final exam = state.exams[index];
                    return Stack(
                      children: [
                          Card(
                            margin: const EdgeInsets.all(4)
                             .copyWith(bottom: 30),
                            child: Padding(padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exam.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Text(exam.description,),
                                const SizedBox(height: 10,),
                                Text(exam.timeLimit.displayDurationLong,
                                style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                MediaQuery.of(context).size.width*0.2,
                                vertical: 10,
                              ),
                              child: ElevatedButton(onPressed: (){
                                Navigator.pushNamed(context,
                                  ExamDetailsView.route,
                                arguments: exam,);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                                child: const Text('Take exam'),
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
            );

        }
        return NotFoundText(text: 'No Exams Found For '
            '${widget.course.title}',);
      },
    ),
    );
  }
}
