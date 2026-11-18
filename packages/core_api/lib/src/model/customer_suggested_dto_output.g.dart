// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_suggested_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerSuggestedDtoOutputStatusEnum
_$customerSuggestedDtoOutputStatusEnum_received =
    const CustomerSuggestedDtoOutputStatusEnum._('received');

CustomerSuggestedDtoOutputStatusEnum
_$customerSuggestedDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'received':
      return _$customerSuggestedDtoOutputStatusEnum_received;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerSuggestedDtoOutputStatusEnum>
_$customerSuggestedDtoOutputStatusEnumValues =
    BuiltSet<CustomerSuggestedDtoOutputStatusEnum>(
      const <CustomerSuggestedDtoOutputStatusEnum>[
        _$customerSuggestedDtoOutputStatusEnum_received,
      ],
    );

Serializer<CustomerSuggestedDtoOutputStatusEnum>
_$customerSuggestedDtoOutputStatusEnumSerializer =
    _$CustomerSuggestedDtoOutputStatusEnumSerializer();

class _$CustomerSuggestedDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CustomerSuggestedDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'received': 'received',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'received': 'received',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerSuggestedDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'CustomerSuggestedDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerSuggestedDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerSuggestedDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerSuggestedDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerSuggestedDtoOutput extends CustomerSuggestedDtoOutput {
  @override
  final CustomerSuggestedDtoOutputStatusEnum status;

  factory _$CustomerSuggestedDtoOutput([
    void Function(CustomerSuggestedDtoOutputBuilder)? updates,
  ]) => (CustomerSuggestedDtoOutputBuilder()..update(updates))._build();

  _$CustomerSuggestedDtoOutput._({required this.status}) : super._();
  @override
  CustomerSuggestedDtoOutput rebuild(
    void Function(CustomerSuggestedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSuggestedDtoOutputBuilder toBuilder() =>
      CustomerSuggestedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSuggestedDtoOutput && status == other.status;
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
      r'CustomerSuggestedDtoOutput',
    )..add('status', status)).toString();
  }
}

class CustomerSuggestedDtoOutputBuilder
    implements
        Builder<CustomerSuggestedDtoOutput, CustomerSuggestedDtoOutputBuilder> {
  _$CustomerSuggestedDtoOutput? _$v;

  CustomerSuggestedDtoOutputStatusEnum? _status;
  CustomerSuggestedDtoOutputStatusEnum? get status => _$this._status;
  set status(CustomerSuggestedDtoOutputStatusEnum? status) =>
      _$this._status = status;

  CustomerSuggestedDtoOutputBuilder() {
    CustomerSuggestedDtoOutput._defaults(this);
  }

  CustomerSuggestedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSuggestedDtoOutput other) {
    _$v = other as _$CustomerSuggestedDtoOutput;
  }

  @override
  void update(void Function(CustomerSuggestedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSuggestedDtoOutput build() => _build();

  _$CustomerSuggestedDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerSuggestedDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'CustomerSuggestedDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
