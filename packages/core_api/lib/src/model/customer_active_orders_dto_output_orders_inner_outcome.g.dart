// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_outcome.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_free =
    const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum._('free');
const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_fake =
    const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum._('fake');
const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_damaged =
    const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum._(
      'damaged',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_wrongRefused =
    const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum._(
      'wrongRefused',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_failedOther =
    const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum._(
      'failedOther',
    );

CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'free':
      return _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_free;
    case 'fake':
      return _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_fake;
    case 'damaged':
      return _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_damaged;
    case 'wrongRefused':
      return _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_wrongRefused;
    case 'failedOther':
      return _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_failedOther;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum>
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnumValues =
    BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum>(const <
      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
    >[
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_free,
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_fake,
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_damaged,
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_wrongRefused,
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_failedOther,
    ]);

const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum_delivered =
    const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum._(
      'delivered',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum_failed =
    const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum._('failed');

CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'delivered':
      return _$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum_delivered;
    case 'failed':
      return _$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum>
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnumValues =
    BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum>(
      const <CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum>[
        _$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum_delivered,
        _$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum_failed,
      ],
    );

Serializer<CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum>
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnumSerializer =
    _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnumSerializer();
Serializer<CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum>
_$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnumSerializer =
    _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnumSerializer();

class _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'free': 'free',
    'fake': 'fake',
    'damaged': 'damaged',
    'wrongRefused': 'wrong_refused',
    'failedOther': 'failed_other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'free': 'free',
    'fake': 'fake',
    'damaged': 'damaged',
    'wrong_refused': 'wrongRefused',
    'failed_other': 'failedOther',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum,
  ];
  @override
  final String wireName =
      'CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'delivered': 'delivered',
    'failed': 'failed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'delivered': 'delivered',
    'failed': 'failed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum,
  ];
  @override
  final String wireName =
      'CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerOutcome
    extends CustomerActiveOrdersDtoOutputOrdersInnerOutcome {
  @override
  final DateTime at;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum outcome;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum status;
  @override
  final String? text;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect
  amountToCollect;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerOutcome([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerOutcome._({
    required this.at,
    required this.outcome,
    required this.status,
    this.text,
    required this.amountToCollect,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerOutcome rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerOutcome &&
        at == other.at &&
        outcome == other.outcome &&
        status == other.status &&
        text == other.text &&
        amountToCollect == other.amountToCollect;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, amountToCollect.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerOutcome',
          )
          ..add('at', at)
          ..add('outcome', outcome)
          ..add('status', status)
          ..add('text', text)
          ..add('amountToCollect', amountToCollect))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerOutcome,
          CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerOutcome? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum? _outcome;
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum? get outcome =>
      _$this._outcome;
  set outcome(
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum? outcome,
  ) => _$this._outcome = outcome;

  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum? _status;
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum? get status =>
      _$this._status;
  set status(
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum? status,
  ) => _$this._status = status;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder?
  _amountToCollect;
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder
  get amountToCollect => _$this._amountToCollect ??=
      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder();
  set amountToCollect(
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder?
    amountToCollect,
  ) => _$this._amountToCollect = amountToCollect;

  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerOutcome._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _outcome = $v.outcome;
      _status = $v.status;
      _text = $v.text;
      _amountToCollect = $v.amountToCollect.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerOutcome other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerOutcome;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerOutcome build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerOutcome _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerOutcome _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerOutcome._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CustomerActiveOrdersDtoOutputOrdersInnerOutcome',
              'at',
            ),
            outcome: BuiltValueNullFieldError.checkNotNull(
              outcome,
              r'CustomerActiveOrdersDtoOutputOrdersInnerOutcome',
              'outcome',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CustomerActiveOrdersDtoOutputOrdersInnerOutcome',
              'status',
            ),
            text: text,
            amountToCollect: amountToCollect.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amountToCollect';
        amountToCollect.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerActiveOrdersDtoOutputOrdersInnerOutcome',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
