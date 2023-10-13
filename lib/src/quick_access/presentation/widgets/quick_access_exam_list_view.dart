import 'package:education_app/core/common/features/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/views/user_exam_result_view.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_exam_tile.dart';
import 'package:education_app/src/quick_access/presentation/widgets/shimmers/exam_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickAccessExamListView extends StatefulWidget {
  const QuickAccessExamListView({super.key});

  @override
  State<QuickAccessExamListView> createState() => _QuickAccessExamListViewState();
}

class _QuickAccessExamListViewState extends State<QuickAccessExamListView> {

  @override
  void initState() {
    super.initState();
    context.read<ExamCubit>().getUserExams();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit,ExamState>
      (builder: (context,state){
      if(state is GettingUserExams){
        return const ExamShimmer();
      }else if(state is UserExamsLoaded && state.exams.isEmpty){
        return const NotFoundText(
          text: 'No Exams Found',
        );
      }else if(state is UserExamsLoaded){
        return Expanded(
          child: ListView.separated(
            separatorBuilder: (context,index){
              return const Divider(
                color: Colors.grey,
                thickness: 0.5,
                indent: 50,
                endIndent: 50,
              );
            },
            shrinkWrap: true,
            itemCount: state.exams.length,
            itemBuilder: (context,index){
              return QuickAccessExamTile(
                onTab: (){
                  Navigator.pushNamed(context,
                    UserExamResultView.route,
                    arguments: state.exams[index],
                  );
                }
                ,exam: state.exams[index],);
            },),
        );
      }else{
        return const SizedBox.shrink();
      }
    },);
  }
}
