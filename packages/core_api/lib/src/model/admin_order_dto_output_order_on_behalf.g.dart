// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_on_behalf.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderOnBehalf
    extends AdminOrderDtoOutputOrderOnBehalf {
  @override
  final AdminOrderDtoOutputOrderOnBehalfPrepTime prepTime;
  @override
  final BuiltList<AdminOrderDtoOutputOrderCancelChoicesReasonsInner>
  rejectionReasons;
  @override
  final BuiltList<int> busyExtraOptionsMin;

  factory _$AdminOrderDtoOutputOrderOnBehalf([
    void Function(AdminOrderDtoOutputOrderOnBehalfBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderOnBehalfBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderOnBehalf._({
    required this.prepTime,
    required this.rejectionReasons,
    required this.busyExtraOptionsMin,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderOnBehalf rebuild(
    void Function(AdminOrderDtoOutputOrderOnBehalfBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderOnBehalfBuilder toBuilder() =>
      AdminOrderDtoOutputOrderOnBehalfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderOnBehalf &&
        prepTime == other.prepTime &&
        rejectionReasons == other.rejectionReasons &&
        busyExtraOptionsMin == other.busyExtraOptionsMin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, prepTime.hashCode);
    _$hash = $jc(_$hash, rejectionReasons.hashCode);
    _$hash = $jc(_$hash, busyExtraOptionsMin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderOnBehalf')
          ..add('prepTime', prepTime)
          ..add('rejectionReasons', rejectionReasons)
          ..add('busyExtraOptionsMin', busyExtraOptionsMin))
        .toString();
  }
}

class AdminOrderDtoOutputOrderOnBehalfBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderOnBehalf,
          AdminOrderDtoOutputOrderOnBehalfBuilder
        > {
  _$AdminOrderDtoOutputOrderOnBehalf? _$v;

  AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder? _prepTime;
  AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder get prepTime =>
      _$this._prepTime ??= AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder();
  set prepTime(AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder? prepTime) =>
      _$this._prepTime = prepTime;

  ListBuilder<AdminOrderDtoOutputOrderCancelChoicesReasonsInner>?
  _rejectionReasons;
  ListBuilder<AdminOrderDtoOutputOrderCancelChoicesReasonsInner>
  get rejectionReasons => _$this._rejectionReasons ??=
      ListBuilder<AdminOrderDtoOutputOrderCancelChoicesReasonsInner>();
  set rejectionReasons(
    ListBuilder<AdminOrderDtoOutputOrderCancelChoicesReasonsInner>?
    rejectionReasons,
  ) => _$this._rejectionReasons = rejectionReasons;

  ListBuilder<int>? _busyExtraOptionsMin;
  ListBuilder<int> get busyExtraOptionsMin =>
      _$this._busyExtraOptionsMin ??= ListBuilder<int>();
  set busyExtraOptionsMin(ListBuilder<int>? busyExtraOptionsMin) =>
      _$this._busyExtraOptionsMin = busyExtraOptionsMin;

  AdminOrderDtoOutputOrderOnBehalfBuilder() {
    AdminOrderDtoOutputOrderOnBehalf._defaults(this);
  }

  AdminOrderDtoOutputOrderOnBehalfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _prepTime = $v.prepTime.toBuilder();
      _rejectionReasons = $v.rejectionReasons.toBuilder();
      _busyExtraOptionsMin = $v.busyExtraOptionsMin.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderOnBehalf other) {
    _$v = other as _$AdminOrderDtoOutputOrderOnBehalf;
  }

  @override
  void update(void Function(AdminOrderDtoOutputOrderOnBehalfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderOnBehalf build() => _build();

  _$AdminOrderDtoOutputOrderOnBehalf _build() {
    _$AdminOrderDtoOutputOrderOnBehalf _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderOnBehalf._(
            prepTime: prepTime.build(),
            rejectionReasons: rejectionReasons.build(),
            busyExtraOptionsMin: busyExtraOptionsMin.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'prepTime';
        prepTime.build();
        _$failedField = 'rejectionReasons';
        rejectionReasons.build();
        _$failedField = 'busyExtraOptionsMin';
        busyExtraOptionsMin.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderOnBehalf',
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
