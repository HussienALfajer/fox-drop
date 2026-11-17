// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_resolve_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTicketResolveDtoResolutionEnum
_$adminTicketResolveDtoResolutionEnum_noneExplained =
    const AdminTicketResolveDtoResolutionEnum._('noneExplained');
const AdminTicketResolveDtoResolutionEnum
_$adminTicketResolveDtoResolutionEnum_compensationCode =
    const AdminTicketResolveDtoResolutionEnum._('compensationCode');
const AdminTicketResolveDtoResolutionEnum
_$adminTicketResolveDtoResolutionEnum_freeRedelivery =
    const AdminTicketResolveDtoResolutionEnum._('freeRedelivery');
const AdminTicketResolveDtoResolutionEnum
_$adminTicketResolveDtoResolutionEnum_priceCorrected =
    const AdminTicketResolveDtoResolutionEnum._('priceCorrected');
const AdminTicketResolveDtoResolutionEnum
_$adminTicketResolveDtoResolutionEnum_priceCorrect =
    const AdminTicketResolveDtoResolutionEnum._('priceCorrect');
const AdminTicketResolveDtoResolutionEnum
_$adminTicketResolveDtoResolutionEnum_captainPaid =
    const AdminTicketResolveDtoResolutionEnum._('captainPaid');
const AdminTicketResolveDtoResolutionEnum
_$adminTicketResolveDtoResolutionEnum_accountsCorrected =
    const AdminTicketResolveDtoResolutionEnum._('accountsCorrected');
const AdminTicketResolveDtoResolutionEnum
_$adminTicketResolveDtoResolutionEnum_paymentCorrect =
    const AdminTicketResolveDtoResolutionEnum._('paymentCorrect');

