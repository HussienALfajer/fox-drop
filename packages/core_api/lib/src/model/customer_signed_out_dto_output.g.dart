// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_signed_out_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerSignedOutDtoOutputStatusEnum
_$customerSignedOutDtoOutputStatusEnum_signedOut =
    const CustomerSignedOutDtoOutputStatusEnum._('signedOut');

CustomerSignedOutDtoOutputStatusEnum
_$customerSignedOutDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'signedOut':
      return _$customerSignedOutDtoOutputStatusEnum_signedOut;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerSignedOutDtoOutputStatusEnum>
_$customerSignedOutDtoOutputStatusEnumValues =
    BuiltSet<CustomerSignedOutDtoOutputStatusEnum>(
      const <CustomerSignedOutDtoOutputStatusEnum>[
        _$customerSignedOutDtoOutputStatusEnum_signedOut,
      ],
    );

Serializer<CustomerSignedOutDtoOutputStatusEnum>
_$customerSignedOutDtoOutputStatusEnumSerializer =
    _$CustomerSignedOutDtoOutputStatusEnumSerializer();

class _$CustomerSignedOutDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CustomerSignedOutDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'signedOut': 'signed_out',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'signed_out': 'signedOut',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerSignedOutDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'CustomerSignedOutDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerSignedOutDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerSignedOutDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerSignedOutDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerSignedOutDtoOutput extends CustomerSignedOutDtoOutput {
  @override
  final CustomerSignedOutDtoOutputStatusEnum status;

  factory _$CustomerSignedOutDtoOutput([
    void Function(CustomerSignedOutDtoOutputBuilder)? updates,
  ]) => (CustomerSignedOutDtoOutputBuilder()..update(updates))._build();

  _$CustomerSignedOutDtoOutput._({required this.status}) : super._();
  @override
  CustomerSignedOutDtoOutput rebuild(
    void Function(CustomerSignedOutDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSignedOutDtoOutputBuilder toBuilder() =>
      CustomerSignedOutDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSignedOutDtoOutput && status == other.status;
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
      r'CustomerSignedOutDtoOutput',
    )..add('status', status)).toString();
  }
}

class CustomerSignedOutDtoOutputBuilder
    implements
        Builder<CustomerSignedOutDtoOutput, CustomerSignedOutDtoOutputBuilder> {
  _$CustomerSignedOutDtoOutput? _$v;

  CustomerSignedOutDtoOutputStatusEnum? _status;
  CustomerSignedOutDtoOutputStatusEnum? get status => _$this._status;
  set status(CustomerSignedOutDtoOutputStatusEnum? status) =>
      _$this._status = status;

  CustomerSignedOutDtoOutputBuilder() {
    CustomerSignedOutDtoOutput._defaults(this);
  }

  CustomerSignedOutDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSignedOutDtoOutput other) {
    _$v = other as _$CustomerSignedOutDtoOutput;
  }

  @override
  void update(void Function(CustomerSignedOutDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSignedOutDtoOutput build() => _build();

  _$CustomerSignedOutDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerSignedOutDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'CustomerSignedOutDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
