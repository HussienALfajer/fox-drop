// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_push_received_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerPushReceivedDtoOutputStatusEnum
_$customerPushReceivedDtoOutputStatusEnum_received =
    const CustomerPushReceivedDtoOutputStatusEnum._('received');

CustomerPushReceivedDtoOutputStatusEnum
_$customerPushReceivedDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'received':
      return _$customerPushReceivedDtoOutputStatusEnum_received;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerPushReceivedDtoOutputStatusEnum>
_$customerPushReceivedDtoOutputStatusEnumValues =
    BuiltSet<CustomerPushReceivedDtoOutputStatusEnum>(
      const <CustomerPushReceivedDtoOutputStatusEnum>[
        _$customerPushReceivedDtoOutputStatusEnum_received,
      ],
    );

Serializer<CustomerPushReceivedDtoOutputStatusEnum>
_$customerPushReceivedDtoOutputStatusEnumSerializer =
    _$CustomerPushReceivedDtoOutputStatusEnumSerializer();

class _$CustomerPushReceivedDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CustomerPushReceivedDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'received': 'received',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'received': 'received',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerPushReceivedDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'CustomerPushReceivedDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerPushReceivedDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerPushReceivedDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerPushReceivedDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerPushReceivedDtoOutput extends CustomerPushReceivedDtoOutput {
  @override
  final CustomerPushReceivedDtoOutputStatusEnum status;

  factory _$CustomerPushReceivedDtoOutput([
    void Function(CustomerPushReceivedDtoOutputBuilder)? updates,
  ]) => (CustomerPushReceivedDtoOutputBuilder()..update(updates))._build();

  _$CustomerPushReceivedDtoOutput._({required this.status}) : super._();
  @override
  CustomerPushReceivedDtoOutput rebuild(
    void Function(CustomerPushReceivedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPushReceivedDtoOutputBuilder toBuilder() =>
      CustomerPushReceivedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPushReceivedDtoOutput && status == other.status;
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
      r'CustomerPushReceivedDtoOutput',
    )..add('status', status)).toString();
  }
}

class CustomerPushReceivedDtoOutputBuilder
    implements
        Builder<
          CustomerPushReceivedDtoOutput,
          CustomerPushReceivedDtoOutputBuilder
        > {
  _$CustomerPushReceivedDtoOutput? _$v;

  CustomerPushReceivedDtoOutputStatusEnum? _status;
  CustomerPushReceivedDtoOutputStatusEnum? get status => _$this._status;
  set status(CustomerPushReceivedDtoOutputStatusEnum? status) =>
      _$this._status = status;

  CustomerPushReceivedDtoOutputBuilder() {
    CustomerPushReceivedDtoOutput._defaults(this);
  }

  CustomerPushReceivedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPushReceivedDtoOutput other) {
    _$v = other as _$CustomerPushReceivedDtoOutput;
  }

  @override
  void update(void Function(CustomerPushReceivedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPushReceivedDtoOutput build() => _build();

  _$CustomerPushReceivedDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerPushReceivedDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'CustomerPushReceivedDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
