// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_timeline_inner_time_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderTimelineInnerTimeChange
    extends AdminOrderDtoOutputOrderTimelineInnerTimeChange {
  @override
  final int addMin;
  @override
  final DateTime promisedAt;

  factory _$AdminOrderDtoOutputOrderTimelineInnerTimeChange([
    void Function(AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderTimelineInnerTimeChange._({
    required this.addMin,
    required this.promisedAt,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderTimelineInnerTimeChange rebuild(
    void Function(AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder toBuilder() =>
      AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderTimelineInnerTimeChange &&
        addMin == other.addMin &&
        promisedAt == other.promisedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, addMin.hashCode);
    _$hash = $jc(_$hash, promisedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderTimelineInnerTimeChange',
          )
          ..add('addMin', addMin)
          ..add('promisedAt', promisedAt))
        .toString();
  }
}

class AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderTimelineInnerTimeChange,
          AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder
        > {
  _$AdminOrderDtoOutputOrderTimelineInnerTimeChange? _$v;

  int? _addMin;
  int? get addMin => _$this._addMin;
  set addMin(int? addMin) => _$this._addMin = addMin;

  DateTime? _promisedAt;
  DateTime? get promisedAt => _$this._promisedAt;
  set promisedAt(DateTime? promisedAt) => _$this._promisedAt = promisedAt;

  AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder() {
    AdminOrderDtoOutputOrderTimelineInnerTimeChange._defaults(this);
  }

  AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _addMin = $v.addMin;
      _promisedAt = $v.promisedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderTimelineInnerTimeChange other) {
    _$v = other as _$AdminOrderDtoOutputOrderTimelineInnerTimeChange;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderTimelineInnerTimeChangeBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderTimelineInnerTimeChange build() => _build();

  _$AdminOrderDtoOutputOrderTimelineInnerTimeChange _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderTimelineInnerTimeChange._(
          addMin: BuiltValueNullFieldError.checkNotNull(
            addMin,
            r'AdminOrderDtoOutputOrderTimelineInnerTimeChange',
            'addMin',
          ),
          promisedAt: BuiltValueNullFieldError.checkNotNull(
            promisedAt,
            r'AdminOrderDtoOutputOrderTimelineInnerTimeChange',
            'promisedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
