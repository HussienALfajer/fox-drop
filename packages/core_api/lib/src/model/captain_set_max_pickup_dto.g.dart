// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_set_max_pickup_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainSetMaxPickupDto extends CaptainSetMaxPickupDto {
  @override
  final String? amount;

  factory _$CaptainSetMaxPickupDto([
    void Function(CaptainSetMaxPickupDtoBuilder)? updates,
  ]) => (CaptainSetMaxPickupDtoBuilder()..update(updates))._build();

  _$CaptainSetMaxPickupDto._({this.amount}) : super._();
  @override
  CaptainSetMaxPickupDto rebuild(
    void Function(CaptainSetMaxPickupDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainSetMaxPickupDtoBuilder toBuilder() =>
      CaptainSetMaxPickupDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainSetMaxPickupDto && amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainSetMaxPickupDto',
    )..add('amount', amount)).toString();
  }
}

class CaptainSetMaxPickupDtoBuilder
    implements Builder<CaptainSetMaxPickupDto, CaptainSetMaxPickupDtoBuilder> {
  _$CaptainSetMaxPickupDto? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  CaptainSetMaxPickupDtoBuilder() {
    CaptainSetMaxPickupDto._defaults(this);
  }

  CaptainSetMaxPickupDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainSetMaxPickupDto other) {
    _$v = other as _$CaptainSetMaxPickupDto;
  }

  @override
  void update(void Function(CaptainSetMaxPickupDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainSetMaxPickupDto build() => _build();

  _$CaptainSetMaxPickupDto _build() {
    final _$result = _$v ?? _$CaptainSetMaxPickupDto._(amount: amount);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
