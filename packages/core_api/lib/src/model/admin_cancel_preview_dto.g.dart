// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_preview_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCancelPreviewDtoResponsibleEnum
_$adminCancelPreviewDtoResponsibleEnum_restaurant =
    const AdminCancelPreviewDtoResponsibleEnum._('restaurant');
const AdminCancelPreviewDtoResponsibleEnum
_$adminCancelPreviewDtoResponsibleEnum_captain =
    const AdminCancelPreviewDtoResponsibleEnum._('captain');
const AdminCancelPreviewDtoResponsibleEnum
_$adminCancelPreviewDtoResponsibleEnum_customer =
    const AdminCancelPreviewDtoResponsibleEnum._('customer');
const AdminCancelPreviewDtoResponsibleEnum
_$adminCancelPreviewDtoResponsibleEnum_platform =
    const AdminCancelPreviewDtoResponsibleEnum._('platform');

AdminCancelPreviewDtoResponsibleEnum
_$adminCancelPreviewDtoResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminCancelPreviewDtoResponsibleEnum_restaurant;
    case 'captain':
      return _$adminCancelPreviewDtoResponsibleEnum_captain;
    case 'customer':
      return _$adminCancelPreviewDtoResponsibleEnum_customer;
    case 'platform':
      return _$adminCancelPreviewDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCancelPreviewDtoResponsibleEnum>
_$adminCancelPreviewDtoResponsibleEnumValues =
    BuiltSet<AdminCancelPreviewDtoResponsibleEnum>(
      const <AdminCancelPreviewDtoResponsibleEnum>[
        _$adminCancelPreviewDtoResponsibleEnum_restaurant,
        _$adminCancelPreviewDtoResponsibleEnum_captain,
        _$adminCancelPreviewDtoResponsibleEnum_customer,
        _$adminCancelPreviewDtoResponsibleEnum_platform,
      ],
    );

const AdminCancelPreviewDtoCashEnum _$adminCancelPreviewDtoCashEnum_returned =
    const AdminCancelPreviewDtoCashEnum._('returned');
const AdminCancelPreviewDtoCashEnum
_$adminCancelPreviewDtoCashEnum_notReturned =
    const AdminCancelPreviewDtoCashEnum._('notReturned');
const AdminCancelPreviewDtoCashEnum _$adminCancelPreviewDtoCashEnum_notPaid =
    const AdminCancelPreviewDtoCashEnum._('notPaid');

AdminCancelPreviewDtoCashEnum _$adminCancelPreviewDtoCashEnumValueOf(
  String name,
) {
  switch (name) {
    case 'returned':
      return _$adminCancelPreviewDtoCashEnum_returned;
    case 'notReturned':
      return _$adminCancelPreviewDtoCashEnum_notReturned;
    case 'notPaid':
      return _$adminCancelPreviewDtoCashEnum_notPaid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCancelPreviewDtoCashEnum>
_$adminCancelPreviewDtoCashEnumValues = BuiltSet<AdminCancelPreviewDtoCashEnum>(
  const <AdminCancelPreviewDtoCashEnum>[
    _$adminCancelPreviewDtoCashEnum_returned,
    _$adminCancelPreviewDtoCashEnum_notReturned,
    _$adminCancelPreviewDtoCashEnum_notPaid,
  ],
);

Serializer<AdminCancelPreviewDtoResponsibleEnum>
_$adminCancelPreviewDtoResponsibleEnumSerializer =
    _$AdminCancelPreviewDtoResponsibleEnumSerializer();
Serializer<AdminCancelPreviewDtoCashEnum>
_$adminCancelPreviewDtoCashEnumSerializer =
    _$AdminCancelPreviewDtoCashEnumSerializer();

class _$AdminCancelPreviewDtoResponsibleEnumSerializer
    implements PrimitiveSerializer<AdminCancelPreviewDtoResponsibleEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminCancelPreviewDtoResponsibleEnum,
  ];
  @override
  final String wireName = 'AdminCancelPreviewDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelPreviewDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCancelPreviewDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCancelPreviewDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCancelPreviewDtoCashEnumSerializer
    implements PrimitiveSerializer<AdminCancelPreviewDtoCashEnum> {
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
  final Iterable<Type> types = const <Type>[AdminCancelPreviewDtoCashEnum];
  @override
  final String wireName = 'AdminCancelPreviewDtoCashEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelPreviewDtoCashEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCancelPreviewDtoCashEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCancelPreviewDtoCashEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCancelPreviewDto extends AdminCancelPreviewDto {
  @override
  final String? cancellation;
  @override
  final AdminCancelPreviewDtoResponsibleEnum responsible;
  @override
  final bool foodPrepared;
  @override
  final bool compensateCaptain;
  @override
  final AdminCancelPreviewDtoCashEnum? cash;

  factory _$AdminCancelPreviewDto([
    void Function(AdminCancelPreviewDtoBuilder)? updates,
  ]) => (AdminCancelPreviewDtoBuilder()..update(updates))._build();

  _$AdminCancelPreviewDto._({
    this.cancellation,
    required this.responsible,
    required this.foodPrepared,
    required this.compensateCaptain,
    this.cash,
  }) : super._();
  @override
  AdminCancelPreviewDto rebuild(
    void Function(AdminCancelPreviewDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCancelPreviewDtoBuilder toBuilder() =>
      AdminCancelPreviewDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancelPreviewDto &&
        cancellation == other.cancellation &&
        responsible == other.responsible &&
        foodPrepared == other.foodPrepared &&
        compensateCaptain == other.compensateCaptain &&
        cash == other.cash;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cancellation.hashCode);
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, foodPrepared.hashCode);
    _$hash = $jc(_$hash, compensateCaptain.hashCode);
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCancelPreviewDto')
          ..add('cancellation', cancellation)
          ..add('responsible', responsible)
          ..add('foodPrepared', foodPrepared)
          ..add('compensateCaptain', compensateCaptain)
          ..add('cash', cash))
        .toString();
  }
}