AdminTicketResolveDtoResolutionEnum
_$adminTicketResolveDtoResolutionEnumValueOf(String name) {
  switch (name) {
    case 'noneExplained':
      return _$adminTicketResolveDtoResolutionEnum_noneExplained;
    case 'compensationCode':
      return _$adminTicketResolveDtoResolutionEnum_compensationCode;
    case 'freeRedelivery':
      return _$adminTicketResolveDtoResolutionEnum_freeRedelivery;
    case 'priceCorrected':
      return _$adminTicketResolveDtoResolutionEnum_priceCorrected;
    case 'priceCorrect':
      return _$adminTicketResolveDtoResolutionEnum_priceCorrect;
    case 'captainPaid':
      return _$adminTicketResolveDtoResolutionEnum_captainPaid;
    case 'accountsCorrected':
      return _$adminTicketResolveDtoResolutionEnum_accountsCorrected;
    case 'paymentCorrect':
      return _$adminTicketResolveDtoResolutionEnum_paymentCorrect;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketResolveDtoResolutionEnum>
_$adminTicketResolveDtoResolutionEnumValues =
    BuiltSet<AdminTicketResolveDtoResolutionEnum>(
      const <AdminTicketResolveDtoResolutionEnum>[
        _$adminTicketResolveDtoResolutionEnum_noneExplained,
        _$adminTicketResolveDtoResolutionEnum_compensationCode,
        _$adminTicketResolveDtoResolutionEnum_freeRedelivery,
        _$adminTicketResolveDtoResolutionEnum_priceCorrected,
        _$adminTicketResolveDtoResolutionEnum_priceCorrect,
        _$adminTicketResolveDtoResolutionEnum_captainPaid,
        _$adminTicketResolveDtoResolutionEnum_accountsCorrected,
        _$adminTicketResolveDtoResolutionEnum_paymentCorrect,
      ],
    );

const AdminTicketResolveDtoResponsibleEnum
_$adminTicketResolveDtoResponsibleEnum_restaurant =
    const AdminTicketResolveDtoResponsibleEnum._('restaurant');
const AdminTicketResolveDtoResponsibleEnum
_$adminTicketResolveDtoResponsibleEnum_captain =
    const AdminTicketResolveDtoResponsibleEnum._('captain');
const AdminTicketResolveDtoResponsibleEnum
_$adminTicketResolveDtoResponsibleEnum_customer =
    const AdminTicketResolveDtoResponsibleEnum._('customer');
const AdminTicketResolveDtoResponsibleEnum
_$adminTicketResolveDtoResponsibleEnum_platform =
    const AdminTicketResolveDtoResponsibleEnum._('platform');

AdminTicketResolveDtoResponsibleEnum
_$adminTicketResolveDtoResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminTicketResolveDtoResponsibleEnum_restaurant;
    case 'captain':
      return _$adminTicketResolveDtoResponsibleEnum_captain;
    case 'customer':
      return _$adminTicketResolveDtoResponsibleEnum_customer;
    case 'platform':
      return _$adminTicketResolveDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketResolveDtoResponsibleEnum>
_$adminTicketResolveDtoResponsibleEnumValues =
    BuiltSet<AdminTicketResolveDtoResponsibleEnum>(
      const <AdminTicketResolveDtoResponsibleEnum>[
        _$adminTicketResolveDtoResponsibleEnum_restaurant,
        _$adminTicketResolveDtoResponsibleEnum_captain,
        _$adminTicketResolveDtoResponsibleEnum_customer,
        _$adminTicketResolveDtoResponsibleEnum_platform,
      ],
    );

Serializer<AdminTicketResolveDtoResolutionEnum>
_$adminTicketResolveDtoResolutionEnumSerializer =
    _$AdminTicketResolveDtoResolutionEnumSerializer();
Serializer<AdminTicketResolveDtoResponsibleEnum>
_$adminTicketResolveDtoResponsibleEnumSerializer =
    _$AdminTicketResolveDtoResponsibleEnumSerializer();

class _$AdminTicketResolveDtoResolutionEnumSerializer
    implements PrimitiveSerializer<AdminTicketResolveDtoResolutionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'noneExplained': 'none_explained',
    'compensationCode': 'compensation_code',
    'freeRedelivery': 'free_redelivery',
    'priceCorrected': 'price_corrected',
    'priceCorrect': 'price_correct',
    'captainPaid': 'captain_paid',
    'accountsCorrected': 'accounts_corrected',
    'paymentCorrect': 'payment_correct',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'none_explained': 'noneExplained',
    'compensation_code': 'compensationCode',
    'free_redelivery': 'freeRedelivery',
    'price_corrected': 'priceCorrected',
    'price_correct': 'priceCorrect',
    'captain_paid': 'captainPaid',
    'accounts_corrected': 'accountsCorrected',
    'payment_correct': 'paymentCorrect',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminTicketResolveDtoResolutionEnum,
  ];
  @override
  final String wireName = 'AdminTicketResolveDtoResolutionEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketResolveDtoResolutionEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketResolveDtoResolutionEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketResolveDtoResolutionEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketResolveDtoResponsibleEnumSerializer
    implements PrimitiveSerializer<AdminTicketResolveDtoResponsibleEnum> {
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
    AdminTicketResolveDtoResponsibleEnum,
  ];
  @override
  final String wireName = 'AdminTicketResolveDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketResolveDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketResolveDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketResolveDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketResolveDto extends AdminTicketResolveDto {
  @override
  final String cityId;
  @override
  final AdminTicketResolveDtoResolutionEnum resolution;
  @override
  final AdminTicketResolveDtoResponsibleEnum? responsible;
  @override
  final String message;
  @override
  final BuiltList<AdminTicketCorrectionPreviewDtoReceivedLinesInner>?
  receivedLines;
  @override
  final BuiltList<AdminTicketMoneyPreviewBodyDtoAffectedInner>? affected;
  @override
  final String? shortAmount;
  @override
  final AdminTicketResolveDtoCode? code;
  @override
  final bool? chargePay;

  factory _$AdminTicketResolveDto([
    void Function(AdminTicketResolveDtoBuilder)? updates,
  ]) => (AdminTicketResolveDtoBuilder()..update(updates))._build();

  _$AdminTicketResolveDto._({
    required this.cityId,
    required this.resolution,
    this.responsible,
    required this.message,
    this.receivedLines,
    this.affected,
    this.shortAmount,
    this.code,
    this.chargePay,
  }) : super._();
  @override
  AdminTicketResolveDto rebuild(
    void Function(AdminTicketResolveDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketResolveDtoBuilder toBuilder() =>
      AdminTicketResolveDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketResolveDto &&
        cityId == other.cityId &&
        resolution == other.resolution &&
        responsible == other.responsible &&
        message == other.message &&
        receivedLines == other.receivedLines &&
        affected == other.affected &&
        shortAmount == other.shortAmount &&
        code == other.code &&
        chargePay == other.chargePay;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, resolution.hashCode);
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, receivedLines.hashCode);
    _$hash = $jc(_$hash, affected.hashCode);
    _$hash = $jc(_$hash, shortAmount.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, chargePay.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketResolveDto')
          ..add('cityId', cityId)
          ..add('resolution', resolution)
          ..add('responsible', responsible)
          ..add('message', message)
          ..add('receivedLines', receivedLines)
          ..add('affected', affected)
          ..add('shortAmount', shortAmount)
          ..add('code', code)
          ..add('chargePay', chargePay))
        .toString();
  }
}

