import 'package:equatable/equatable.dart';

class PickedMaterial extends Equatable {
  const PickedMaterial({
    required this.path,
    required this.title,
    this.description = '',
  });

  final String path;
  final String title;
  final String description;

  PickedMaterial copyWith({
    String? path,
    String? title,
    String? description,
  }) {
    return PickedMaterial(
      path: path ?? this.path,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [path];
}
