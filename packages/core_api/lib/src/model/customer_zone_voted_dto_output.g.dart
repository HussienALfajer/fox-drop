// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_zone_voted_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerZoneVotedDtoOutputStatusEnum
_$customerZoneVotedDtoOutputStatusEnum_recorded =
    const CustomerZoneVotedDtoOutputStatusEnum._('recorded');
const CustomerZoneVotedDtoOutputStatusEnum
_$customerZoneVotedDtoOutputStatusEnum_alreadyVoted =
    const CustomerZoneVotedDtoOutputStatusEnum._('alreadyVoted');

CustomerZoneVotedDtoOutputStatusEnum
_$customerZoneVotedDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'recorded':
      return _$customerZoneVotedDtoOutputStatusEnum_recorded;
    case 'alreadyVoted':
      return _$customerZoneVotedDtoOutputStatusEnum_alreadyVoted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerZoneVotedDtoOutputStatusEnum>
_$customerZoneVotedDtoOutputStatusEnumValues =
    BuiltSet<CustomerZoneVotedDtoOutputStatusEnum>(
      const <CustomerZoneVotedDtoOutputStatusEnum>[
        _$customerZoneVotedDtoOutputStatusEnum_recorded,
        _$customerZoneVotedDtoOutputStatusEnum_alreadyVoted,
      ],
    );

Serializer<CustomerZoneVotedDtoOutputStatusEnum>
_$customerZoneVotedDtoOutputStatusEnumSerializer =
    _$CustomerZoneVotedDtoOutputStatusEnumSerializer();

class _$CustomerZoneVotedDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CustomerZoneVotedDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'recorded': 'recorded',
    'alreadyVoted': 'already_voted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'recorded': 'recorded',
    'already_voted': 'alreadyVoted',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerZoneVotedDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'CustomerZoneVotedDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerZoneVotedDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerZoneVotedDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerZoneVotedDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerZoneVotedDtoOutput extends CustomerZoneVotedDtoOutput {
  @override
  final CustomerZoneVotedDtoOutputStatusEnum status;

  factory _$CustomerZoneVotedDtoOutput([
    void Function(CustomerZoneVotedDtoOutputBuilder)? updates,
  ]) => (CustomerZoneVotedDtoOutputBuilder()..update(updates))._build();

  _$CustomerZoneVotedDtoOutput._({required this.status}) : super._();
  @override
  CustomerZoneVotedDtoOutput rebuild(
    void Function(CustomerZoneVotedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerZoneVotedDtoOutputBuilder toBuilder() =>
      CustomerZoneVotedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerZoneVotedDtoOutput && status == other.status;
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
      r'CustomerZoneVotedDtoOutput',
    )..add('status', status)).toString();
  }
}

class CustomerZoneVotedDtoOutputBuilder
    implements
        Builder<CustomerZoneVotedDtoOutput, CustomerZoneVotedDtoOutputBuilder> {
  _$CustomerZoneVotedDtoOutput? _$v;

  CustomerZoneVotedDtoOutputStatusEnum? _status;
  CustomerZoneVotedDtoOutputStatusEnum? get status => _$this._status;
  set status(CustomerZoneVotedDtoOutputStatusEnum? status) =>
      _$this._status = status;

  CustomerZoneVotedDtoOutputBuilder() {
    CustomerZoneVotedDtoOutput._defaults(this);
  }

  CustomerZoneVotedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerZoneVotedDtoOutput other) {
    _$v = other as _$CustomerZoneVotedDtoOutput;
  }

  @override
  void update(void Function(CustomerZoneVotedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerZoneVotedDtoOutput build() => _build();

  _$CustomerZoneVotedDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerZoneVotedDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'CustomerZoneVotedDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
