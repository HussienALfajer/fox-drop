// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_portal_signed_out_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantPortalSignedOutDtoOutputStatusEnum
_$merchantPortalSignedOutDtoOutputStatusEnum_signedOut =
    const MerchantPortalSignedOutDtoOutputStatusEnum._('signedOut');

MerchantPortalSignedOutDtoOutputStatusEnum
_$merchantPortalSignedOutDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'signedOut':
      return _$merchantPortalSignedOutDtoOutputStatusEnum_signedOut;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantPortalSignedOutDtoOutputStatusEnum>
_$merchantPortalSignedOutDtoOutputStatusEnumValues =
    BuiltSet<MerchantPortalSignedOutDtoOutputStatusEnum>(
      const <MerchantPortalSignedOutDtoOutputStatusEnum>[
        _$merchantPortalSignedOutDtoOutputStatusEnum_signedOut,
      ],
    );

Serializer<MerchantPortalSignedOutDtoOutputStatusEnum>
_$merchantPortalSignedOutDtoOutputStatusEnumSerializer =
    _$MerchantPortalSignedOutDtoOutputStatusEnumSerializer();

class _$MerchantPortalSignedOutDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<MerchantPortalSignedOutDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'signedOut': 'signed_out',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'signed_out': 'signedOut',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantPortalSignedOutDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'MerchantPortalSignedOutDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantPortalSignedOutDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantPortalSignedOutDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantPortalSignedOutDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantPortalSignedOutDtoOutput
    extends MerchantPortalSignedOutDtoOutput {
  @override
  final MerchantPortalSignedOutDtoOutputStatusEnum status;

  factory _$MerchantPortalSignedOutDtoOutput([
    void Function(MerchantPortalSignedOutDtoOutputBuilder)? updates,
  ]) => (MerchantPortalSignedOutDtoOutputBuilder()..update(updates))._build();

  _$MerchantPortalSignedOutDtoOutput._({required this.status}) : super._();
  @override
  MerchantPortalSignedOutDtoOutput rebuild(
    void Function(MerchantPortalSignedOutDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPortalSignedOutDtoOutputBuilder toBuilder() =>
      MerchantPortalSignedOutDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPortalSignedOutDtoOutput && status == other.status;
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
      r'MerchantPortalSignedOutDtoOutput',
    )..add('status', status)).toString();
  }
}

class MerchantPortalSignedOutDtoOutputBuilder
    implements
        Builder<
          MerchantPortalSignedOutDtoOutput,
          MerchantPortalSignedOutDtoOutputBuilder
        > {
  _$MerchantPortalSignedOutDtoOutput? _$v;

  MerchantPortalSignedOutDtoOutputStatusEnum? _status;
  MerchantPortalSignedOutDtoOutputStatusEnum? get status => _$this._status;
  set status(MerchantPortalSignedOutDtoOutputStatusEnum? status) =>
      _$this._status = status;

  MerchantPortalSignedOutDtoOutputBuilder() {
    MerchantPortalSignedOutDtoOutput._defaults(this);
  }

  MerchantPortalSignedOutDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPortalSignedOutDtoOutput other) {
    _$v = other as _$MerchantPortalSignedOutDtoOutput;
  }

  @override
  void update(void Function(MerchantPortalSignedOutDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPortalSignedOutDtoOutput build() => _build();

  _$MerchantPortalSignedOutDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantPortalSignedOutDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'MerchantPortalSignedOutDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
