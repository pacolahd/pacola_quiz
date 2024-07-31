import 'package:equatable/equatable.dart';

class PickedResource extends Equatable {
  const PickedResource({
    required this.path,
    required this.title,
    this.description = '',
  });

  final String path;
  final String title;
  final String description;

  PickedResource copyWith({
    String? path,
    String? title,
    String? description,
  }) {
    return PickedResource(
      path: path ?? this.path,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [path];
}
