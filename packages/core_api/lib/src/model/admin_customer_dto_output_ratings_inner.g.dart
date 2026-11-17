// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_ratings_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCustomerDtoOutputRatingsInnerPartyEnum
_$adminCustomerDtoOutputRatingsInnerPartyEnum_restaurant =
    const AdminCustomerDtoOutputRatingsInnerPartyEnum._('restaurant');
const AdminCustomerDtoOutputRatingsInnerPartyEnum
_$adminCustomerDtoOutputRatingsInnerPartyEnum_captain =
    const AdminCustomerDtoOutputRatingsInnerPartyEnum._('captain');

AdminCustomerDtoOutputRatingsInnerPartyEnum
_$adminCustomerDtoOutputRatingsInnerPartyEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminCustomerDtoOutputRatingsInnerPartyEnum_restaurant;
    case 'captain':
      return _$adminCustomerDtoOutputRatingsInnerPartyEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCustomerDtoOutputRatingsInnerPartyEnum>
_$adminCustomerDtoOutputRatingsInnerPartyEnumValues =
    BuiltSet<AdminCustomerDtoOutputRatingsInnerPartyEnum>(
      const <AdminCustomerDtoOutputRatingsInnerPartyEnum>[
        _$adminCustomerDtoOutputRatingsInnerPartyEnum_restaurant,
        _$adminCustomerDtoOutputRatingsInnerPartyEnum_captain,
      ],
    );

Serializer<AdminCustomerDtoOutputRatingsInnerPartyEnum>
_$adminCustomerDtoOutputRatingsInnerPartyEnumSerializer =
    _$AdminCustomerDtoOutputRatingsInnerPartyEnumSerializer();

class _$AdminCustomerDtoOutputRatingsInnerPartyEnumSerializer
    implements
        PrimitiveSerializer<AdminCustomerDtoOutputRatingsInnerPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'captain': 'captain',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'captain': 'captain',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCustomerDtoOutputRatingsInnerPartyEnum,
  ];
  @override
  final String wireName = 'AdminCustomerDtoOutputRatingsInnerPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputRatingsInnerPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCustomerDtoOutputRatingsInnerPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCustomerDtoOutputRatingsInnerPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCustomerDtoOutputRatingsInner
    extends AdminCustomerDtoOutputRatingsInner {
  @override
  final String orderId;
  @override
  final String orderNumber;
  @override
  final AdminCustomerDtoOutputRatingsInnerPartyEnum party;
  @override
  final String? restaurantName;
  @override
  final String? captainName;
  @override
  final int stars;
  @override
  final BuiltList<AdminCustomerDtoOutputRatingsInnerReasonsInner?> reasons;
  @override
  final String? comment;
  @override
  final DateTime at;

  factory _$AdminCustomerDtoOutputRatingsInner([
    void Function(AdminCustomerDtoOutputRatingsInnerBuilder)? updates,
  ]) => (AdminCustomerDtoOutputRatingsInnerBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputRatingsInner._({
    required this.orderId,
    required this.orderNumber,
    required this.party,
    this.restaurantName,
    this.captainName,
    required this.stars,
    required this.reasons,
    this.comment,
    required this.at,
  }) : super._();
  @override
  AdminCustomerDtoOutputRatingsInner rebuild(
    void Function(AdminCustomerDtoOutputRatingsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputRatingsInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputRatingsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputRatingsInner &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber &&
        party == other.party &&
        restaurantName == other.restaurantName &&
        captainName == other.captainName &&
        stars == other.stars &&
        reasons == other.reasons &&
        comment == other.comment &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, captainName.hashCode);
    _$hash = $jc(_$hash, stars.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputRatingsInner')
          ..add('orderId', orderId)
          ..add('orderNumber', orderNumber)
          ..add('party', party)
          ..add('restaurantName', restaurantName)
          ..add('captainName', captainName)
          ..add('stars', stars)
          ..add('reasons', reasons)
          ..add('comment', comment)
          ..add('at', at))
        .toString();
  }
}

class AdminCustomerDtoOutputRatingsInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputRatingsInner,
          AdminCustomerDtoOutputRatingsInnerBuilder
        > {
  _$AdminCustomerDtoOutputRatingsInner? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  AdminCustomerDtoOutputRatingsInnerPartyEnum? _party;
  AdminCustomerDtoOutputRatingsInnerPartyEnum? get party => _$this._party;
  set party(AdminCustomerDtoOutputRatingsInnerPartyEnum? party) =>
      _$this._party = party;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  String? _captainName;
  String? get captainName => _$this._captainName;
  set captainName(String? captainName) => _$this._captainName = captainName;

  int? _stars;
  int? get stars => _$this._stars;
  set stars(int? stars) => _$this._stars = stars;

  ListBuilder<AdminCustomerDtoOutputRatingsInnerReasonsInner?>? _reasons;
  ListBuilder<AdminCustomerDtoOutputRatingsInnerReasonsInner?> get reasons =>
      _$this._reasons ??=
          ListBuilder<AdminCustomerDtoOutputRatingsInnerReasonsInner?>();
  set reasons(
    ListBuilder<AdminCustomerDtoOutputRatingsInnerReasonsInner?>? reasons,
  ) => _$this._reasons = reasons;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminCustomerDtoOutputRatingsInnerBuilder() {
    AdminCustomerDtoOutputRatingsInner._defaults(this);
  }

  AdminCustomerDtoOutputRatingsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _orderNumber = $v.orderNumber;
      _party = $v.party;
      _restaurantName = $v.restaurantName;
      _captainName = $v.captainName;
      _stars = $v.stars;
      _reasons = $v.reasons.toBuilder();
      _comment = $v.comment;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputRatingsInner other) {
    _$v = other as _$AdminCustomerDtoOutputRatingsInner;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputRatingsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputRatingsInner build() => _build();

  _$AdminCustomerDtoOutputRatingsInner _build() {
    _$AdminCustomerDtoOutputRatingsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminCustomerDtoOutputRatingsInner._(
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'AdminCustomerDtoOutputRatingsInner',
              'orderId',
            ),
            orderNumber: BuiltValueNullFieldError.checkNotNull(
              orderNumber,
              r'AdminCustomerDtoOutputRatingsInner',
              'orderNumber',
            ),
            party: BuiltValueNullFieldError.checkNotNull(
              party,
              r'AdminCustomerDtoOutputRatingsInner',
              'party',
            ),
            restaurantName: restaurantName,
            captainName: captainName,
            stars: BuiltValueNullFieldError.checkNotNull(
              stars,
              r'AdminCustomerDtoOutputRatingsInner',
              'stars',
            ),
            reasons: reasons.build(),
            comment: comment,
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminCustomerDtoOutputRatingsInner',
              'at',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCustomerDtoOutputRatingsInner',
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
