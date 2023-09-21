import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/repository/materials_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class GetResourceUseCase extends UseCaseWithParams<List<Resources>,String>{

  const GetResourceUseCase({required this.repository});
  final ResourcesRepository repository;

  @override
  ResultFuture<List<Resources>> call(String p) async{
    return repository.getResources(p);
  }



}