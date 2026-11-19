// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settle_deposit_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSettleDepositDtoSettlementEnum
_$adminSettleDepositDtoSettlementEnum_refunded =
    const AdminSettleDepositDtoSettlementEnum._('refunded');
const AdminSettleDepositDtoSettlementEnum
_$adminSettleDepositDtoSettlementEnum_withheld =
    const AdminSettleDepositDtoSettlementEnum._('withheld');

AdminSettleDepositDtoSettlementEnum
_$adminSettleDepositDtoSettlementEnumValueOf(String name) {
  switch (name) {
    case 'refunded':
      return _$adminSettleDepositDtoSettlementEnum_refunded;
    case 'withheld':
      return _$adminSettleDepositDtoSettlementEnum_withheld;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSettleDepositDtoSettlementEnum>
_$adminSettleDepositDtoSettlementEnumValues =
    BuiltSet<AdminSettleDepositDtoSettlementEnum>(
      const <AdminSettleDepositDtoSettlementEnum>[
        _$adminSettleDepositDtoSettlementEnum_refunded,
        _$adminSettleDepositDtoSettlementEnum_withheld,
      ],
    );

Serializer<AdminSettleDepositDtoSettlementEnum>
_$adminSettleDepositDtoSettlementEnumSerializer =
    _$AdminSettleDepositDtoSettlementEnumSerializer();

class _$AdminSettleDepositDtoSettlementEnumSerializer
    implements PrimitiveSerializer<AdminSettleDepositDtoSettlementEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'refunded': 'refunded',
    'withheld': 'withheld',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'refunded': 'refunded',
    'withheld': 'withheld',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSettleDepositDtoSettlementEnum,
  ];
  @override
  final String wireName = 'AdminSettleDepositDtoSettlementEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSettleDepositDtoSettlementEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSettleDepositDtoSettlementEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSettleDepositDtoSettlementEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSettleDepositDto extends AdminSettleDepositDto {
  @override
  final String cityId;
  @override
  final String applicationId;
  @override
  final AdminSettleDepositDtoSettlementEnum settlement;

  factory _$AdminSettleDepositDto([
    void Function(AdminSettleDepositDtoBuilder)? updates,
  ]) => (AdminSettleDepositDtoBuilder()..update(updates))._build();

  _$AdminSettleDepositDto._({
    required this.cityId,
    required this.applicationId,
    required this.settlement,
  }) : super._();
  @override
  AdminSettleDepositDto rebuild(
    void Function(AdminSettleDepositDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettleDepositDtoBuilder toBuilder() =>
      AdminSettleDepositDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettleDepositDto &&
        cityId == other.cityId &&
        applicationId == other.applicationId &&
        settlement == other.settlement;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, applicationId.hashCode);
    _$hash = $jc(_$hash, settlement.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSettleDepositDto')
          ..add('cityId', cityId)
          ..add('applicationId', applicationId)
          ..add('settlement', settlement))
        .toString();
  }
}

class AdminSettleDepositDtoBuilder
    implements Builder<AdminSettleDepositDto, AdminSettleDepositDtoBuilder> {
  _$AdminSettleDepositDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _applicationId;
  String? get applicationId => _$this._applicationId;
  set applicationId(String? applicationId) =>
      _$this._applicationId = applicationId;

  AdminSettleDepositDtoSettlementEnum? _settlement;
  AdminSettleDepositDtoSettlementEnum? get settlement => _$this._settlement;
  set settlement(AdminSettleDepositDtoSettlementEnum? settlement) =>
      _$this._settlement = settlement;

  AdminSettleDepositDtoBuilder() {
    AdminSettleDepositDto._defaults(this);
  }

  AdminSettleDepositDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _applicationId = $v.applicationId;
      _settlement = $v.settlement;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettleDepositDto other) {
    _$v = other as _$AdminSettleDepositDto;
  }

  @override
  void update(void Function(AdminSettleDepositDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettleDepositDto build() => _build();

  _$AdminSettleDepositDto _build() {
    final _$result =
        _$v ??
        _$AdminSettleDepositDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminSettleDepositDto',
            'cityId',
          ),
          applicationId: BuiltValueNullFieldError.checkNotNull(
            applicationId,
            r'AdminSettleDepositDto',
            'applicationId',
          ),
          settlement: BuiltValueNullFieldError.checkNotNull(
            settlement,
            r'AdminSettleDepositDto',
            'settlement',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
