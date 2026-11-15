// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_dto_output_receipts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSettlementDtoOutputReceiptsInnerTypeEnum
_$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainHandIn =
    const AdminSettlementDtoOutputReceiptsInnerTypeEnum._('captainHandIn');
const AdminSettlementDtoOutputReceiptsInnerTypeEnum
_$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainReimbursement =
    const AdminSettlementDtoOutputReceiptsInnerTypeEnum._(
      'captainReimbursement',
    );
const AdminSettlementDtoOutputReceiptsInnerTypeEnum
_$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainPayout =
    const AdminSettlementDtoOutputReceiptsInnerTypeEnum._('captainPayout');
const AdminSettlementDtoOutputReceiptsInnerTypeEnum
_$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainEarningsCollection =
    const AdminSettlementDtoOutputReceiptsInnerTypeEnum._(
      'captainEarningsCollection',
    );

AdminSettlementDtoOutputReceiptsInnerTypeEnum
_$adminSettlementDtoOutputReceiptsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'captainHandIn':
      return _$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainHandIn;
    case 'captainReimbursement':
      return _$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainReimbursement;
    case 'captainPayout':
      return _$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainPayout;
    case 'captainEarningsCollection':
      return _$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainEarningsCollection;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSettlementDtoOutputReceiptsInnerTypeEnum>
_$adminSettlementDtoOutputReceiptsInnerTypeEnumValues =
    BuiltSet<AdminSettlementDtoOutputReceiptsInnerTypeEnum>(const <
      AdminSettlementDtoOutputReceiptsInnerTypeEnum
    >[
      _$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainHandIn,
      _$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainReimbursement,
      _$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainPayout,
      _$adminSettlementDtoOutputReceiptsInnerTypeEnum_captainEarningsCollection,
    ]);

Serializer<AdminSettlementDtoOutputReceiptsInnerTypeEnum>
_$adminSettlementDtoOutputReceiptsInnerTypeEnumSerializer =
    _$AdminSettlementDtoOutputReceiptsInnerTypeEnumSerializer();

class _$AdminSettlementDtoOutputReceiptsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<AdminSettlementDtoOutputReceiptsInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captainHandIn': 'captain_hand_in',
    'captainReimbursement': 'captain_reimbursement',
    'captainPayout': 'captain_payout',
    'captainEarningsCollection': 'captain_earnings_collection',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain_hand_in': 'captainHandIn',
    'captain_reimbursement': 'captainReimbursement',
    'captain_payout': 'captainPayout',
    'captain_earnings_collection': 'captainEarningsCollection',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSettlementDtoOutputReceiptsInnerTypeEnum,
  ];
  @override
  final String wireName = 'AdminSettlementDtoOutputReceiptsInnerTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementDtoOutputReceiptsInnerTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSettlementDtoOutputReceiptsInnerTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSettlementDtoOutputReceiptsInnerTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSettlementDtoOutputReceiptsInner
    extends AdminSettlementDtoOutputReceiptsInner {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String number;
  @override
  final AdminSettlementDtoOutputReceiptsInnerTypeEnum type;
  @override
  final String sessionId;
  @override
  final String cashierId;
  @override
  final String? cashierName;
  @override
  final String captainId;
  @override
  final String captainName;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<AdminSettlementDtoOutputReceiptsInnerConversionsInner>
  conversions;
  @override
  final BuiltList<AdminSettlementDtoOutputReceiptsInnerLinesInner> lines;

  factory _$AdminSettlementDtoOutputReceiptsInner([
    void Function(AdminSettlementDtoOutputReceiptsInnerBuilder)? updates,
  ]) => (AdminSettlementDtoOutputReceiptsInnerBuilder()..update(updates))
      ._build();

  _$AdminSettlementDtoOutputReceiptsInner._({
    required this.id,
    required this.cityId,
    required this.number,
    required this.type,
    required this.sessionId,
    required this.cashierId,
    this.cashierName,
    required this.captainId,
    required this.captainName,
    required this.createdAt,
    required this.conversions,
    required this.lines,
  }) : super._();
  @override
  AdminSettlementDtoOutputReceiptsInner rebuild(
    void Function(AdminSettlementDtoOutputReceiptsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementDtoOutputReceiptsInnerBuilder toBuilder() =>
      AdminSettlementDtoOutputReceiptsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementDtoOutputReceiptsInner &&
        id == other.id &&
        cityId == other.cityId &&
        number == other.number &&
        type == other.type &&
        sessionId == other.sessionId &&
        cashierId == other.cashierId &&
        cashierName == other.cashierName &&
        captainId == other.captainId &&
        captainName == other.captainName &&
        createdAt == other.createdAt &&
        conversions == other.conversions &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, cashierId.hashCode);
    _$hash = $jc(_$hash, cashierName.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, captainName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, conversions.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSettlementDtoOutputReceiptsInner',
          )
          ..add('id', id)
          ..add('cityId', cityId)
          ..add('number', number)
          ..add('type', type)
          ..add('sessionId', sessionId)
          ..add('cashierId', cashierId)
          ..add('cashierName', cashierName)
          ..add('captainId', captainId)
          ..add('captainName', captainName)
          ..add('createdAt', createdAt)
          ..add('conversions', conversions)
          ..add('lines', lines))
        .toString();
  }
}

