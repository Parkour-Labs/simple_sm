part of 'index.dart';

/// The controller for the [SimpleView] widgets.
///
/// Firstly, the controller would be bound to the [SimpleView] widget. You can
/// call the [onBound] method to do some initialization work right after the
/// binding is established.
///
/// If this is the first time that the controller has been bound to a view,
/// the [onInit] method would be called. It would be a great place to do
/// initializations that do not require the refreshment of the views here, as
/// this method would only be called once throughout the lifetime of the
/// controller.
///
/// After that, after the widget is built, the [onReady] method would be
/// called. From this point on, you can call the [refresh] method to refresh
/// the state of the views that are bound to this controller. Note that the
/// [refresh] method, by default, will update all the views that are bound to
/// this controller and that have not been disposed. Optionally, you can pass
/// in a set of group keys (which are just any types of objects to your
/// liking, but you will have to ensure that they are reliable to be used as
/// hash keys) to update only the views that belong to the specified groups.
///
/// When a view is unbound from a view, the [onUnbound] method would be called.
/// Don't
/// dispose your resources here, as the controller might be bound to another
/// view. Further, calling this method will do nothing to this controller.
/// You can write the clean up code in the [onDispose] method, which will be
/// called when the controller is disposed from every view that it is bound to.
abstract class SimpleController {
  /// If the controller has been initialized.
  bool _initialized = false;

  /// If the controller has been disposed.
  bool _disposed = false;

  /// If you want to keep this controller alive, set this to true.
  bool keepAlive = false;

  /// If a first view has been ready.
  bool _firstViewReady = false;

  /// The bindings of this controller.
  final _bindings = HashSet<_SimpleBinding>();

  /// The group bindings of this controller.
  final _groupBindings = HashMap<Object, HashSet<_SimpleBinding>>();

  /// This method will be called when the controller is being initialized. It
  /// will only be called once.
  void onInit() {}

  /// This method will initialize the controller.
  void _onInit() {
    if (!_initialized) {
      _initialized = true;
      onInit();
    }
  }

  /// This method will be fired when the stateful widget is ready for rebuild.
  /// Override this method to rebuild PlView widget.
  ///
  /// This method will be called for all the views that are bound to this
  /// controller. It will update all the views that are bound to this
  /// controller that are currently mounted.
  ///
  /// If you were to do something that needs to update the state of the view,
  /// i.e. causing the view to rebuild, you should do it in this method as
  /// opposed to doing it in [onInit].
  FutureOr<void> onReady() async {}

  @nonVirtual
  @protected
  FutureOr<void> _onReady() async {
    await onReady();
    for (final binding in _bindings) {
      if (binding.status == _SimpleBindingStatus.initialized) {
        binding.setState();
      }
    }
  }

  /// This method will be called when the first view is ready.
  FutureOr<void> onFirstReady() async {}

  @nonVirtual
  @protected
  FutureOr<void> _onFirstReady() async {
    if (!_firstViewReady) {
      _firstViewReady = true;
      await onFirstReady();
    }
  }

  /// This method will be called after this controller is bound to a view, and
  /// that view initializes its state. For example, if you are using two
  /// PlViews, then this method will be called twice, once for each view's
  /// initialization.
  void onBound() {}

  /// Binds the controller to a view.
  @protected
  void _bind(_SimpleBinding binding) {
    _bindings.add(binding);
    if (binding.groupKey != null) {
      _groupBindings.putIfAbsent(binding.groupKey!, () => HashSet<_SimpleBinding>())
        .add(binding);
    }
    binding.status = _SimpleBindingStatus.initialized;
    onBound();
  }

  /// This method will be called after this controller is unbound from a view,
  /// and that view is disposed. For example, if you are using two PlViews,
  /// then this method will be called twice, once for each view's disposal.
  void onUnbound() {}

  /// Unbinds the controller from a view.
  @nonVirtual
  @protected
  void _unbind(_SimpleBinding binding) {
    binding.status = _SimpleBindingStatus.disposed;
    _bindings.remove(binding);
    if (binding.groupKey != null) {
      _groupBindings[binding.groupKey!]?.remove(binding);
    }
    onUnbound();
    if (_initialized && !keepAlive && _bindings.isEmpty) {
      _dispose();
    }
  }

  /// This method will be called when the controller is being disposed. Note
  /// that while this method is exposed to the user, calling it directly will
  /// have no effect what so ever.
  ///
  /// By default, we will be disposing the controller when no view is bound
  /// to it. You can, however, keep the controller alive by setting [keepAlive]
  /// to true.
  void onDispose() {}

  /// This method will dispose the controller.
  void _dispose() {
    if (!_disposed) {
      _disposed = true;
      _bindings.clear();
      _groupBindings.clear();
      onDispose();
    }
  }

  /// Refreshes the state of the views that are bound to this controller.
  ///
  /// Optionally, you can provide the [groupKeys], i.e. list of group keys, to
  /// refresh the state of the views that are bound to this controller and are
  /// in the specified groups.
  void refresh([Iterable<Object>? groupKeys]) {
    if (groupKeys == null) {
      for (final binding in _bindings) {
        if (binding.status == _SimpleBindingStatus.initialized) {
          binding.setState();
        }
      }
    } else {
      for (final groupKey in groupKeys) {
        final bindings = _groupBindings[groupKey] ?? {};
        for (final binding in bindings) {
          if (binding.status == _SimpleBindingStatus.initialized) {
            binding.setState();
          }
        }
      }
    }
  }
}