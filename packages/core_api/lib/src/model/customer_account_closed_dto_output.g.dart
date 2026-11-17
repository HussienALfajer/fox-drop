// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_account_closed_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerAccountClosedDtoOutputStatusEnum
_$customerAccountClosedDtoOutputStatusEnum_closed =
    const CustomerAccountClosedDtoOutputStatusEnum._('closed');

CustomerAccountClosedDtoOutputStatusEnum
_$customerAccountClosedDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'closed':
      return _$customerAccountClosedDtoOutputStatusEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerAccountClosedDtoOutputStatusEnum>
_$customerAccountClosedDtoOutputStatusEnumValues =
    BuiltSet<CustomerAccountClosedDtoOutputStatusEnum>(
      const <CustomerAccountClosedDtoOutputStatusEnum>[
        _$customerAccountClosedDtoOutputStatusEnum_closed,
      ],
    );

Serializer<CustomerAccountClosedDtoOutputStatusEnum>
_$customerAccountClosedDtoOutputStatusEnumSerializer =
    _$CustomerAccountClosedDtoOutputStatusEnumSerializer();

class _$CustomerAccountClosedDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CustomerAccountClosedDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'closed': 'closed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'closed': 'closed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerAccountClosedDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'CustomerAccountClosedDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerAccountClosedDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerAccountClosedDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerAccountClosedDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerAccountClosedDtoOutput extends CustomerAccountClosedDtoOutput {
  @override
  final CustomerAccountClosedDtoOutputStatusEnum status;

  factory _$CustomerAccountClosedDtoOutput([
    void Function(CustomerAccountClosedDtoOutputBuilder)? updates,
  ]) => (CustomerAccountClosedDtoOutputBuilder()..update(updates))._build();

  _$CustomerAccountClosedDtoOutput._({required this.status}) : super._();
  @override
  CustomerAccountClosedDtoOutput rebuild(
    void Function(CustomerAccountClosedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerAccountClosedDtoOutputBuilder toBuilder() =>
      CustomerAccountClosedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerAccountClosedDtoOutput && status == other.status;
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
      r'CustomerAccountClosedDtoOutput',
    )..add('status', status)).toString();
  }
}

class CustomerAccountClosedDtoOutputBuilder
    implements
        Builder<
          CustomerAccountClosedDtoOutput,
          CustomerAccountClosedDtoOutputBuilder
        > {
  _$CustomerAccountClosedDtoOutput? _$v;

  CustomerAccountClosedDtoOutputStatusEnum? _status;
  CustomerAccountClosedDtoOutputStatusEnum? get status => _$this._status;
  set status(CustomerAccountClosedDtoOutputStatusEnum? status) =>
      _$this._status = status;

  CustomerAccountClosedDtoOutputBuilder() {
    CustomerAccountClosedDtoOutput._defaults(this);
  }

  CustomerAccountClosedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerAccountClosedDtoOutput other) {
    _$v = other as _$CustomerAccountClosedDtoOutput;
  }

  @override
  void update(void Function(CustomerAccountClosedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerAccountClosedDtoOutput build() => _build();

  _$CustomerAccountClosedDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerAccountClosedDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'CustomerAccountClosedDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
