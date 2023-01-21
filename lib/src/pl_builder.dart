part of 'index.dart';

/// A builder that builds a view based on the controller.
///
/// To use this, first, create a new controller.
/// ```dart
/// class MyController extends PlController {
///   int count = 0;
///   void increment() {
///     count++;
///     refresh();
///   }
/// }
/// ```
/// Then, pass this in to a builder:
/// ```dart
/// PlBuilder&lt;MyController&gt;(
///   controller: MyController(),
///   builder: (controller) {
///     return TextButton(
///       onPressed: controller.increment,
///       child: Text(controller.count.toString()),
///     );
///   },
/// }
/// ```
/// Then you are done!
class PlBuilder<T extends PlController> extends PlView<T> {
  const PlBuilder({
    Key? key,
    required T controller,
    required this.builder,
    Object? groupKey,
  }) : super(
          key: key,
          controller: controller,
          groupKey: groupKey,
        );

  /// The builder for building the view.
  ///
  /// [T] is the controller that controls this view. It is just the same one
  /// that's passed in from the PlBuilder's constructor. We put the
  /// controller here just so that it would be more save, i.e. guaranteeing
  /// that the controller is the same one.
  final Widget Function(BuildContext context, T controller) builder;

  @override
  Widget build(BuildContext context) => builder(context, controller);
}
