// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlatformDtoOutputUpdateEnum _$platformDtoOutputUpdateEnum_required_ =
    const PlatformDtoOutputUpdateEnum._('required_');
const PlatformDtoOutputUpdateEnum _$platformDtoOutputUpdateEnum_suggested =
    const PlatformDtoOutputUpdateEnum._('suggested');
const PlatformDtoOutputUpdateEnum _$platformDtoOutputUpdateEnum_none =
    const PlatformDtoOutputUpdateEnum._('none');

PlatformDtoOutputUpdateEnum _$platformDtoOutputUpdateEnumValueOf(String name) {
  switch (name) {
    case 'required_':
      return _$platformDtoOutputUpdateEnum_required_;
    case 'suggested':
      return _$platformDtoOutputUpdateEnum_suggested;
    case 'none':
      return _$platformDtoOutputUpdateEnum_none;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlatformDtoOutputUpdateEnum>
_$platformDtoOutputUpdateEnumValues =
    BuiltSet<PlatformDtoOutputUpdateEnum>(const <PlatformDtoOutputUpdateEnum>[
      _$platformDtoOutputUpdateEnum_required_,
      _$platformDtoOutputUpdateEnum_suggested,
      _$platformDtoOutputUpdateEnum_none,
    ]);

Serializer<PlatformDtoOutputUpdateEnum>
_$platformDtoOutputUpdateEnumSerializer =
    _$PlatformDtoOutputUpdateEnumSerializer();

class _$PlatformDtoOutputUpdateEnumSerializer
    implements PrimitiveSerializer<PlatformDtoOutputUpdateEnum> {
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
  final Iterable<Type> types = const <Type>[PlatformDtoOutputUpdateEnum];
  @override
  final String wireName = 'PlatformDtoOutputUpdateEnum';

  @override
  Object serialize(
    Serializers serializers,
    PlatformDtoOutputUpdateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  PlatformDtoOutputUpdateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => PlatformDtoOutputUpdateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$PlatformDtoOutput extends PlatformDtoOutput {
  @override
  final PlatformDtoOutputUpdateEnum update;
  @override
  final String? updateMessage;
  @override
  final bool maintenance;
  @override
  final String? maintenanceMessage;

  factory _$PlatformDtoOutput([
    void Function(PlatformDtoOutputBuilder)? updates,
  ]) => (PlatformDtoOutputBuilder()..update(updates))._build();

  _$PlatformDtoOutput._({
    required this.update,
    this.updateMessage,
    required this.maintenance,
    this.maintenanceMessage,
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
        update == other.update &&
        updateMessage == other.updateMessage &&
        maintenance == other.maintenance &&
        maintenanceMessage == other.maintenanceMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, update.hashCode);
    _$hash = $jc(_$hash, updateMessage.hashCode);
    _$hash = $jc(_$hash, maintenance.hashCode);
    _$hash = $jc(_$hash, maintenanceMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformDtoOutput')
          ..add('update', update)
          ..add('updateMessage', updateMessage)
          ..add('maintenance', maintenance)
          ..add('maintenanceMessage', maintenanceMessage))
        .toString();
  }
}

class PlatformDtoOutputBuilder
    implements Builder<PlatformDtoOutput, PlatformDtoOutputBuilder> {
  _$PlatformDtoOutput? _$v;

  PlatformDtoOutputUpdateEnum? _update;
  PlatformDtoOutputUpdateEnum? get update => _$this._update;
  set update(PlatformDtoOutputUpdateEnum? update) => _$this._update = update;

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

  PlatformDtoOutputBuilder() {
    PlatformDtoOutput._defaults(this);
  }

  PlatformDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _update = $v.update;
      _updateMessage = $v.updateMessage;
      _maintenance = $v.maintenance;
      _maintenanceMessage = $v.maintenanceMessage;
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
    final _$result =
        _$v ??
        _$PlatformDtoOutput._(
          update: BuiltValueNullFieldError.checkNotNull(
            update,
            r'PlatformDtoOutput',
            'update',
          ),
          updateMessage: updateMessage,
          maintenance: BuiltValueNullFieldError.checkNotNull(
            maintenance,
            r'PlatformDtoOutput',
            'maintenance',
          ),
          maintenanceMessage: maintenanceMessage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
