import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/utils/typedefs.dart';

abstract class ResourcesRepository{

  ResultFuture<void> addResource(Resources resources);

  ResultFuture<List<Resources>> getResources(String p);

}
