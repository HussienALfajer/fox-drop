// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_late_cancels.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputLateCancels
    extends AdminCustomerDtoOutputLateCancels {
  @override
  final int inWindow;
  @override
  final int total;
  @override
  final int limit;
  @override
  final int windowDays;
  @override
  final AdminCustomerDtoOutputLateCancelsCleared? cleared;

  factory _$AdminCustomerDtoOutputLateCancels([
    void Function(AdminCustomerDtoOutputLateCancelsBuilder)? updates,
  ]) => (AdminCustomerDtoOutputLateCancelsBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputLateCancels._({
    required this.inWindow,
    required this.total,
    required this.limit,
    required this.windowDays,
    this.cleared,
  }) : super._();
  @override
  AdminCustomerDtoOutputLateCancels rebuild(
    void Function(AdminCustomerDtoOutputLateCancelsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputLateCancelsBuilder toBuilder() =>
      AdminCustomerDtoOutputLateCancelsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputLateCancels &&
        inWindow == other.inWindow &&
        total == other.total &&
        limit == other.limit &&
        windowDays == other.windowDays &&
        cleared == other.cleared;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, inWindow.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, windowDays.hashCode);
    _$hash = $jc(_$hash, cleared.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputLateCancels')
          ..add('inWindow', inWindow)
          ..add('total', total)
          ..add('limit', limit)
          ..add('windowDays', windowDays)
          ..add('cleared', cleared))
        .toString();
  }
}

class AdminCustomerDtoOutputLateCancelsBuilder
    implements
        Builder<
          AdminCustomerDtoOutputLateCancels,
          AdminCustomerDtoOutputLateCancelsBuilder
        > {
  _$AdminCustomerDtoOutputLateCancels? _$v;

  int? _inWindow;
  int? get inWindow => _$this._inWindow;
  set inWindow(int? inWindow) => _$this._inWindow = inWindow;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  int? _windowDays;
  int? get windowDays => _$this._windowDays;
  set windowDays(int? windowDays) => _$this._windowDays = windowDays;

  AdminCustomerDtoOutputLateCancelsClearedBuilder? _cleared;
  AdminCustomerDtoOutputLateCancelsClearedBuilder get cleared =>
      _$this._cleared ??= AdminCustomerDtoOutputLateCancelsClearedBuilder();
  set cleared(AdminCustomerDtoOutputLateCancelsClearedBuilder? cleared) =>
      _$this._cleared = cleared;

  AdminCustomerDtoOutputLateCancelsBuilder() {
    AdminCustomerDtoOutputLateCancels._defaults(this);
  }

  AdminCustomerDtoOutputLateCancelsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _inWindow = $v.inWindow;
      _total = $v.total;
      _limit = $v.limit;
      _windowDays = $v.windowDays;
      _cleared = $v.cleared?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputLateCancels other) {
    _$v = other as _$AdminCustomerDtoOutputLateCancels;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputLateCancelsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputLateCancels build() => _build();

  _$AdminCustomerDtoOutputLateCancels _build() {
    _$AdminCustomerDtoOutputLateCancels _$result;
    try {
      _$result =
          _$v ??
          _$AdminCustomerDtoOutputLateCancels._(
            inWindow: BuiltValueNullFieldError.checkNotNull(
              inWindow,
              r'AdminCustomerDtoOutputLateCancels',
              'inWindow',
            ),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'AdminCustomerDtoOutputLateCancels',
              'total',
            ),
            limit: BuiltValueNullFieldError.checkNotNull(
              limit,
              r'AdminCustomerDtoOutputLateCancels',
              'limit',
            ),
            windowDays: BuiltValueNullFieldError.checkNotNull(
              windowDays,
              r'AdminCustomerDtoOutputLateCancels',
              'windowDays',
            ),
            cleared: _cleared?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cleared';
        _cleared?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCustomerDtoOutputLateCancels',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