class AdminCancelPreviewDtoBuilder
    implements Builder<AdminCancelPreviewDto, AdminCancelPreviewDtoBuilder> {
  _$AdminCancelPreviewDto? _$v;

  String? _cancellation;
  String? get cancellation => _$this._cancellation;
  set cancellation(String? cancellation) => _$this._cancellation = cancellation;

  AdminCancelPreviewDtoResponsibleEnum? _responsible;
  AdminCancelPreviewDtoResponsibleEnum? get responsible => _$this._responsible;
  set responsible(AdminCancelPreviewDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  bool? _foodPrepared;
  bool? get foodPrepared => _$this._foodPrepared;
  set foodPrepared(bool? foodPrepared) => _$this._foodPrepared = foodPrepared;

  bool? _compensateCaptain;
  bool? get compensateCaptain => _$this._compensateCaptain;
  set compensateCaptain(bool? compensateCaptain) =>
      _$this._compensateCaptain = compensateCaptain;

  AdminCancelPreviewDtoCashEnum? _cash;
  AdminCancelPreviewDtoCashEnum? get cash => _$this._cash;
  set cash(AdminCancelPreviewDtoCashEnum? cash) => _$this._cash = cash;

  AdminCancelPreviewDtoBuilder() {
    AdminCancelPreviewDto._defaults(this);
  }

  AdminCancelPreviewDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cancellation = $v.cancellation;
      _responsible = $v.responsible;
      _foodPrepared = $v.foodPrepared;
      _compensateCaptain = $v.compensateCaptain;
      _cash = $v.cash;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCancelPreviewDto other) {
    _$v = other as _$AdminCancelPreviewDto;
  }

  @override
  void update(void Function(AdminCancelPreviewDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancelPreviewDto build() => _build();

  _$AdminCancelPreviewDto _build() {
    final _$result =
        _$v ??
        _$AdminCancelPreviewDto._(
          cancellation: cancellation,
          responsible: BuiltValueNullFieldError.checkNotNull(
            responsible,
            r'AdminCancelPreviewDto',
            'responsible',
          ),
          foodPrepared: BuiltValueNullFieldError.checkNotNull(
            foodPrepared,
            r'AdminCancelPreviewDto',
            'foodPrepared',
          ),
          compensateCaptain: BuiltValueNullFieldError.checkNotNull(
            compensateCaptain,
            r'AdminCancelPreviewDto',
            'compensateCaptain',
          ),
          cash: cash,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