class AdminTicketResolveDtoBuilder
    implements Builder<AdminTicketResolveDto, AdminTicketResolveDtoBuilder> {
  _$AdminTicketResolveDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminTicketResolveDtoResolutionEnum? _resolution;
  AdminTicketResolveDtoResolutionEnum? get resolution => _$this._resolution;
  set resolution(AdminTicketResolveDtoResolutionEnum? resolution) =>
      _$this._resolution = resolution;

  AdminTicketResolveDtoResponsibleEnum? _responsible;
  AdminTicketResolveDtoResponsibleEnum? get responsible => _$this._responsible;
  set responsible(AdminTicketResolveDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ListBuilder<AdminTicketCorrectionPreviewDtoReceivedLinesInner>?
  _receivedLines;
  ListBuilder<AdminTicketCorrectionPreviewDtoReceivedLinesInner>
  get receivedLines => _$this._receivedLines ??=
      ListBuilder<AdminTicketCorrectionPreviewDtoReceivedLinesInner>();
  set receivedLines(
    ListBuilder<AdminTicketCorrectionPreviewDtoReceivedLinesInner>?
    receivedLines,
  ) => _$this._receivedLines = receivedLines;

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

  AdminTicketResolveDtoCodeBuilder? _code;
  AdminTicketResolveDtoCodeBuilder get code =>
      _$this._code ??= AdminTicketResolveDtoCodeBuilder();
  set code(AdminTicketResolveDtoCodeBuilder? code) => _$this._code = code;

  bool? _chargePay;
  bool? get chargePay => _$this._chargePay;
  set chargePay(bool? chargePay) => _$this._chargePay = chargePay;

  AdminTicketResolveDtoBuilder() {
    AdminTicketResolveDto._defaults(this);
  }

  AdminTicketResolveDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _resolution = $v.resolution;
      _responsible = $v.responsible;
      _message = $v.message;
      _receivedLines = $v.receivedLines?.toBuilder();
      _affected = $v.affected?.toBuilder();
      _shortAmount = $v.shortAmount;
      _code = $v.code?.toBuilder();
      _chargePay = $v.chargePay;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketResolveDto other) {
    _$v = other as _$AdminTicketResolveDto;
  }

  @override
  void update(void Function(AdminTicketResolveDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketResolveDto build() => _build();

  _$AdminTicketResolveDto _build() {
    _$AdminTicketResolveDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketResolveDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminTicketResolveDto',
              'cityId',
            ),
            resolution: BuiltValueNullFieldError.checkNotNull(
              resolution,
              r'AdminTicketResolveDto',
              'resolution',
            ),
            responsible: responsible,
            message: BuiltValueNullFieldError.checkNotNull(
              message,
              r'AdminTicketResolveDto',
              'message',
            ),
            receivedLines: _receivedLines?.build(),
            affected: _affected?.build(),
            shortAmount: shortAmount,
            code: _code?.build(),
            chargePay: chargePay,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'receivedLines';
        _receivedLines?.build();
        _$failedField = 'affected';
        _affected?.build();

        _$failedField = 'code';
        _code?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketResolveDto',
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
