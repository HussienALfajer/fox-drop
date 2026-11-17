// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_money_preview_body_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTicketMoneyPreviewBodyDtoResponsibleEnum
_$adminTicketMoneyPreviewBodyDtoResponsibleEnum_restaurant =
    const AdminTicketMoneyPreviewBodyDtoResponsibleEnum._('restaurant');
const AdminTicketMoneyPreviewBodyDtoResponsibleEnum
_$adminTicketMoneyPreviewBodyDtoResponsibleEnum_captain =
    const AdminTicketMoneyPreviewBodyDtoResponsibleEnum._('captain');
const AdminTicketMoneyPreviewBodyDtoResponsibleEnum
_$adminTicketMoneyPreviewBodyDtoResponsibleEnum_customer =
    const AdminTicketMoneyPreviewBodyDtoResponsibleEnum._('customer');
const AdminTicketMoneyPreviewBodyDtoResponsibleEnum
_$adminTicketMoneyPreviewBodyDtoResponsibleEnum_platform =
    const AdminTicketMoneyPreviewBodyDtoResponsibleEnum._('platform');

AdminTicketMoneyPreviewBodyDtoResponsibleEnum
_$adminTicketMoneyPreviewBodyDtoResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_restaurant;
    case 'captain':
      return _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_captain;
    case 'customer':
      return _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_customer;
    case 'platform':
      return _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketMoneyPreviewBodyDtoResponsibleEnum>
_$adminTicketMoneyPreviewBodyDtoResponsibleEnumValues =
    BuiltSet<AdminTicketMoneyPreviewBodyDtoResponsibleEnum>(
      const <AdminTicketMoneyPreviewBodyDtoResponsibleEnum>[
        _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_restaurant,
        _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_captain,
        _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_customer,
        _$adminTicketMoneyPreviewBodyDtoResponsibleEnum_platform,
      ],
    );

Serializer<AdminTicketMoneyPreviewBodyDtoResponsibleEnum>
_$adminTicketMoneyPreviewBodyDtoResponsibleEnumSerializer =
    _$AdminTicketMoneyPreviewBodyDtoResponsibleEnumSerializer();

class _$AdminTicketMoneyPreviewBodyDtoResponsibleEnumSerializer
    implements
        PrimitiveSerializer<AdminTicketMoneyPreviewBodyDtoResponsibleEnum> {
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
    AdminTicketMoneyPreviewBodyDtoResponsibleEnum,
  ];
  @override
  final String wireName = 'AdminTicketMoneyPreviewBodyDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketMoneyPreviewBodyDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketMoneyPreviewBodyDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketMoneyPreviewBodyDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketMoneyPreviewBodyDto extends AdminTicketMoneyPreviewBodyDto {
  @override
  final String cityId;
  @override
  final AdminTicketMoneyPreviewBodyDtoResponsibleEnum responsible;
  @override
  final BuiltList<AdminTicketMoneyPreviewBodyDtoAffectedInner> affected;
  @override
  final String? shortAmount;
  @override
  final bool code;
  @override
  final bool? redelivery;

  factory _$AdminTicketMoneyPreviewBodyDto([
    void Function(AdminTicketMoneyPreviewBodyDtoBuilder)? updates,
  ]) => (AdminTicketMoneyPreviewBodyDtoBuilder()..update(updates))._build();

  _$AdminTicketMoneyPreviewBodyDto._({
    required this.cityId,
    required this.responsible,
    required this.affected,
    this.shortAmount,
    required this.code,
    this.redelivery,
  }) : super._();
  @override
  AdminTicketMoneyPreviewBodyDto rebuild(
    void Function(AdminTicketMoneyPreviewBodyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketMoneyPreviewBodyDtoBuilder toBuilder() =>
      AdminTicketMoneyPreviewBodyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketMoneyPreviewBodyDto &&
        cityId == other.cityId &&
        responsible == other.responsible &&
        affected == other.affected &&
        shortAmount == other.shortAmount &&
        code == other.code &&
        redelivery == other.redelivery;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, affected.hashCode);
    _$hash = $jc(_$hash, shortAmount.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, redelivery.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketMoneyPreviewBodyDto')
          ..add('cityId', cityId)
          ..add('responsible', responsible)
          ..add('affected', affected)
          ..add('shortAmount', shortAmount)
          ..add('code', code)
          ..add('redelivery', redelivery))
        .toString();
  }
}

class AdminTicketMoneyPreviewBodyDtoBuilder
    implements
        Builder<
          AdminTicketMoneyPreviewBodyDto,
          AdminTicketMoneyPreviewBodyDtoBuilder
        > {
  _$AdminTicketMoneyPreviewBodyDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminTicketMoneyPreviewBodyDtoResponsibleEnum? _responsible;
  AdminTicketMoneyPreviewBodyDtoResponsibleEnum? get responsible =>
      _$this._responsible;
  set responsible(AdminTicketMoneyPreviewBodyDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  ListBuilder<AdminTicketMoneyPreviewBodyDtoAffectedInner>? _affected;
  ListBuilder<AdminTicketMoneyPreviewBodyDtoAffectedInner> get affected =>
      _$this._affected ??=
          ListBuilder<AdminTicketMoneyPreviewBodyDtoAffectedInner>();
  set affected(
    ListBuilder<AdminTicketMoneyPreviewBodyDtoAffectedInner>? affected,
  ) => _$this._affected = affected;

  String? _shortAmount;
  String? get shortAmount => _$this._shortAmount;
  set shortAmount(String? shortAmount) => _$this._shortAmount = shortAmount;

  bool? _code;
  bool? get code => _$this._code;
  set code(bool? code) => _$this._code = code;

  bool? _redelivery;
  bool? get redelivery => _$this._redelivery;
  set redelivery(bool? redelivery) => _$this._redelivery = redelivery;

  AdminTicketMoneyPreviewBodyDtoBuilder() {
    AdminTicketMoneyPreviewBodyDto._defaults(this);
  }

  AdminTicketMoneyPreviewBodyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _responsible = $v.responsible;
      _affected = $v.affected.toBuilder();
      _shortAmount = $v.shortAmount;
      _code = $v.code;
      _redelivery = $v.redelivery;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketMoneyPreviewBodyDto other) {
    _$v = other as _$AdminTicketMoneyPreviewBodyDto;
  }

  @override
  void update(void Function(AdminTicketMoneyPreviewBodyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketMoneyPreviewBodyDto build() => _build();

  _$AdminTicketMoneyPreviewBodyDto _build() {
    _$AdminTicketMoneyPreviewBodyDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketMoneyPreviewBodyDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminTicketMoneyPreviewBodyDto',
              'cityId',
            ),
            responsible: BuiltValueNullFieldError.checkNotNull(
              responsible,
              r'AdminTicketMoneyPreviewBodyDto',
              'responsible',
            ),
            affected: affected.build(),
            shortAmount: shortAmount,
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'AdminTicketMoneyPreviewBodyDto',
              'code',
            ),
            redelivery: redelivery,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'affected';
        affected.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketMoneyPreviewBodyDto',
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
