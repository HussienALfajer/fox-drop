// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_signed_out_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantSignedOutDtoOutputStatusEnum
_$merchantSignedOutDtoOutputStatusEnum_signedOut =
    const MerchantSignedOutDtoOutputStatusEnum._('signedOut');

MerchantSignedOutDtoOutputStatusEnum
_$merchantSignedOutDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'signedOut':
      return _$merchantSignedOutDtoOutputStatusEnum_signedOut;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantSignedOutDtoOutputStatusEnum>
_$merchantSignedOutDtoOutputStatusEnumValues =
    BuiltSet<MerchantSignedOutDtoOutputStatusEnum>(
      const <MerchantSignedOutDtoOutputStatusEnum>[
        _$merchantSignedOutDtoOutputStatusEnum_signedOut,
      ],
    );

Serializer<MerchantSignedOutDtoOutputStatusEnum>
_$merchantSignedOutDtoOutputStatusEnumSerializer =
    _$MerchantSignedOutDtoOutputStatusEnumSerializer();

class _$MerchantSignedOutDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<MerchantSignedOutDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'signedOut': 'signed_out',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'signed_out': 'signedOut',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantSignedOutDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'MerchantSignedOutDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantSignedOutDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantSignedOutDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantSignedOutDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantSignedOutDtoOutput extends MerchantSignedOutDtoOutput {
  @override
  final MerchantSignedOutDtoOutputStatusEnum status;

  factory _$MerchantSignedOutDtoOutput([
    void Function(MerchantSignedOutDtoOutputBuilder)? updates,
  ]) => (MerchantSignedOutDtoOutputBuilder()..update(updates))._build();

  _$MerchantSignedOutDtoOutput._({required this.status}) : super._();
  @override
  MerchantSignedOutDtoOutput rebuild(
    void Function(MerchantSignedOutDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantSignedOutDtoOutputBuilder toBuilder() =>
      MerchantSignedOutDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantSignedOutDtoOutput && status == other.status;
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
      r'MerchantSignedOutDtoOutput',
    )..add('status', status)).toString();
  }
}

class MerchantSignedOutDtoOutputBuilder
    implements
        Builder<MerchantSignedOutDtoOutput, MerchantSignedOutDtoOutputBuilder> {
  _$MerchantSignedOutDtoOutput? _$v;

  MerchantSignedOutDtoOutputStatusEnum? _status;
  MerchantSignedOutDtoOutputStatusEnum? get status => _$this._status;
  set status(MerchantSignedOutDtoOutputStatusEnum? status) =>
      _$this._status = status;

  MerchantSignedOutDtoOutputBuilder() {
    MerchantSignedOutDtoOutput._defaults(this);
  }

  MerchantSignedOutDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantSignedOutDtoOutput other) {
    _$v = other as _$MerchantSignedOutDtoOutput;
  }

  @override
  void update(void Function(MerchantSignedOutDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantSignedOutDtoOutput build() => _build();

  _$MerchantSignedOutDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantSignedOutDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'MerchantSignedOutDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
