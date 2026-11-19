// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispatch_mode_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DispatchModeDtoOutputModeEnum _$dispatchModeDtoOutputModeEnum_manual =
    const DispatchModeDtoOutputModeEnum._('manual');
const DispatchModeDtoOutputModeEnum _$dispatchModeDtoOutputModeEnum_auto =
    const DispatchModeDtoOutputModeEnum._('auto');
const DispatchModeDtoOutputModeEnum _$dispatchModeDtoOutputModeEnum_mixed =
    const DispatchModeDtoOutputModeEnum._('mixed');

DispatchModeDtoOutputModeEnum _$dispatchModeDtoOutputModeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'manual':
      return _$dispatchModeDtoOutputModeEnum_manual;
    case 'auto':
      return _$dispatchModeDtoOutputModeEnum_auto;
    case 'mixed':
      return _$dispatchModeDtoOutputModeEnum_mixed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DispatchModeDtoOutputModeEnum>
_$dispatchModeDtoOutputModeEnumValues = BuiltSet<DispatchModeDtoOutputModeEnum>(
  const <DispatchModeDtoOutputModeEnum>[
    _$dispatchModeDtoOutputModeEnum_manual,
    _$dispatchModeDtoOutputModeEnum_auto,
    _$dispatchModeDtoOutputModeEnum_mixed,
  ],
);

Serializer<DispatchModeDtoOutputModeEnum>
_$dispatchModeDtoOutputModeEnumSerializer =
    _$DispatchModeDtoOutputModeEnumSerializer();

class _$DispatchModeDtoOutputModeEnumSerializer
    implements PrimitiveSerializer<DispatchModeDtoOutputModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'manual': 'manual',
    'auto': 'auto',
    'mixed': 'mixed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'manual': 'manual',
    'auto': 'auto',
    'mixed': 'mixed',
  };

  @override
  final Iterable<Type> types = const <Type>[DispatchModeDtoOutputModeEnum];
  @override
  final String wireName = 'DispatchModeDtoOutputModeEnum';

  @override
  Object serialize(
    Serializers serializers,
    DispatchModeDtoOutputModeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  DispatchModeDtoOutputModeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => DispatchModeDtoOutputModeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$DispatchModeDtoOutput extends DispatchModeDtoOutput {
  @override
  final DispatchModeDtoOutputModeEnum mode;

  factory _$DispatchModeDtoOutput([
    void Function(DispatchModeDtoOutputBuilder)? updates,
  ]) => (DispatchModeDtoOutputBuilder()..update(updates))._build();

  _$DispatchModeDtoOutput._({required this.mode}) : super._();
  @override
  DispatchModeDtoOutput rebuild(
    void Function(DispatchModeDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DispatchModeDtoOutputBuilder toBuilder() =>
      DispatchModeDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DispatchModeDtoOutput && mode == other.mode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DispatchModeDtoOutput',
    )..add('mode', mode)).toString();
  }
}

class DispatchModeDtoOutputBuilder
    implements Builder<DispatchModeDtoOutput, DispatchModeDtoOutputBuilder> {
  _$DispatchModeDtoOutput? _$v;

  DispatchModeDtoOutputModeEnum? _mode;
  DispatchModeDtoOutputModeEnum? get mode => _$this._mode;
  set mode(DispatchModeDtoOutputModeEnum? mode) => _$this._mode = mode;

  DispatchModeDtoOutputBuilder() {
    DispatchModeDtoOutput._defaults(this);
  }

  DispatchModeDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mode = $v.mode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DispatchModeDtoOutput other) {
    _$v = other as _$DispatchModeDtoOutput;
  }

  @override
  void update(void Function(DispatchModeDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DispatchModeDtoOutput build() => _build();

  _$DispatchModeDtoOutput _build() {
    final _$result =
        _$v ??
        _$DispatchModeDtoOutput._(
          mode: BuiltValueNullFieldError.checkNotNull(
            mode,
            r'DispatchModeDtoOutput',
            'mode',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
