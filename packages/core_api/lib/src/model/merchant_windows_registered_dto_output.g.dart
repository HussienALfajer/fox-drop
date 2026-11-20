// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_windows_registered_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantWindowsRegisteredDtoOutputStatusEnum
_$merchantWindowsRegisteredDtoOutputStatusEnum_registered =
    const MerchantWindowsRegisteredDtoOutputStatusEnum._('registered');

MerchantWindowsRegisteredDtoOutputStatusEnum
_$merchantWindowsRegisteredDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'registered':
      return _$merchantWindowsRegisteredDtoOutputStatusEnum_registered;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantWindowsRegisteredDtoOutputStatusEnum>
_$merchantWindowsRegisteredDtoOutputStatusEnumValues =
    BuiltSet<MerchantWindowsRegisteredDtoOutputStatusEnum>(
      const <MerchantWindowsRegisteredDtoOutputStatusEnum>[
        _$merchantWindowsRegisteredDtoOutputStatusEnum_registered,
      ],
    );

Serializer<MerchantWindowsRegisteredDtoOutputStatusEnum>
_$merchantWindowsRegisteredDtoOutputStatusEnumSerializer =
    _$MerchantWindowsRegisteredDtoOutputStatusEnumSerializer();

class _$MerchantWindowsRegisteredDtoOutputStatusEnumSerializer
    implements
        PrimitiveSerializer<MerchantWindowsRegisteredDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'registered': 'registered',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'registered': 'registered',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantWindowsRegisteredDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'MerchantWindowsRegisteredDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantWindowsRegisteredDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantWindowsRegisteredDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantWindowsRegisteredDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantWindowsRegisteredDtoOutput
    extends MerchantWindowsRegisteredDtoOutput {
  @override
  final MerchantWindowsRegisteredDtoOutputStatusEnum status;

  factory _$MerchantWindowsRegisteredDtoOutput([
    void Function(MerchantWindowsRegisteredDtoOutputBuilder)? updates,
  ]) => (MerchantWindowsRegisteredDtoOutputBuilder()..update(updates))._build();

  _$MerchantWindowsRegisteredDtoOutput._({required this.status}) : super._();
  @override
  MerchantWindowsRegisteredDtoOutput rebuild(
    void Function(MerchantWindowsRegisteredDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantWindowsRegisteredDtoOutputBuilder toBuilder() =>
      MerchantWindowsRegisteredDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantWindowsRegisteredDtoOutput &&
        status == other.status;
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
      r'MerchantWindowsRegisteredDtoOutput',
    )..add('status', status)).toString();
  }
}

class MerchantWindowsRegisteredDtoOutputBuilder
    implements
        Builder<
          MerchantWindowsRegisteredDtoOutput,
          MerchantWindowsRegisteredDtoOutputBuilder
        > {
  _$MerchantWindowsRegisteredDtoOutput? _$v;

  MerchantWindowsRegisteredDtoOutputStatusEnum? _status;
  MerchantWindowsRegisteredDtoOutputStatusEnum? get status => _$this._status;
  set status(MerchantWindowsRegisteredDtoOutputStatusEnum? status) =>
      _$this._status = status;

  MerchantWindowsRegisteredDtoOutputBuilder() {
    MerchantWindowsRegisteredDtoOutput._defaults(this);
  }

  MerchantWindowsRegisteredDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantWindowsRegisteredDtoOutput other) {
    _$v = other as _$MerchantWindowsRegisteredDtoOutput;
  }

  @override
  void update(
    void Function(MerchantWindowsRegisteredDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantWindowsRegisteredDtoOutput build() => _build();

  _$MerchantWindowsRegisteredDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantWindowsRegisteredDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'MerchantWindowsRegisteredDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
