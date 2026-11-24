// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlatformDtoOutputUpdateNeedEnum
_$platformDtoOutputUpdateNeedEnum_required_ =
    const PlatformDtoOutputUpdateNeedEnum._('required_');
const PlatformDtoOutputUpdateNeedEnum
_$platformDtoOutputUpdateNeedEnum_suggested =
    const PlatformDtoOutputUpdateNeedEnum._('suggested');
const PlatformDtoOutputUpdateNeedEnum _$platformDtoOutputUpdateNeedEnum_none =
    const PlatformDtoOutputUpdateNeedEnum._('none');

PlatformDtoOutputUpdateNeedEnum _$platformDtoOutputUpdateNeedEnumValueOf(
  String name,
) {
  switch (name) {
    case 'required_':
      return _$platformDtoOutputUpdateNeedEnum_required_;
    case 'suggested':
      return _$platformDtoOutputUpdateNeedEnum_suggested;
    case 'none':
      return _$platformDtoOutputUpdateNeedEnum_none;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlatformDtoOutputUpdateNeedEnum>
_$platformDtoOutputUpdateNeedEnumValues =
    BuiltSet<PlatformDtoOutputUpdateNeedEnum>(
      const <PlatformDtoOutputUpdateNeedEnum>[
        _$platformDtoOutputUpdateNeedEnum_required_,
        _$platformDtoOutputUpdateNeedEnum_suggested,
        _$platformDtoOutputUpdateNeedEnum_none,
      ],
    );

Serializer<PlatformDtoOutputUpdateNeedEnum>
_$platformDtoOutputUpdateNeedEnumSerializer =
    _$PlatformDtoOutputUpdateNeedEnumSerializer();

class _$PlatformDtoOutputUpdateNeedEnumSerializer
    implements PrimitiveSerializer<PlatformDtoOutputUpdateNeedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'required_': 'required',
    'suggested': 'suggested',
    'none': 'none',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'required': 'required_',
    'suggested': 'suggested',
    'none': 'none',
  };

  @override
  final Iterable<Type> types = const <Type>[PlatformDtoOutputUpdateNeedEnum];
  @override
  final String wireName = 'PlatformDtoOutputUpdateNeedEnum';

  @override
  Object serialize(
    Serializers serializers,
    PlatformDtoOutputUpdateNeedEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  PlatformDtoOutputUpdateNeedEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => PlatformDtoOutputUpdateNeedEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$PlatformDtoOutput extends PlatformDtoOutput {
  @override
  final PlatformDtoOutputUpdateNeedEnum updateNeed;
  @override
  final String? minVersion;
  @override
  final String? updateMessage;
  @override
  final bool maintenance;
  @override
  final String? maintenanceMessage;
  @override
  final DateTime? maintenanceReturnsAt;
  @override
  final PlatformDtoOutputHours? hours;

  factory _$PlatformDtoOutput([
    void Function(PlatformDtoOutputBuilder)? updates,
  ]) => (PlatformDtoOutputBuilder()..update(updates))._build();

  _$PlatformDtoOutput._({
    required this.updateNeed,
    this.minVersion,
    this.updateMessage,
    required this.maintenance,
    this.maintenanceMessage,
    this.maintenanceReturnsAt,
    this.hours,
  }) : super._();
  @override
  PlatformDtoOutput rebuild(void Function(PlatformDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformDtoOutputBuilder toBuilder() =>
      PlatformDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformDtoOutput &&
        updateNeed == other.updateNeed &&
        minVersion == other.minVersion &&
        updateMessage == other.updateMessage &&
        maintenance == other.maintenance &&
        maintenanceMessage == other.maintenanceMessage &&
        maintenanceReturnsAt == other.maintenanceReturnsAt &&
        hours == other.hours;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, updateNeed.hashCode);
    _$hash = $jc(_$hash, minVersion.hashCode);
    _$hash = $jc(_$hash, updateMessage.hashCode);
    _$hash = $jc(_$hash, maintenance.hashCode);
    _$hash = $jc(_$hash, maintenanceMessage.hashCode);
    _$hash = $jc(_$hash, maintenanceReturnsAt.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformDtoOutput')
          ..add('updateNeed', updateNeed)
          ..add('minVersion', minVersion)
          ..add('updateMessage', updateMessage)
          ..add('maintenance', maintenance)
          ..add('maintenanceMessage', maintenanceMessage)
          ..add('maintenanceReturnsAt', maintenanceReturnsAt)
          ..add('hours', hours))
        .toString();
  }
}

class PlatformDtoOutputBuilder
    implements Builder<PlatformDtoOutput, PlatformDtoOutputBuilder> {
  _$PlatformDtoOutput? _$v;

  PlatformDtoOutputUpdateNeedEnum? _updateNeed;
  PlatformDtoOutputUpdateNeedEnum? get updateNeed => _$this._updateNeed;
  set updateNeed(PlatformDtoOutputUpdateNeedEnum? updateNeed) =>
      _$this._updateNeed = updateNeed;

  String? _minVersion;
  String? get minVersion => _$this._minVersion;
  set minVersion(String? minVersion) => _$this._minVersion = minVersion;

  String? _updateMessage;
  String? get updateMessage => _$this._updateMessage;
  set updateMessage(String? updateMessage) =>
      _$this._updateMessage = updateMessage;

  bool? _maintenance;
  bool? get maintenance => _$this._maintenance;
  set maintenance(bool? maintenance) => _$this._maintenance = maintenance;

  String? _maintenanceMessage;
  String? get maintenanceMessage => _$this._maintenanceMessage;
  set maintenanceMessage(String? maintenanceMessage) =>
      _$this._maintenanceMessage = maintenanceMessage;

  DateTime? _maintenanceReturnsAt;
  DateTime? get maintenanceReturnsAt => _$this._maintenanceReturnsAt;
  set maintenanceReturnsAt(DateTime? maintenanceReturnsAt) =>
      _$this._maintenanceReturnsAt = maintenanceReturnsAt;

  PlatformDtoOutputHoursBuilder? _hours;
  PlatformDtoOutputHoursBuilder get hours =>
      _$this._hours ??= PlatformDtoOutputHoursBuilder();
  set hours(PlatformDtoOutputHoursBuilder? hours) => _$this._hours = hours;

  PlatformDtoOutputBuilder() {
    PlatformDtoOutput._defaults(this);
  }

  PlatformDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _updateNeed = $v.updateNeed;
      _minVersion = $v.minVersion;
      _updateMessage = $v.updateMessage;
      _maintenance = $v.maintenance;
      _maintenanceMessage = $v.maintenanceMessage;
      _maintenanceReturnsAt = $v.maintenanceReturnsAt;
      _hours = $v.hours?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformDtoOutput other) {
    _$v = other as _$PlatformDtoOutput;
  }

  @override
  void update(void Function(PlatformDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformDtoOutput build() => _build();

  _$PlatformDtoOutput _build() {
    _$PlatformDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$PlatformDtoOutput._(
            updateNeed: BuiltValueNullFieldError.checkNotNull(
              updateNeed,
              r'PlatformDtoOutput',
              'updateNeed',
            ),
            minVersion: minVersion,
            updateMessage: updateMessage,
            maintenance: BuiltValueNullFieldError.checkNotNull(
              maintenance,
              r'PlatformDtoOutput',
              'maintenance',
            ),
            maintenanceMessage: maintenanceMessage,
            maintenanceReturnsAt: maintenanceReturnsAt,
            hours: _hours?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'hours';
        _hours?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PlatformDtoOutput',
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
