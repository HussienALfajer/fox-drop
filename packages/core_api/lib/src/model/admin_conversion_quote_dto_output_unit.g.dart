// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_conversion_quote_dto_output_unit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminConversionQuoteDtoOutputUnit
    extends AdminConversionQuoteDtoOutputUnit {
  @override
  final String from;
  @override
  final String to;
  @override
  final String value;

  factory _$AdminConversionQuoteDtoOutputUnit([
    void Function(AdminConversionQuoteDtoOutputUnitBuilder)? updates,
  ]) => (AdminConversionQuoteDtoOutputUnitBuilder()..update(updates))._build();

  _$AdminConversionQuoteDtoOutputUnit._({
    required this.from,
    required this.to,
    required this.value,
  }) : super._();
  @override
  AdminConversionQuoteDtoOutputUnit rebuild(
    void Function(AdminConversionQuoteDtoOutputUnitBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminConversionQuoteDtoOutputUnitBuilder toBuilder() =>
      AdminConversionQuoteDtoOutputUnitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminConversionQuoteDtoOutputUnit &&
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
    return (newBuiltValueToStringHelper(r'AdminConversionQuoteDtoOutputUnit')
          ..add('from', from)
          ..add('to', to)
          ..add('value', value))
        .toString();
  }
}

class AdminConversionQuoteDtoOutputUnitBuilder
    implements
        Builder<
          AdminConversionQuoteDtoOutputUnit,
          AdminConversionQuoteDtoOutputUnitBuilder
        > {
  _$AdminConversionQuoteDtoOutputUnit? _$v;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  AdminConversionQuoteDtoOutputUnitBuilder() {
    AdminConversionQuoteDtoOutputUnit._defaults(this);
  }

  AdminConversionQuoteDtoOutputUnitBuilder get _$this {
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
  void replace(AdminConversionQuoteDtoOutputUnit other) {
    _$v = other as _$AdminConversionQuoteDtoOutputUnit;
  }

  @override
  void update(
    void Function(AdminConversionQuoteDtoOutputUnitBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminConversionQuoteDtoOutputUnit build() => _build();

  _$AdminConversionQuoteDtoOutputUnit _build() {
    final _$result =
        _$v ??
        _$AdminConversionQuoteDtoOutputUnit._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminConversionQuoteDtoOutputUnit',
            'from',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'AdminConversionQuoteDtoOutputUnit',
            'to',
          ),
          value: BuiltValueNullFieldError.checkNotNull(
            value,
            r'AdminConversionQuoteDtoOutputUnit',
            'value',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
