import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/app/cubit/resource_cubit.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/app/providers/resouce_controller.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/widgets/resource_item.dart';
import 'package:education_app/core/common/views/loading_view.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CourseMaterialsView extends StatefulWidget {
  const CourseMaterialsView({
  required this.course
  ,super.key,});
  final Course course;
  static const route = '/course-materials';


  @override
  State<CourseMaterialsView> createState() => _CourseMaterialsViewState();
}

class _CourseMaterialsViewState extends State<CourseMaterialsView> {

  void getMaterials(){
    context.read<ResourceCubit>().getResources(widget.course.id);
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
        title: Text('${widget.course.title} Materials'),
        centerTitle: false,
        leading: const NestedBackButton(),
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: GradientBackground(
      image: MediaRes.documentsGradientBackground
      ,child: BlocConsumer<ResourceCubit,ResourceState>(
          listener: (context,state){
            if(state is ResourceError){
              CoreUtils.showSnackBar(context, state.message);
            }
          },
          builder: (context,state){
              if(state is LoadingResource){
                return const LoadingView();
              }else if( state is ResourceLoaded && state.materials.isNotEmpty){
                return ListView.separated(
                shrinkWrap: true
                ,itemBuilder: (context,index){
                  final resource = state.materials[index];
                  return ChangeNotifierProvider(
                  create: (_)=> sl<ResourceController>()..init(resource),
                  child: const ResourceItem(),);
                },
                  separatorBuilder: (_,index){
                  return const Divider(
                  color: Color(0xFFE6E8EC),
                  );
                }, itemCount: state.materials.length,);
              }
              return NotFoundText(text: 'No Materials Found For '
                  '${widget.course.title}',);
          },
        ),
      ),
    );
  }
}
