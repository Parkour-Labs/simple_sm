part of 'index.dart';

/// A [SimpleView] is a base view from which you can extend to create your own
/// views that can be used alongside a subclass [T] of a [SimpleController].
abstract class SimpleView<T extends SimpleController> extends StatefulWidget {
  const SimpleView({
    super.key,
    required this.controller,
    this.groupKey,
  });

  /// The controller that controls this view.
  final T controller;

  /// The key of the group that this view belongs to, so that you can choose
  /// to update a specific group of views at one time.
  final Object? groupKey;

  /// The builder that builds the view.
  Widget build(BuildContext context);

  @override
  State<SimpleView<T>> createState() => _SimpleViewState<T>();
}

class _SimpleViewState<T extends SimpleController> extends State<SimpleView<T>> {
  _SimpleBinding? _binding;

  @override
  void initState() {
    super.initState();
    _binding = _SimpleBinding(
      () => setState(() {}),
      status: _SimpleBindingStatus.uninitialized,
      groupKey: widget.groupKey,
    );
    widget.controller._bind(_binding!);
    widget.controller._onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await widget.controller._onFirstReady();
      await widget.controller._onReady();
    });
  }

  @override
  void dispose() {
    widget.controller._unbind(_binding!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
}
