// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_accepted_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TermsAcceptedDtoOutputStatusEnum
_$termsAcceptedDtoOutputStatusEnum_accepted =
    const TermsAcceptedDtoOutputStatusEnum._('accepted');

TermsAcceptedDtoOutputStatusEnum _$termsAcceptedDtoOutputStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'accepted':
      return _$termsAcceptedDtoOutputStatusEnum_accepted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TermsAcceptedDtoOutputStatusEnum>
_$termsAcceptedDtoOutputStatusEnumValues =
    BuiltSet<TermsAcceptedDtoOutputStatusEnum>(
      const <TermsAcceptedDtoOutputStatusEnum>[
        _$termsAcceptedDtoOutputStatusEnum_accepted,
      ],
    );

Serializer<TermsAcceptedDtoOutputStatusEnum>
_$termsAcceptedDtoOutputStatusEnumSerializer =
    _$TermsAcceptedDtoOutputStatusEnumSerializer();

class _$TermsAcceptedDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<TermsAcceptedDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'accepted': 'accepted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'accepted': 'accepted',
  };

  @override
  final Iterable<Type> types = const <Type>[TermsAcceptedDtoOutputStatusEnum];
  @override
  final String wireName = 'TermsAcceptedDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    TermsAcceptedDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  TermsAcceptedDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => TermsAcceptedDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$TermsAcceptedDtoOutput extends TermsAcceptedDtoOutput {
  @override
  final TermsAcceptedDtoOutputStatusEnum status;

  factory _$TermsAcceptedDtoOutput([
    void Function(TermsAcceptedDtoOutputBuilder)? updates,
  ]) => (TermsAcceptedDtoOutputBuilder()..update(updates))._build();

  _$TermsAcceptedDtoOutput._({required this.status}) : super._();
  @override
  TermsAcceptedDtoOutput rebuild(
    void Function(TermsAcceptedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TermsAcceptedDtoOutputBuilder toBuilder() =>
      TermsAcceptedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TermsAcceptedDtoOutput && status == other.status;
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
      r'TermsAcceptedDtoOutput',
    )..add('status', status)).toString();
  }
}

class TermsAcceptedDtoOutputBuilder
    implements Builder<TermsAcceptedDtoOutput, TermsAcceptedDtoOutputBuilder> {
  _$TermsAcceptedDtoOutput? _$v;

  TermsAcceptedDtoOutputStatusEnum? _status;
  TermsAcceptedDtoOutputStatusEnum? get status => _$this._status;
  set status(TermsAcceptedDtoOutputStatusEnum? status) =>
      _$this._status = status;

  TermsAcceptedDtoOutputBuilder() {
    TermsAcceptedDtoOutput._defaults(this);
  }

  TermsAcceptedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TermsAcceptedDtoOutput other) {
    _$v = other as _$TermsAcceptedDtoOutput;
  }

  @override
  void update(void Function(TermsAcceptedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TermsAcceptedDtoOutput build() => _build();

  _$TermsAcceptedDtoOutput _build() {
    final _$result =
        _$v ??
        _$TermsAcceptedDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'TermsAcceptedDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
