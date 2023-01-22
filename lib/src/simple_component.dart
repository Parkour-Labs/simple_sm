part of 'index.dart';

/// A component that can be used to display something that will update
/// according to the [PlController] state.
/// ```dart
/// PlComponent(
///   controller: controller,
///   child: ListTile(
///     title: Text(controller.count.toString()),
///     onTap: () => controller.increment(),
///   ),
/// );
/// ```
class PlComponent<T extends PlController> extends PlView<T> {
  const PlComponent({
    required super.controller,
    this.child,
    super.groupKey,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) => child ?? const SizedBox.shrink();
}