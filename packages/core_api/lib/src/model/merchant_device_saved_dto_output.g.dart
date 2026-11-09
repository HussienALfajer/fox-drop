// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_device_saved_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantDeviceSavedDtoOutputStatusEnum
_$merchantDeviceSavedDtoOutputStatusEnum_saved =
    const MerchantDeviceSavedDtoOutputStatusEnum._('saved');

MerchantDeviceSavedDtoOutputStatusEnum
_$merchantDeviceSavedDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'saved':
      return _$merchantDeviceSavedDtoOutputStatusEnum_saved;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantDeviceSavedDtoOutputStatusEnum>
_$merchantDeviceSavedDtoOutputStatusEnumValues =
    BuiltSet<MerchantDeviceSavedDtoOutputStatusEnum>(
      const <MerchantDeviceSavedDtoOutputStatusEnum>[
        _$merchantDeviceSavedDtoOutputStatusEnum_saved,
      ],
    );

Serializer<MerchantDeviceSavedDtoOutputStatusEnum>
_$merchantDeviceSavedDtoOutputStatusEnumSerializer =
    _$MerchantDeviceSavedDtoOutputStatusEnumSerializer();

class _$MerchantDeviceSavedDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<MerchantDeviceSavedDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'saved': 'saved',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'saved': 'saved',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantDeviceSavedDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'MerchantDeviceSavedDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantDeviceSavedDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantDeviceSavedDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantDeviceSavedDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantDeviceSavedDtoOutput extends MerchantDeviceSavedDtoOutput {
  @override
  final MerchantDeviceSavedDtoOutputStatusEnum status;

  factory _$MerchantDeviceSavedDtoOutput([
    void Function(MerchantDeviceSavedDtoOutputBuilder)? updates,
  ]) => (MerchantDeviceSavedDtoOutputBuilder()..update(updates))._build();

  _$MerchantDeviceSavedDtoOutput._({required this.status}) : super._();
  @override
  MerchantDeviceSavedDtoOutput rebuild(
    void Function(MerchantDeviceSavedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantDeviceSavedDtoOutputBuilder toBuilder() =>
      MerchantDeviceSavedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDeviceSavedDtoOutput && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantDeviceSavedDtoOutput',
    )..add('status', status)).toString();
  }
}

class MerchantDeviceSavedDtoOutputBuilder
    implements
        Builder<
          MerchantDeviceSavedDtoOutput,
          MerchantDeviceSavedDtoOutputBuilder
        > {
  _$MerchantDeviceSavedDtoOutput? _$v;

  MerchantDeviceSavedDtoOutputStatusEnum? _status;
  MerchantDeviceSavedDtoOutputStatusEnum? get status => _$this._status;
  set status(MerchantDeviceSavedDtoOutputStatusEnum? status) =>
      _$this._status = status;

  MerchantDeviceSavedDtoOutputBuilder() {
    MerchantDeviceSavedDtoOutput._defaults(this);
  }

  MerchantDeviceSavedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDeviceSavedDtoOutput other) {
    _$v = other as _$MerchantDeviceSavedDtoOutput;
  }

  @override
  void update(void Function(MerchantDeviceSavedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDeviceSavedDtoOutput build() => _build();

  _$MerchantDeviceSavedDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantDeviceSavedDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'MerchantDeviceSavedDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
