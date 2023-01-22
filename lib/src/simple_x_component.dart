part of 'index.dart';

/// A component that can be used to display something that will update
/// according to the [SimpleXController] state.
/// ```dart
/// SimpleXComponent(
///   controller: controller,
///   child: ListTile(
///     title: Text(controller.count.toString()),
///     onTap: () => controller.increment(),
///   ),
/// );
/// ```
class SimpleXComponent<T extends SimpleXController> extends SimpleXView<T> {
  const SimpleXComponent({
    required super.controller,
    this.child,
    super.groupKey,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) => child ?? const SizedBox.shrink();
}