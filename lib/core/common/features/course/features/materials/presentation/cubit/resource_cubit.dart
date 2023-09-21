import 'package:bloc/bloc.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/usecases/add_resource_use_case.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/usecases/get_resources_use_case.dart';
import 'package:equatable/equatable.dart';

part 'resource_state.dart';

class ResourceCubit extends Cubit<ResourceState> {
  ResourceCubit({
    required AddResourceUseCase addResourceUseCase,
    required GetResourceUseCase getResourceUseCase,
}) :
  _addResourceUseCase = addResourceUseCase,
  _getResourceUseCase = getResourceUseCase
  ,super(const ResourceInitial());

  final AddResourceUseCase _addResourceUseCase;
  final GetResourceUseCase _getResourceUseCase;

  Future<void> getResources(String courseId)async{

    emit(const LoadingResource());

    final result = await _getResourceUseCase(courseId);

    result.fold((l) {
      emit(ResourceError(l.errorMessage));
    }, (r) {
      emit(ResourceLoaded(r));
    });

  }

  Future<void> addResources(List<Resources> resources)async{

    emit(const AddingResource());
    for(final res in resources){

      final result = await _addResourceUseCase(res);

      result.fold((l) {
        emit(ResourceError(l.errorMessage));
        return;
      }, (_) => null,);
    }
    if(state is! ResourceError) {
      emit(const ResourceAdded());
    }

  }


}
