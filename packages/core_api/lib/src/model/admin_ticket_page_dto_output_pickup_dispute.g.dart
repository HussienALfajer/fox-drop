// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_page_dto_output_pickup_dispute.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum
_$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_restaurant =
    const AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum._('restaurant');
const AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum
_$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_automatic =
    const AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum._('automatic');
const AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum
_$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_operations =
    const AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum._('operations');

AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum
_$adminTicketPageDtoOutputPickupDisputeConfirmedByEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_restaurant;
    case 'automatic':
      return _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_automatic;
    case 'operations':
      return _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_operations;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum>
_$adminTicketPageDtoOutputPickupDisputeConfirmedByEnumValues =
    BuiltSet<AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum>(
      const <AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum>[
        _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_restaurant,
        _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_automatic,
        _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_operations,
      ],
    );

Serializer<AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum>
_$adminTicketPageDtoOutputPickupDisputeConfirmedByEnumSerializer =
    _$AdminTicketPageDtoOutputPickupDisputeConfirmedByEnumSerializer();

class _$AdminTicketPageDtoOutputPickupDisputeConfirmedByEnumSerializer
    implements
        PrimitiveSerializer<
          AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'automatic': 'automatic',
    'operations': 'operations',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'automatic': 'automatic',
    'operations': 'operations',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum,
  ];
  @override
  final String wireName =
      'AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketPageDtoOutputPickupDispute
    extends AdminTicketPageDtoOutputPickupDispute {
  @override
  final AdminTicketPageDtoOutputPickupDisputePickupPayment? pickupPayment;
  @override
  final BuiltList<AdminTicketPageDtoOutputPickupDisputePickupPayment?> recorded;
  @override
  final BuiltList<AdminTicketPageDtoOutputPickupDisputePickupPayment?> received;
  @override
  final AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum confirmedBy;
  @override
  final String? captainName;
  @override
  final DateTime disputedAt;
  @override
  final BuiltList<String> currencies;

  factory _$AdminTicketPageDtoOutputPickupDispute([
    void Function(AdminTicketPageDtoOutputPickupDisputeBuilder)? updates,
  ]) => (AdminTicketPageDtoOutputPickupDisputeBuilder()..update(updates))
      ._build();

  _$AdminTicketPageDtoOutputPickupDispute._({
    this.pickupPayment,
    required this.recorded,
    required this.received,
    required this.confirmedBy,
    this.captainName,
    required this.disputedAt,
    required this.currencies,
  }) : super._();
  @override
  AdminTicketPageDtoOutputPickupDispute rebuild(
    void Function(AdminTicketPageDtoOutputPickupDisputeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPageDtoOutputPickupDisputeBuilder toBuilder() =>
      AdminTicketPageDtoOutputPickupDisputeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPageDtoOutputPickupDispute &&
        pickupPayment == other.pickupPayment &&
        recorded == other.recorded &&
        received == other.received &&
        confirmedBy == other.confirmedBy &&
        captainName == other.captainName &&
        disputedAt == other.disputedAt &&
        currencies == other.currencies;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pickupPayment.hashCode);
    _$hash = $jc(_$hash, recorded.hashCode);
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jc(_$hash, confirmedBy.hashCode);
    _$hash = $jc(_$hash, captainName.hashCode);
    _$hash = $jc(_$hash, disputedAt.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminTicketPageDtoOutputPickupDispute',
          )
          ..add('pickupPayment', pickupPayment)
          ..add('recorded', recorded)
          ..add('received', received)
          ..add('confirmedBy', confirmedBy)
          ..add('captainName', captainName)
          ..add('disputedAt', disputedAt)
          ..add('currencies', currencies))
        .toString();
  }
}

class AdminTicketPageDtoOutputPickupDisputeBuilder
    implements
        Builder<
          AdminTicketPageDtoOutputPickupDispute,
          AdminTicketPageDtoOutputPickupDisputeBuilder
        > {
  _$AdminTicketPageDtoOutputPickupDispute? _$v;

  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? _pickupPayment;
  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder get pickupPayment =>
      _$this._pickupPayment ??=
          AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder();
  set pickupPayment(
    AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? pickupPayment,
  ) => _$this._pickupPayment = pickupPayment;

  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>? _recorded;
  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>
  get recorded => _$this._recorded ??=
      ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>();
  set recorded(
    ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>? recorded,
  ) => _$this._recorded = recorded;

  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>? _received;
  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>
  get received => _$this._received ??=
      ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>();
  set received(
    ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>? received,
  ) => _$this._received = received;

  AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum? _confirmedBy;
  AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum? get confirmedBy =>
      _$this._confirmedBy;
  set confirmedBy(
    AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum? confirmedBy,
  ) => _$this._confirmedBy = confirmedBy;

  String? _captainName;
  String? get captainName => _$this._captainName;
  set captainName(String? captainName) => _$this._captainName = captainName;

  DateTime? _disputedAt;
  DateTime? get disputedAt => _$this._disputedAt;
  set disputedAt(DateTime? disputedAt) => _$this._disputedAt = disputedAt;

  ListBuilder<String>? _currencies;
  ListBuilder<String> get currencies =>
      _$this._currencies ??= ListBuilder<String>();
  set currencies(ListBuilder<String>? currencies) =>
      _$this._currencies = currencies;

  AdminTicketPageDtoOutputPickupDisputeBuilder() {
    AdminTicketPageDtoOutputPickupDispute._defaults(this);
  }

  AdminTicketPageDtoOutputPickupDisputeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pickupPayment = $v.pickupPayment?.toBuilder();
      _recorded = $v.recorded.toBuilder();
      _received = $v.received.toBuilder();
      _confirmedBy = $v.confirmedBy;
      _captainName = $v.captainName;
      _disputedAt = $v.disputedAt;
      _currencies = $v.currencies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPageDtoOutputPickupDispute other) {
    _$v = other as _$AdminTicketPageDtoOutputPickupDispute;
  }

  @override
  void update(
    void Function(AdminTicketPageDtoOutputPickupDisputeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPageDtoOutputPickupDispute build() => _build();

  _$AdminTicketPageDtoOutputPickupDispute _build() {
    _$AdminTicketPageDtoOutputPickupDispute _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketPageDtoOutputPickupDispute._(
            pickupPayment: _pickupPayment?.build(),
            recorded: recorded.build(),
            received: received.build(),
            confirmedBy: BuiltValueNullFieldError.checkNotNull(
              confirmedBy,
              r'AdminTicketPageDtoOutputPickupDispute',
              'confirmedBy',
            ),
            captainName: captainName,
            disputedAt: BuiltValueNullFieldError.checkNotNull(
              disputedAt,
              r'AdminTicketPageDtoOutputPickupDispute',
              'disputedAt',
            ),
            currencies: currencies.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pickupPayment';
        _pickupPayment?.build();
        _$failedField = 'recorded';
        recorded.build();
        _$failedField = 'received';
        received.build();

        _$failedField = 'currencies';
        currencies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketPageDtoOutputPickupDispute',
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
