// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_out_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SignedOutDtoOutputStatusEnum _$signedOutDtoOutputStatusEnum_signedOut =
    const SignedOutDtoOutputStatusEnum._('signedOut');

SignedOutDtoOutputStatusEnum _$signedOutDtoOutputStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'signedOut':
      return _$signedOutDtoOutputStatusEnum_signedOut;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SignedOutDtoOutputStatusEnum>
_$signedOutDtoOutputStatusEnumValues = BuiltSet<SignedOutDtoOutputStatusEnum>(
  const <SignedOutDtoOutputStatusEnum>[
    _$signedOutDtoOutputStatusEnum_signedOut,
  ],
);

Serializer<SignedOutDtoOutputStatusEnum>
_$signedOutDtoOutputStatusEnumSerializer =
    _$SignedOutDtoOutputStatusEnumSerializer();

class _$SignedOutDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<SignedOutDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'signedOut': 'signed_out',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'signed_out': 'signedOut',
  };

  @override
  final Iterable<Type> types = const <Type>[SignedOutDtoOutputStatusEnum];
  @override
  final String wireName = 'SignedOutDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    SignedOutDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SignedOutDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SignedOutDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SignedOutDtoOutput extends SignedOutDtoOutput {
  @override
  final SignedOutDtoOutputStatusEnum status;

  factory _$SignedOutDtoOutput([
    void Function(SignedOutDtoOutputBuilder)? updates,
  ]) => (SignedOutDtoOutputBuilder()..update(updates))._build();

  _$SignedOutDtoOutput._({required this.status}) : super._();
  @override
  SignedOutDtoOutput rebuild(
    void Function(SignedOutDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SignedOutDtoOutputBuilder toBuilder() =>
      SignedOutDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignedOutDtoOutput && status == other.status;
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
      r'SignedOutDtoOutput',
    )..add('status', status)).toString();
  }
}

class SignedOutDtoOutputBuilder
    implements Builder<SignedOutDtoOutput, SignedOutDtoOutputBuilder> {
  _$SignedOutDtoOutput? _$v;

  SignedOutDtoOutputStatusEnum? _status;
  SignedOutDtoOutputStatusEnum? get status => _$this._status;
  set status(SignedOutDtoOutputStatusEnum? status) => _$this._status = status;

  SignedOutDtoOutputBuilder() {
    SignedOutDtoOutput._defaults(this);
  }

  SignedOutDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignedOutDtoOutput other) {
    _$v = other as _$SignedOutDtoOutput;
  }

  @override
  void update(void Function(SignedOutDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignedOutDtoOutput build() => _build();

  _$SignedOutDtoOutput _build() {
    final _$result =
        _$v ??
        _$SignedOutDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'SignedOutDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
