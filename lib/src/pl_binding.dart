part of 'index.dart';

/// The underlying data structure that represents a binding between a
/// [PlController] and a [PlView].
class _PlBinding {
  _PlBinding(this.setState, {
    this.groupKey,
    this.status = _PlBindingStatus.uninitialized,
});

  /// The function that is used to update the state of the stateful widget.
  final VoidCallback setState;

  /// The key of the group that this view belongs to. This way, if you want to,
  /// you can choose to update a specific group of views at one time.
  final Object? groupKey;

  /// The status of this binding.
  _PlBindingStatus status;
}

/// The status of a [_PlBinding].
enum _PlBindingStatus {
  /// The binding is not yet initialized.
  uninitialized,

  /// The binding is initialized.
  initialized,

  /// The binding is disposed.
  disposed,
}