class AdminSettlementDtoOutputReceiptsInnerBuilder
    implements
        Builder<
          AdminSettlementDtoOutputReceiptsInner,
          AdminSettlementDtoOutputReceiptsInnerBuilder
        > {
  _$AdminSettlementDtoOutputReceiptsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  AdminSettlementDtoOutputReceiptsInnerTypeEnum? _type;
  AdminSettlementDtoOutputReceiptsInnerTypeEnum? get type => _$this._type;
  set type(AdminSettlementDtoOutputReceiptsInnerTypeEnum? type) =>
      _$this._type = type;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _cashierId;
  String? get cashierId => _$this._cashierId;
  set cashierId(String? cashierId) => _$this._cashierId = cashierId;

  String? _cashierName;
  String? get cashierName => _$this._cashierName;
  set cashierName(String? cashierName) => _$this._cashierName = cashierName;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _captainName;
  String? get captainName => _$this._captainName;
  set captainName(String? captainName) => _$this._captainName = captainName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<AdminSettlementDtoOutputReceiptsInnerConversionsInner>?
  _conversions;
  ListBuilder<AdminSettlementDtoOutputReceiptsInnerConversionsInner>
  get conversions => _$this._conversions ??=
      ListBuilder<AdminSettlementDtoOutputReceiptsInnerConversionsInner>();
  set conversions(
    ListBuilder<AdminSettlementDtoOutputReceiptsInnerConversionsInner>?
    conversions,
  ) => _$this._conversions = conversions;

  ListBuilder<AdminSettlementDtoOutputReceiptsInnerLinesInner>? _lines;
  ListBuilder<AdminSettlementDtoOutputReceiptsInnerLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<AdminSettlementDtoOutputReceiptsInnerLinesInner>();
  set lines(
    ListBuilder<AdminSettlementDtoOutputReceiptsInnerLinesInner>? lines,
  ) => _$this._lines = lines;

  AdminSettlementDtoOutputReceiptsInnerBuilder() {
    AdminSettlementDtoOutputReceiptsInner._defaults(this);
  }

  AdminSettlementDtoOutputReceiptsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cityId = $v.cityId;
      _number = $v.number;
      _type = $v.type;
      _sessionId = $v.sessionId;
      _cashierId = $v.cashierId;
      _cashierName = $v.cashierName;
      _captainId = $v.captainId;
      _captainName = $v.captainName;
      _createdAt = $v.createdAt;
      _conversions = $v.conversions.toBuilder();
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementDtoOutputReceiptsInner other) {
    _$v = other as _$AdminSettlementDtoOutputReceiptsInner;
  }

  @override
  void update(
    void Function(AdminSettlementDtoOutputReceiptsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementDtoOutputReceiptsInner build() => _build();

  _$AdminSettlementDtoOutputReceiptsInner _build() {
    _$AdminSettlementDtoOutputReceiptsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminSettlementDtoOutputReceiptsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminSettlementDtoOutputReceiptsInner',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminSettlementDtoOutputReceiptsInner',
              'cityId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminSettlementDtoOutputReceiptsInner',
              'number',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminSettlementDtoOutputReceiptsInner',
              'type',
            ),
            sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId,
              r'AdminSettlementDtoOutputReceiptsInner',
              'sessionId',
            ),
            cashierId: BuiltValueNullFieldError.checkNotNull(
              cashierId,
              r'AdminSettlementDtoOutputReceiptsInner',
              'cashierId',
            ),
            cashierName: cashierName,
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminSettlementDtoOutputReceiptsInner',
              'captainId',
            ),
            captainName: BuiltValueNullFieldError.checkNotNull(
              captainName,
              r'AdminSettlementDtoOutputReceiptsInner',
              'captainName',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminSettlementDtoOutputReceiptsInner',
              'createdAt',
            ),
            conversions: conversions.build(),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'conversions';
        conversions.build();
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSettlementDtoOutputReceiptsInner',
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
