// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_preview_dto_output_payout_unit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementPreviewDtoOutputPayoutUnit
    extends AdminSettlementPreviewDtoOutputPayoutUnit {
  @override
  final String from;
  @override
  final String to;
  @override
  final String value;

  factory _$AdminSettlementPreviewDtoOutputPayoutUnit([
    void Function(AdminSettlementPreviewDtoOutputPayoutUnitBuilder)? updates,
  ]) => (AdminSettlementPreviewDtoOutputPayoutUnitBuilder()..update(updates))
      ._build();

  _$AdminSettlementPreviewDtoOutputPayoutUnit._({
    required this.from,
    required this.to,
    required this.value,
  }) : super._();
  @override
  AdminSettlementPreviewDtoOutputPayoutUnit rebuild(
    void Function(AdminSettlementPreviewDtoOutputPayoutUnitBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementPreviewDtoOutputPayoutUnitBuilder toBuilder() =>
      AdminSettlementPreviewDtoOutputPayoutUnitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementPreviewDtoOutputPayoutUnit &&
        from == other.from &&
        to == other.to &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSettlementPreviewDtoOutputPayoutUnit',
          )
          ..add('from', from)
          ..add('to', to)
          ..add('value', value))
        .toString();
  }
}

class AdminSettlementPreviewDtoOutputPayoutUnitBuilder
    implements
        Builder<
          AdminSettlementPreviewDtoOutputPayoutUnit,
          AdminSettlementPreviewDtoOutputPayoutUnitBuilder
        > {
  _$AdminSettlementPreviewDtoOutputPayoutUnit? _$v;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  AdminSettlementPreviewDtoOutputPayoutUnitBuilder() {
    AdminSettlementPreviewDtoOutputPayoutUnit._defaults(this);
  }

  AdminSettlementPreviewDtoOutputPayoutUnitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementPreviewDtoOutputPayoutUnit other) {
    _$v = other as _$AdminSettlementPreviewDtoOutputPayoutUnit;
  }

  @override
  void update(
    void Function(AdminSettlementPreviewDtoOutputPayoutUnitBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementPreviewDtoOutputPayoutUnit build() => _build();

  _$AdminSettlementPreviewDtoOutputPayoutUnit _build() {
    final _$result =
        _$v ??
        _$AdminSettlementPreviewDtoOutputPayoutUnit._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminSettlementPreviewDtoOutputPayoutUnit',
            'from',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'AdminSettlementPreviewDtoOutputPayoutUnit',
            'to',
          ),
          value: BuiltValueNullFieldError.checkNotNull(
            value,
            r'AdminSettlementPreviewDtoOutputPayoutUnit',
            'value',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
