import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/repository/materials_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class AddResourceUseCase extends UseCaseWithParams<void,Resources>{

  const AddResourceUseCase({required this.repository});
  final ResourcesRepository repository;

  @override
  ResultFuture<void> call(Resources p) async{
    return repository.addResource(p);
  }



}
