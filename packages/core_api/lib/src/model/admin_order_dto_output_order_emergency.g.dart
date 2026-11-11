// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_emergency.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderEmergency
    extends AdminOrderDtoOutputOrderEmergency {
  @override
  final String captainId;
  @override
  final AdminOrderDtoOutputOrderEmergencyLocation? location;
  @override
  final DateTime at;

  factory _$AdminOrderDtoOutputOrderEmergency([
    void Function(AdminOrderDtoOutputOrderEmergencyBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderEmergencyBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderEmergency._({
    required this.captainId,
    this.location,
    required this.at,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderEmergency rebuild(
    void Function(AdminOrderDtoOutputOrderEmergencyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderEmergencyBuilder toBuilder() =>
      AdminOrderDtoOutputOrderEmergencyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderEmergency &&
        captainId == other.captainId &&
        location == other.location &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderEmergency')
          ..add('captainId', captainId)
          ..add('location', location)
          ..add('at', at))
        .toString();
  }
}

class AdminOrderDtoOutputOrderEmergencyBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderEmergency,
          AdminOrderDtoOutputOrderEmergencyBuilder
        > {
  _$AdminOrderDtoOutputOrderEmergency? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  AdminOrderDtoOutputOrderEmergencyLocationBuilder? _location;
  AdminOrderDtoOutputOrderEmergencyLocationBuilder get location =>
      _$this._location ??= AdminOrderDtoOutputOrderEmergencyLocationBuilder();
  set location(AdminOrderDtoOutputOrderEmergencyLocationBuilder? location) =>
      _$this._location = location;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminOrderDtoOutputOrderEmergencyBuilder() {
    AdminOrderDtoOutputOrderEmergency._defaults(this);
  }

  AdminOrderDtoOutputOrderEmergencyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _location = $v.location?.toBuilder();
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderEmergency other) {
    _$v = other as _$AdminOrderDtoOutputOrderEmergency;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderEmergencyBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderEmergency build() => _build();

  _$AdminOrderDtoOutputOrderEmergency _build() {
    _$AdminOrderDtoOutputOrderEmergency _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderEmergency._(
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminOrderDtoOutputOrderEmergency',
              'captainId',
            ),
            location: _location?.build(),
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminOrderDtoOutputOrderEmergency',
              'at',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        _location?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderEmergency',
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
