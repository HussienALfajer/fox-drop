// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_time_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderTimeChange
    extends AdminOrderDtoOutputOrderTimeChange {
  @override
  final int maxMin;

  factory _$AdminOrderDtoOutputOrderTimeChange([
    void Function(AdminOrderDtoOutputOrderTimeChangeBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderTimeChangeBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderTimeChange._({required this.maxMin}) : super._();
  @override
  AdminOrderDtoOutputOrderTimeChange rebuild(
    void Function(AdminOrderDtoOutputOrderTimeChangeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderTimeChangeBuilder toBuilder() =>
      AdminOrderDtoOutputOrderTimeChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderTimeChange &&
        maxMin == other.maxMin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maxMin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminOrderDtoOutputOrderTimeChange',
    )..add('maxMin', maxMin)).toString();
  }
}

class AdminOrderDtoOutputOrderTimeChangeBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderTimeChange,
          AdminOrderDtoOutputOrderTimeChangeBuilder
        > {
  _$AdminOrderDtoOutputOrderTimeChange? _$v;

  int? _maxMin;
  int? get maxMin => _$this._maxMin;
  set maxMin(int? maxMin) => _$this._maxMin = maxMin;

  AdminOrderDtoOutputOrderTimeChangeBuilder() {
    AdminOrderDtoOutputOrderTimeChange._defaults(this);
  }

  AdminOrderDtoOutputOrderTimeChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maxMin = $v.maxMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderTimeChange other) {
    _$v = other as _$AdminOrderDtoOutputOrderTimeChange;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderTimeChangeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderTimeChange build() => _build();

  _$AdminOrderDtoOutputOrderTimeChange _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderTimeChange._(
          maxMin: BuiltValueNullFieldError.checkNotNull(
            maxMin,
            r'AdminOrderDtoOutputOrderTimeChange',
            'maxMin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
