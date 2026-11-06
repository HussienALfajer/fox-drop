// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address_deleted_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerAddressDeletedDtoOutputStatusEnum
_$customerAddressDeletedDtoOutputStatusEnum_deleted =
    const CustomerAddressDeletedDtoOutputStatusEnum._('deleted');

CustomerAddressDeletedDtoOutputStatusEnum
_$customerAddressDeletedDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'deleted':
      return _$customerAddressDeletedDtoOutputStatusEnum_deleted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerAddressDeletedDtoOutputStatusEnum>
_$customerAddressDeletedDtoOutputStatusEnumValues =
    BuiltSet<CustomerAddressDeletedDtoOutputStatusEnum>(
      const <CustomerAddressDeletedDtoOutputStatusEnum>[
        _$customerAddressDeletedDtoOutputStatusEnum_deleted,
      ],
    );

Serializer<CustomerAddressDeletedDtoOutputStatusEnum>
_$customerAddressDeletedDtoOutputStatusEnumSerializer =
    _$CustomerAddressDeletedDtoOutputStatusEnumSerializer();

class _$CustomerAddressDeletedDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CustomerAddressDeletedDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'deleted': 'deleted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'deleted': 'deleted',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerAddressDeletedDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'CustomerAddressDeletedDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerAddressDeletedDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerAddressDeletedDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerAddressDeletedDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerAddressDeletedDtoOutput
    extends CustomerAddressDeletedDtoOutput {
  @override
  final CustomerAddressDeletedDtoOutputStatusEnum status;

  factory _$CustomerAddressDeletedDtoOutput([
    void Function(CustomerAddressDeletedDtoOutputBuilder)? updates,
  ]) => (CustomerAddressDeletedDtoOutputBuilder()..update(updates))._build();

  _$CustomerAddressDeletedDtoOutput._({required this.status}) : super._();
  @override
  CustomerAddressDeletedDtoOutput rebuild(
    void Function(CustomerAddressDeletedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerAddressDeletedDtoOutputBuilder toBuilder() =>
      CustomerAddressDeletedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerAddressDeletedDtoOutput && status == other.status;
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
      r'CustomerAddressDeletedDtoOutput',
    )..add('status', status)).toString();
  }
}

class CustomerAddressDeletedDtoOutputBuilder
    implements
        Builder<
          CustomerAddressDeletedDtoOutput,
          CustomerAddressDeletedDtoOutputBuilder
        > {
  _$CustomerAddressDeletedDtoOutput? _$v;

  CustomerAddressDeletedDtoOutputStatusEnum? _status;
  CustomerAddressDeletedDtoOutputStatusEnum? get status => _$this._status;
  set status(CustomerAddressDeletedDtoOutputStatusEnum? status) =>
      _$this._status = status;

  CustomerAddressDeletedDtoOutputBuilder() {
    CustomerAddressDeletedDtoOutput._defaults(this);
  }

  CustomerAddressDeletedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerAddressDeletedDtoOutput other) {
    _$v = other as _$CustomerAddressDeletedDtoOutput;
  }

  @override
  void update(void Function(CustomerAddressDeletedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerAddressDeletedDtoOutput build() => _build();

  _$CustomerAddressDeletedDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerAddressDeletedDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'CustomerAddressDeletedDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
