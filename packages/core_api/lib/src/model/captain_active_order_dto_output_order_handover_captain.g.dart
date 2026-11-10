// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_handover_captain.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderHandoverCaptain
    extends CaptainActiveOrderDtoOutputOrderHandoverCaptain {
  @override
  final String name;
  @override
  final String? phone;
  @override
  final CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation? location;

  factory _$CaptainActiveOrderDtoOutputOrderHandoverCaptain([
    void Function(CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder()
            ..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderHandoverCaptain._({
    required this.name,
    this.phone,
    this.location,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderHandoverCaptain rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderHandoverCaptain &&
        name == other.name &&
        phone == other.phone &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderHandoverCaptain',
          )
          ..add('name', name)
          ..add('phone', phone)
          ..add('location', location))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderHandoverCaptain,
          CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderHandoverCaptain? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder? _location;
  CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder get location =>
      _$this._location ??=
          CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder();
  set location(
    CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder? location,
  ) => _$this._location = location;

  CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder() {
    CaptainActiveOrderDtoOutputOrderHandoverCaptain._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _phone = $v.phone;
      _location = $v.location?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderHandoverCaptain other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderHandoverCaptain;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderHandoverCaptain build() => _build();

  _$CaptainActiveOrderDtoOutputOrderHandoverCaptain _build() {
    _$CaptainActiveOrderDtoOutputOrderHandoverCaptain _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputOrderHandoverCaptain._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CaptainActiveOrderDtoOutputOrderHandoverCaptain',
              'name',
            ),
            phone: phone,
            location: _location?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        _location?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutputOrderHandoverCaptain',
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
