part of 'index.dart';

/// A [PlView] is a base view from which you can extend to create your own
/// views that can be used alongside a subclass [T] of a [PlController].
abstract class PlView<T extends PlController> extends StatefulWidget {
  const PlView({
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
  State<PlView<T>> createState() => _PlViewState<T>();
}

class _PlViewState<T extends PlController> extends State<PlView<T>> {
  _PlBinding? _binding;

  @override
  void initState() {
    super.initState();
    _binding = _PlBinding(
      () => setState(() {}),
      status: _PlBindingStatus.uninitialized,
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
