// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCancelDtoResponsibleEnum _$adminCancelDtoResponsibleEnum_restaurant =
    const AdminCancelDtoResponsibleEnum._('restaurant');
const AdminCancelDtoResponsibleEnum _$adminCancelDtoResponsibleEnum_captain =
    const AdminCancelDtoResponsibleEnum._('captain');
const AdminCancelDtoResponsibleEnum _$adminCancelDtoResponsibleEnum_customer =
    const AdminCancelDtoResponsibleEnum._('customer');
const AdminCancelDtoResponsibleEnum _$adminCancelDtoResponsibleEnum_platform =
    const AdminCancelDtoResponsibleEnum._('platform');

AdminCancelDtoResponsibleEnum _$adminCancelDtoResponsibleEnumValueOf(
  String name,
) {
  switch (name) {
    case 'restaurant':
      return _$adminCancelDtoResponsibleEnum_restaurant;
    case 'captain':
      return _$adminCancelDtoResponsibleEnum_captain;
    case 'customer':
      return _$adminCancelDtoResponsibleEnum_customer;
    case 'platform':
      return _$adminCancelDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCancelDtoResponsibleEnum>
_$adminCancelDtoResponsibleEnumValues = BuiltSet<AdminCancelDtoResponsibleEnum>(
  const <AdminCancelDtoResponsibleEnum>[
    _$adminCancelDtoResponsibleEnum_restaurant,
    _$adminCancelDtoResponsibleEnum_captain,
    _$adminCancelDtoResponsibleEnum_customer,
    _$adminCancelDtoResponsibleEnum_platform,
  ],
);

const AdminCancelDtoCashEnum _$adminCancelDtoCashEnum_returned =
    const AdminCancelDtoCashEnum._('returned');
const AdminCancelDtoCashEnum _$adminCancelDtoCashEnum_notReturned =
    const AdminCancelDtoCashEnum._('notReturned');
const AdminCancelDtoCashEnum _$adminCancelDtoCashEnum_notPaid =
    const AdminCancelDtoCashEnum._('notPaid');

AdminCancelDtoCashEnum _$adminCancelDtoCashEnumValueOf(String name) {
  switch (name) {
    case 'returned':
      return _$adminCancelDtoCashEnum_returned;
    case 'notReturned':
      return _$adminCancelDtoCashEnum_notReturned;
    case 'notPaid':
      return _$adminCancelDtoCashEnum_notPaid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCancelDtoCashEnum> _$adminCancelDtoCashEnumValues =
    BuiltSet<AdminCancelDtoCashEnum>(const <AdminCancelDtoCashEnum>[
      _$adminCancelDtoCashEnum_returned,
      _$adminCancelDtoCashEnum_notReturned,
      _$adminCancelDtoCashEnum_notPaid,
    ]);

Serializer<AdminCancelDtoResponsibleEnum>
_$adminCancelDtoResponsibleEnumSerializer =
    _$AdminCancelDtoResponsibleEnumSerializer();
Serializer<AdminCancelDtoCashEnum> _$adminCancelDtoCashEnumSerializer =
    _$AdminCancelDtoCashEnumSerializer();

class _$AdminCancelDtoResponsibleEnumSerializer
    implements PrimitiveSerializer<AdminCancelDtoResponsibleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminCancelDtoResponsibleEnum];
  @override
  final String wireName = 'AdminCancelDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCancelDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCancelDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCancelDtoCashEnumSerializer
    implements PrimitiveSerializer<AdminCancelDtoCashEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'returned': 'returned',
    'notReturned': 'not_returned',
    'notPaid': 'not_paid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'returned': 'returned',
    'not_returned': 'notReturned',
    'not_paid': 'notPaid',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminCancelDtoCashEnum];
  @override
  final String wireName = 'AdminCancelDtoCashEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelDtoCashEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCancelDtoCashEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCancelDtoCashEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCancelDto extends AdminCancelDto {
  @override
  final String cancellation;
  @override
  final AdminCancelDtoResponsibleEnum responsible;
  @override
  final bool foodPrepared;
  @override
  final bool compensateCaptain;
  @override
  final AdminCancelDtoCashEnum? cash;
  @override
  final String reason;

  factory _$AdminCancelDto([void Function(AdminCancelDtoBuilder)? updates]) =>
      (AdminCancelDtoBuilder()..update(updates))._build();

  _$AdminCancelDto._({
    required this.cancellation,
    required this.responsible,
    required this.foodPrepared,
    required this.compensateCaptain,
    this.cash,
    required this.reason,
  }) : super._();
  @override
  AdminCancelDto rebuild(void Function(AdminCancelDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminCancelDtoBuilder toBuilder() => AdminCancelDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancelDto &&
        cancellation == other.cancellation &&
        responsible == other.responsible &&
        foodPrepared == other.foodPrepared &&
        compensateCaptain == other.compensateCaptain &&
        cash == other.cash &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cancellation.hashCode);
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, foodPrepared.hashCode);
    _$hash = $jc(_$hash, compensateCaptain.hashCode);
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCancelDto')
          ..add('cancellation', cancellation)
          ..add('responsible', responsible)
          ..add('foodPrepared', foodPrepared)
          ..add('compensateCaptain', compensateCaptain)
          ..add('cash', cash)
          ..add('reason', reason))
        .toString();
  }
}

class AdminCancelDtoBuilder
    implements Builder<AdminCancelDto, AdminCancelDtoBuilder> {
  _$AdminCancelDto? _$v;

  String? _cancellation;
  String? get cancellation => _$this._cancellation;
  set cancellation(String? cancellation) => _$this._cancellation = cancellation;

  AdminCancelDtoResponsibleEnum? _responsible;
  AdminCancelDtoResponsibleEnum? get responsible => _$this._responsible;
  set responsible(AdminCancelDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  bool? _foodPrepared;
  bool? get foodPrepared => _$this._foodPrepared;
  set foodPrepared(bool? foodPrepared) => _$this._foodPrepared = foodPrepared;

  bool? _compensateCaptain;
  bool? get compensateCaptain => _$this._compensateCaptain;
  set compensateCaptain(bool? compensateCaptain) =>
      _$this._compensateCaptain = compensateCaptain;

  AdminCancelDtoCashEnum? _cash;
  AdminCancelDtoCashEnum? get cash => _$this._cash;
  set cash(AdminCancelDtoCashEnum? cash) => _$this._cash = cash;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCancelDtoBuilder() {
    AdminCancelDto._defaults(this);
  }

  AdminCancelDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cancellation = $v.cancellation;
      _responsible = $v.responsible;
      _foodPrepared = $v.foodPrepared;
      _compensateCaptain = $v.compensateCaptain;
      _cash = $v.cash;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCancelDto other) {
    _$v = other as _$AdminCancelDto;
  }

  @override
  void update(void Function(AdminCancelDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancelDto build() => _build();

  _$AdminCancelDto _build() {
    final _$result =
        _$v ??
        _$AdminCancelDto._(
          cancellation: BuiltValueNullFieldError.checkNotNull(
            cancellation,
            r'AdminCancelDto',
            'cancellation',
          ),
          responsible: BuiltValueNullFieldError.checkNotNull(
            responsible,
            r'AdminCancelDto',
            'responsible',
          ),
          foodPrepared: BuiltValueNullFieldError.checkNotNull(
            foodPrepared,
            r'AdminCancelDto',
            'foodPrepared',
          ),
          compensateCaptain: BuiltValueNullFieldError.checkNotNull(
            compensateCaptain,
            r'AdminCancelDto',
            'compensateCaptain',
          ),
          cash: cash,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCancelDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
