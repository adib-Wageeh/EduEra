import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/usecases/add_resource_use_case.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/usecases/get_resources_use_case.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/cubit/resource_cubit.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AddResourceUseCaseMock extends Mock implements AddResourceUseCase{}
class GetResourceUseCaseMock extends Mock implements GetResourceUseCase{}

void main() {
  
  late AddResourceUseCase addResourceUseCase;
  late GetResourceUseCase getResourceUseCase;
  late ResourceCubit resourceCubit;
  final tResource = Resources.empty();
  const tFailure = ServerFailure(
    error: 'unknown failure',
    code: 401,
  );
  
  setUp(() {

    addResourceUseCase = AddResourceUseCaseMock();
    getResourceUseCase = GetResourceUseCaseMock();
    resourceCubit = ResourceCubit(addResourceUseCase: addResourceUseCase,
        getResourceUseCase: getResourceUseCase,);
    registerFallbackValue(tResource);
  });
  
  tearDown(() {
    resourceCubit.close();
  });

  group('add resource', () {

    blocTest<ResourceCubit,ResourceState>('add resource successfully',
      build: (){
      when(
          ()=> addResourceUseCase(any()),
      ).thenAnswer((_) async=> const Right(null));
      return resourceCubit;
    },
    act: (bloc)=> bloc.addResources([tResource]),
      expect: ()=><ResourceState>[
        const AddingResource(),
        const ResourceAdded(),
      ],
      verify: (_){
      verify(()=>addResourceUseCase(tResource)).called(1);
      verifyNoMoreInteractions(addResourceUseCase);
      },
    );

    blocTest<ResourceCubit,ResourceState>('add resource unsuccessfully'
      , build: (){

      when(
            ()=> addResourceUseCase(any()),
      ).thenAnswer((_) async=> const Left(tFailure));
      return resourceCubit;
    },
      act: (bloc)=> bloc.addResources([tResource]),
      expect: ()=><ResourceState>[
        const AddingResource(),
         ResourceError(tFailure.errorMessage),
      ],
      verify: (_){
        verify(()=>addResourceUseCase(tResource)).called(1);
        verifyNoMoreInteractions(addResourceUseCase);
      },
    );

  });

  group('get resources', () {

    blocTest<ResourceCubit,ResourceState>('get resources successfully',
      build: (){
        when(
              ()=> getResourceUseCase(any()),
        ).thenAnswer((_) async=> const Right([]));
        return resourceCubit;
      },
      act: (bloc)=> bloc.getResources(tResource.courseId),
      expect: ()=><ResourceState>[
        const LoadingResource(),
        const ResourceLoaded([]),
      ],
      verify: (_){
        verify(()=>getResourceUseCase(tResource.courseId)).called(1);
        verifyNoMoreInteractions(getResourceUseCase);
      },
    );

    blocTest<ResourceCubit,ResourceState>('get resource unsuccessfully'
      , build: (){

        when(
              ()=> getResourceUseCase(any()),
        ).thenAnswer((_) async=> const Left(tFailure));
        return resourceCubit;
      },
      act: (bloc)=> bloc.getResources(tResource.courseId),
      expect: ()=><ResourceState>[
        const LoadingResource(),
        ResourceError(tFailure.errorMessage),
      ],
      verify: (_){
        verify(()=>getResourceUseCase(tResource.courseId)).called(1);
        verifyNoMoreInteractions(getResourceUseCase);
      },
    );

  });

}

