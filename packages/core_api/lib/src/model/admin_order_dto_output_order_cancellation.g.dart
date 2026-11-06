// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_cancellation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderCancellation
    extends AdminOrderDtoOutputOrderCancellation {
  @override
  final DateTime at;
  @override
  final String reason;

  factory _$AdminOrderDtoOutputOrderCancellation([
    void Function(AdminOrderDtoOutputOrderCancellationBuilder)? updates,
  ]) =>
      (AdminOrderDtoOutputOrderCancellationBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderCancellation._({
    required this.at,
    required this.reason,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderCancellation rebuild(
    void Function(AdminOrderDtoOutputOrderCancellationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCancellationBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCancellationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCancellation &&
        at == other.at &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderCancellation')
          ..add('at', at)
          ..add('reason', reason))
        .toString();
  }
}

class AdminOrderDtoOutputOrderCancellationBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCancellation,
          AdminOrderDtoOutputOrderCancellationBuilder
        > {
  _$AdminOrderDtoOutputOrderCancellation? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminOrderDtoOutputOrderCancellationBuilder() {
    AdminOrderDtoOutputOrderCancellation._defaults(this);
  }

  AdminOrderDtoOutputOrderCancellationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCancellation other) {
    _$v = other as _$AdminOrderDtoOutputOrderCancellation;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderCancellationBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCancellation build() => _build();

  _$AdminOrderDtoOutputOrderCancellation _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderCancellation._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminOrderDtoOutputOrderCancellation',
            'at',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminOrderDtoOutputOrderCancellation',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
