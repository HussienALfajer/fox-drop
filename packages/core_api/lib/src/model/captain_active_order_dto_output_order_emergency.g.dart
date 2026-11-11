// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_emergency.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderEmergency
    extends CaptainActiveOrderDtoOutputOrderEmergency {
  @override
  final DateTime at;

  factory _$CaptainActiveOrderDtoOutputOrderEmergency([
    void Function(CaptainActiveOrderDtoOutputOrderEmergencyBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderEmergencyBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderEmergency._({required this.at}) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderEmergency rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderEmergencyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderEmergencyBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderEmergencyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderEmergency && at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainActiveOrderDtoOutputOrderEmergency',
    )..add('at', at)).toString();
  }
}

class CaptainActiveOrderDtoOutputOrderEmergencyBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderEmergency,
          CaptainActiveOrderDtoOutputOrderEmergencyBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderEmergency? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainActiveOrderDtoOutputOrderEmergencyBuilder() {
    CaptainActiveOrderDtoOutputOrderEmergency._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderEmergencyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderEmergency other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderEmergency;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderEmergencyBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderEmergency build() => _build();

  _$CaptainActiveOrderDtoOutputOrderEmergency _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderEmergency._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainActiveOrderDtoOutputOrderEmergency',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
