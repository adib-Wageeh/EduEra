part of 'resource_cubit.dart';

abstract class ResourceState extends Equatable {
  const ResourceState();

  @override
  List<Object> get props => [];
}

class ResourceInitial extends ResourceState {
  const ResourceInitial();
}

class AddingResource extends ResourceState {
  const AddingResource();
}

class LoadingResource extends ResourceState {
  const LoadingResource();
}

class ResourceAdded extends ResourceState {
  const ResourceAdded();
}

class ResourceLoaded extends ResourceState {
  const ResourceLoaded(this.materials);

  final List<Resources> materials;

  @override
  List<Object> get props => [materials];
}

class ResourceError extends ResourceState {
  const ResourceError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}