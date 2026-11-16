// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_codes_dto_output_codes_inner_ended.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerCodesDtoOutputCodesInnerEndedReasonEnum
_$customerCodesDtoOutputCodesInnerEndedReasonEnum_used =
    const CustomerCodesDtoOutputCodesInnerEndedReasonEnum._('used');
const CustomerCodesDtoOutputCodesInnerEndedReasonEnum
_$customerCodesDtoOutputCodesInnerEndedReasonEnum_expired =
    const CustomerCodesDtoOutputCodesInnerEndedReasonEnum._('expired');

CustomerCodesDtoOutputCodesInnerEndedReasonEnum
_$customerCodesDtoOutputCodesInnerEndedReasonEnumValueOf(String name) {
  switch (name) {
    case 'used':
      return _$customerCodesDtoOutputCodesInnerEndedReasonEnum_used;
    case 'expired':
      return _$customerCodesDtoOutputCodesInnerEndedReasonEnum_expired;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerCodesDtoOutputCodesInnerEndedReasonEnum>
_$customerCodesDtoOutputCodesInnerEndedReasonEnumValues =
    BuiltSet<CustomerCodesDtoOutputCodesInnerEndedReasonEnum>(
      const <CustomerCodesDtoOutputCodesInnerEndedReasonEnum>[
        _$customerCodesDtoOutputCodesInnerEndedReasonEnum_used,
        _$customerCodesDtoOutputCodesInnerEndedReasonEnum_expired,
      ],
    );

Serializer<CustomerCodesDtoOutputCodesInnerEndedReasonEnum>
_$customerCodesDtoOutputCodesInnerEndedReasonEnumSerializer =
    _$CustomerCodesDtoOutputCodesInnerEndedReasonEnumSerializer();

class _$CustomerCodesDtoOutputCodesInnerEndedReasonEnumSerializer
    implements
        PrimitiveSerializer<CustomerCodesDtoOutputCodesInnerEndedReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'used': 'used',
    'expired': 'expired',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'used': 'used',
    'expired': 'expired',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerCodesDtoOutputCodesInnerEndedReasonEnum,
  ];
  @override
  final String wireName = 'CustomerCodesDtoOutputCodesInnerEndedReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerCodesDtoOutputCodesInnerEndedReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerCodesDtoOutputCodesInnerEndedReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerCodesDtoOutputCodesInnerEndedReasonEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerCodesDtoOutputCodesInnerEnded
    extends CustomerCodesDtoOutputCodesInnerEnded {
  @override
  final CustomerCodesDtoOutputCodesInnerEndedReasonEnum reason;
  @override
  final DateTime at;

  factory _$CustomerCodesDtoOutputCodesInnerEnded([
    void Function(CustomerCodesDtoOutputCodesInnerEndedBuilder)? updates,
  ]) => (CustomerCodesDtoOutputCodesInnerEndedBuilder()..update(updates))
      ._build();

  _$CustomerCodesDtoOutputCodesInnerEnded._({
    required this.reason,
    required this.at,
  }) : super._();
  @override
  CustomerCodesDtoOutputCodesInnerEnded rebuild(
    void Function(CustomerCodesDtoOutputCodesInnerEndedBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCodesDtoOutputCodesInnerEndedBuilder toBuilder() =>
      CustomerCodesDtoOutputCodesInnerEndedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCodesDtoOutputCodesInnerEnded &&
        reason == other.reason &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerCodesDtoOutputCodesInnerEnded',
          )
          ..add('reason', reason)
          ..add('at', at))
        .toString();
  }
}

class CustomerCodesDtoOutputCodesInnerEndedBuilder
    implements
        Builder<
          CustomerCodesDtoOutputCodesInnerEnded,
          CustomerCodesDtoOutputCodesInnerEndedBuilder
        > {
  _$CustomerCodesDtoOutputCodesInnerEnded? _$v;

  CustomerCodesDtoOutputCodesInnerEndedReasonEnum? _reason;
  CustomerCodesDtoOutputCodesInnerEndedReasonEnum? get reason => _$this._reason;
  set reason(CustomerCodesDtoOutputCodesInnerEndedReasonEnum? reason) =>
      _$this._reason = reason;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CustomerCodesDtoOutputCodesInnerEndedBuilder() {
    CustomerCodesDtoOutputCodesInnerEnded._defaults(this);
  }

  CustomerCodesDtoOutputCodesInnerEndedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerCodesDtoOutputCodesInnerEnded other) {
    _$v = other as _$CustomerCodesDtoOutputCodesInnerEnded;
  }

  @override
  void update(
    void Function(CustomerCodesDtoOutputCodesInnerEndedBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCodesDtoOutputCodesInnerEnded build() => _build();

  _$CustomerCodesDtoOutputCodesInnerEnded _build() {
    final _$result =
        _$v ??
        _$CustomerCodesDtoOutputCodesInnerEnded._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CustomerCodesDtoOutputCodesInnerEnded',
            'reason',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CustomerCodesDtoOutputCodesInnerEnded',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
