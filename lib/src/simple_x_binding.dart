part of 'index.dart';

/// The underlying data structure that represents a binding between a
/// [SimpleXController] and a [SimpleXView].
class _SimpleXBinding {
  _SimpleXBinding(this.setState, {
    this.groupKey,
    this.status = _SimpleBindingStatus.uninitialized,
});

  /// The function that is used to update the state of the stateful widget.
  final VoidCallback setState;

  /// The key of the group that this view belongs to. This way, if you want to,
  /// you can choose to update a specific group of views at one time.
  final Object? groupKey;

  /// The status of this binding.
  _SimpleBindingStatus status;
}

/// The status of a [_SimpleXBinding].
enum _SimpleBindingStatus {
  /// The binding is not yet initialized.
  uninitialized,

  /// The binding is initialized.
  initialized,

  /// The binding is ready.
  ready,

  /// The binding is disposed.
  disposed,
}
