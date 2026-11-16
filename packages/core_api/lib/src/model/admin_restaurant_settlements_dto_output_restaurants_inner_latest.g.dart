// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_settlements_dto_output_restaurants_inner_latest.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum
_$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum_unpaid =
    const AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum._(
      'unpaid',
    );
const AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum
_$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum_partlyPaid =
    const AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum._(
      'partlyPaid',
    );
const AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum
_$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum_paid =
    const AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum._(
      'paid',
    );

AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum
_$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'unpaid':
      return _$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum_unpaid;
    case 'partlyPaid':
      return _$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum_partlyPaid;
    case 'paid':
      return _$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum_paid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum
>
_$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnumValues =
    BuiltSet<
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum
    >(const <
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum
    >[
      _$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum_unpaid,
      _$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum_partlyPaid,
      _$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum_paid,
    ]);

Serializer<AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum>
_$adminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnumSerializer =
    _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnumSerializer();

class _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'unpaid': 'unpaid',
    'partlyPaid': 'partly_paid',
    'paid': 'paid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'unpaid': 'unpaid',
    'partly_paid': 'partlyPaid',
    'paid': 'paid',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum
    object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum.valueOf(
        _fromWire[serialized] ?? (serialized is String ? serialized : ''),
      );
}

class _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest
    extends AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest {
  @override
  final String id;
  @override
  final DateTime cutoff;
  @override
  final String commission;
  @override
  final String discountShare;
  @override
  final String exceptions;
  @override
  final String totalDue;
  @override
  final AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum?
  status;

  factory _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest([
    void Function(
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder,
    )?
    updates,
  ]) =>
      (AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest._({
    required this.id,
    required this.cutoff,
    required this.commission,
    required this.discountShare,
    required this.exceptions,
    required this.totalDue,
    this.status,
  }) : super._();
  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest rebuild(
    void Function(
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder
  toBuilder() =>
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest &&
        id == other.id &&
        cutoff == other.cutoff &&
        commission == other.commission &&
        discountShare == other.discountShare &&
        exceptions == other.exceptions &&
        totalDue == other.totalDue &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cutoff.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, discountShare.hashCode);
    _$hash = $jc(_$hash, exceptions.hashCode);
    _$hash = $jc(_$hash, totalDue.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
          )
          ..add('id', id)
          ..add('cutoff', cutoff)
          ..add('commission', commission)
          ..add('discountShare', discountShare)
          ..add('exceptions', exceptions)
          ..add('totalDue', totalDue)
          ..add('status', status))
        .toString();
  }
}

class AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder
    implements
        Builder<
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest,
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder
        > {
  _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _cutoff;
  DateTime? get cutoff => _$this._cutoff;
  set cutoff(DateTime? cutoff) => _$this._cutoff = cutoff;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  String? _discountShare;
  String? get discountShare => _$this._discountShare;
  set discountShare(String? discountShare) =>
      _$this._discountShare = discountShare;

  String? _exceptions;
  String? get exceptions => _$this._exceptions;
  set exceptions(String? exceptions) => _$this._exceptions = exceptions;

  String? _totalDue;
  String? get totalDue => _$this._totalDue;
  set totalDue(String? totalDue) => _$this._totalDue = totalDue;

  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum? _status;
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum?
  get status => _$this._status;
  set status(
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestStatusEnum? status,
  ) => _$this._status = status;

  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder() {
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest._defaults(this);
  }

  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cutoff = $v.cutoff;
      _commission = $v.commission;
      _discountShare = $v.discountShare;
      _exceptions = $v.exceptions;
      _totalDue = $v.totalDue;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest other,
  ) {
    _$v = other as _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest;
  }

  @override
  void update(
    void Function(
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest build() => _build();

  _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'id',
          ),
          cutoff: BuiltValueNullFieldError.checkNotNull(
            cutoff,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'cutoff',
          ),
          commission: BuiltValueNullFieldError.checkNotNull(
            commission,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'commission',
          ),
          discountShare: BuiltValueNullFieldError.checkNotNull(
            discountShare,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'discountShare',
          ),
          exceptions: BuiltValueNullFieldError.checkNotNull(
            exceptions,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'exceptions',
          ),
          totalDue: BuiltValueNullFieldError.checkNotNull(
            totalDue,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'totalDue',
          ),
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
