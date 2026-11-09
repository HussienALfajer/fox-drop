// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_signed_out_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainSignedOutDtoOutputStatusEnum
_$captainSignedOutDtoOutputStatusEnum_signedOut =
    const CaptainSignedOutDtoOutputStatusEnum._('signedOut');

CaptainSignedOutDtoOutputStatusEnum
_$captainSignedOutDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'signedOut':
      return _$captainSignedOutDtoOutputStatusEnum_signedOut;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainSignedOutDtoOutputStatusEnum>
_$captainSignedOutDtoOutputStatusEnumValues =
    BuiltSet<CaptainSignedOutDtoOutputStatusEnum>(
      const <CaptainSignedOutDtoOutputStatusEnum>[
        _$captainSignedOutDtoOutputStatusEnum_signedOut,
      ],
    );

Serializer<CaptainSignedOutDtoOutputStatusEnum>
_$captainSignedOutDtoOutputStatusEnumSerializer =
    _$CaptainSignedOutDtoOutputStatusEnumSerializer();

class _$CaptainSignedOutDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CaptainSignedOutDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'signedOut': 'signed_out',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'signed_out': 'signedOut',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainSignedOutDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'CaptainSignedOutDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainSignedOutDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainSignedOutDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainSignedOutDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainSignedOutDtoOutput extends CaptainSignedOutDtoOutput {
  @override
  final CaptainSignedOutDtoOutputStatusEnum status;

  factory _$CaptainSignedOutDtoOutput([
    void Function(CaptainSignedOutDtoOutputBuilder)? updates,
  ]) => (CaptainSignedOutDtoOutputBuilder()..update(updates))._build();

  _$CaptainSignedOutDtoOutput._({required this.status}) : super._();
  @override
  CaptainSignedOutDtoOutput rebuild(
    void Function(CaptainSignedOutDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainSignedOutDtoOutputBuilder toBuilder() =>
      CaptainSignedOutDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainSignedOutDtoOutput && status == other.status;
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
      r'CaptainSignedOutDtoOutput',
    )..add('status', status)).toString();
  }
}

class CaptainSignedOutDtoOutputBuilder
    implements
        Builder<CaptainSignedOutDtoOutput, CaptainSignedOutDtoOutputBuilder> {
  _$CaptainSignedOutDtoOutput? _$v;

  CaptainSignedOutDtoOutputStatusEnum? _status;
  CaptainSignedOutDtoOutputStatusEnum? get status => _$this._status;
  set status(CaptainSignedOutDtoOutputStatusEnum? status) =>
      _$this._status = status;

  CaptainSignedOutDtoOutputBuilder() {
    CaptainSignedOutDtoOutput._defaults(this);
  }

  CaptainSignedOutDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainSignedOutDtoOutput other) {
    _$v = other as _$CaptainSignedOutDtoOutput;
  }

  @override
  void update(void Function(CaptainSignedOutDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainSignedOutDtoOutput build() => _build();

  _$CaptainSignedOutDtoOutput _build() {
    final _$result =
        _$v ??
        _$CaptainSignedOutDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'CaptainSignedOutDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
