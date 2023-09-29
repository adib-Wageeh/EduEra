import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursePicker extends StatefulWidget {
  const CoursePicker({
    required this.controller,
    required this.courseNotifier
    , super.key,});

  final TextEditingController controller;
  final ValueNotifier<Course?> courseNotifier;

  @override
  State<CoursePicker> createState() => _CoursePickerState();
}

class _CoursePickerState extends State<CoursePicker> {

  void getCourses() {
    context.read<CourseCubit>().getCourses();
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (context, state) {
        if(state is CourseError){
          CoreUtils.showSnackBar(context, state.message);
          Navigator.pop(context);
        }else{
          if(state is CoursesLoaded && state.courses.isEmpty){
            CoreUtils.showSnackBar(context, 'there is no courses to be added',);
            Navigator.pop(context);

          }
        }
      },
      builder: (context, state) {
        return TextFormField(
          readOnly: true,
          controller: widget.controller,
          decoration: InputDecoration(
              labelText: 'Pick Course',
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colours.primaryColour),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              suffixIcon: (state is CoursesLoaded)?
              PopupMenuButton<String>(
              offset: const Offset(0, 50),
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )
              ,itemBuilder: (context){
                return state.courses.map((e){
                  return PopupMenuItem<String>(
                      value: e.id,
                      onTap: (){
                        widget.controller.text = e.title;
                        widget.courseNotifier.value = e;
                      },
                      child: Text(e.title),
                  );
                }).toList();
              },
              icon: const Icon(Icons.arrow_drop_down),
              ):
                  const Padding(padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Text(
                    'loading...',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  ),

          ),
          validator: (text){
            if( text == null || text.isEmpty ){
              return 'Please pick a course';
            }
            return null;
          },
        );
      },
    );
  }
}
