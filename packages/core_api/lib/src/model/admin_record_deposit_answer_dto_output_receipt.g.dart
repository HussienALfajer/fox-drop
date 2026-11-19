// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_deposit_answer_dto_output_receipt.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum
_$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainHandIn =
    const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum._('captainHandIn');
const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum
_$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainReimbursement =
    const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum._(
      'captainReimbursement',
    );
const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum
_$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainPayout =
    const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum._('captainPayout');
const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum
_$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainEarningsCollection =
    const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum._(
      'captainEarningsCollection',
    );
const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum
_$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainDeposit =
    const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum._('captainDeposit');

AdminRecordDepositAnswerDtoOutputReceiptTypeEnum
_$adminRecordDepositAnswerDtoOutputReceiptTypeEnumValueOf(String name) {
  switch (name) {
    case 'captainHandIn':
      return _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainHandIn;
    case 'captainReimbursement':
      return _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainReimbursement;
    case 'captainPayout':
      return _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainPayout;
    case 'captainEarningsCollection':
      return _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainEarningsCollection;
    case 'captainDeposit':
      return _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainDeposit;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRecordDepositAnswerDtoOutputReceiptTypeEnum>
_$adminRecordDepositAnswerDtoOutputReceiptTypeEnumValues =
    BuiltSet<AdminRecordDepositAnswerDtoOutputReceiptTypeEnum>(const <
      AdminRecordDepositAnswerDtoOutputReceiptTypeEnum
    >[
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainHandIn,
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainReimbursement,
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainPayout,
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainEarningsCollection,
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainDeposit,
    ]);

Serializer<AdminRecordDepositAnswerDtoOutputReceiptTypeEnum>
_$adminRecordDepositAnswerDtoOutputReceiptTypeEnumSerializer =
    _$AdminRecordDepositAnswerDtoOutputReceiptTypeEnumSerializer();

class _$AdminRecordDepositAnswerDtoOutputReceiptTypeEnumSerializer
    implements
        PrimitiveSerializer<AdminRecordDepositAnswerDtoOutputReceiptTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captainHandIn': 'captain_hand_in',
    'captainReimbursement': 'captain_reimbursement',
    'captainPayout': 'captain_payout',
    'captainEarningsCollection': 'captain_earnings_collection',
    'captainDeposit': 'captain_deposit',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain_hand_in': 'captainHandIn',
    'captain_reimbursement': 'captainReimbursement',
    'captain_payout': 'captainPayout',
    'captain_earnings_collection': 'captainEarningsCollection',
    'captain_deposit': 'captainDeposit',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRecordDepositAnswerDtoOutputReceiptTypeEnum,
  ];
  @override
  final String wireName = 'AdminRecordDepositAnswerDtoOutputReceiptTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRecordDepositAnswerDtoOutputReceiptTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRecordDepositAnswerDtoOutputReceiptTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRecordDepositAnswerDtoOutputReceiptTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRecordDepositAnswerDtoOutputReceipt
    extends AdminRecordDepositAnswerDtoOutputReceipt {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String number;
  @override
  final AdminRecordDepositAnswerDtoOutputReceiptTypeEnum type;
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
  final BuiltList<AdminRecordDepositAnswerDtoOutputReceiptConversionsInner>
  conversions;
  @override
  final BuiltList<AdminRecordDepositAnswerDtoOutputReceiptLinesInner> lines;

  factory _$AdminRecordDepositAnswerDtoOutputReceipt([
    void Function(AdminRecordDepositAnswerDtoOutputReceiptBuilder)? updates,
  ]) => (AdminRecordDepositAnswerDtoOutputReceiptBuilder()..update(updates))
      ._build();

  _$AdminRecordDepositAnswerDtoOutputReceipt._({
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
  AdminRecordDepositAnswerDtoOutputReceipt rebuild(
    void Function(AdminRecordDepositAnswerDtoOutputReceiptBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordDepositAnswerDtoOutputReceiptBuilder toBuilder() =>
      AdminRecordDepositAnswerDtoOutputReceiptBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordDepositAnswerDtoOutputReceipt &&
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
            r'AdminRecordDepositAnswerDtoOutputReceipt',
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

class AdminRecordDepositAnswerDtoOutputReceiptBuilder
    implements
        Builder<
          AdminRecordDepositAnswerDtoOutputReceipt,
          AdminRecordDepositAnswerDtoOutputReceiptBuilder
        > {
  _$AdminRecordDepositAnswerDtoOutputReceipt? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  AdminRecordDepositAnswerDtoOutputReceiptTypeEnum? _type;
  AdminRecordDepositAnswerDtoOutputReceiptTypeEnum? get type => _$this._type;
  set type(AdminRecordDepositAnswerDtoOutputReceiptTypeEnum? type) =>
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

  ListBuilder<AdminRecordDepositAnswerDtoOutputReceiptConversionsInner>?
  _conversions;
  ListBuilder<AdminRecordDepositAnswerDtoOutputReceiptConversionsInner>
  get conversions => _$this._conversions ??=
      ListBuilder<AdminRecordDepositAnswerDtoOutputReceiptConversionsInner>();
  set conversions(
    ListBuilder<AdminRecordDepositAnswerDtoOutputReceiptConversionsInner>?
    conversions,
  ) => _$this._conversions = conversions;

  ListBuilder<AdminRecordDepositAnswerDtoOutputReceiptLinesInner>? _lines;
  ListBuilder<AdminRecordDepositAnswerDtoOutputReceiptLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<AdminRecordDepositAnswerDtoOutputReceiptLinesInner>();
  set lines(
    ListBuilder<AdminRecordDepositAnswerDtoOutputReceiptLinesInner>? lines,
  ) => _$this._lines = lines;

  AdminRecordDepositAnswerDtoOutputReceiptBuilder() {
    AdminRecordDepositAnswerDtoOutputReceipt._defaults(this);
  }

  AdminRecordDepositAnswerDtoOutputReceiptBuilder get _$this {
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
  void replace(AdminRecordDepositAnswerDtoOutputReceipt other) {
    _$v = other as _$AdminRecordDepositAnswerDtoOutputReceipt;
  }

  @override
  void update(
    void Function(AdminRecordDepositAnswerDtoOutputReceiptBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordDepositAnswerDtoOutputReceipt build() => _build();

  _$AdminRecordDepositAnswerDtoOutputReceipt _build() {
    _$AdminRecordDepositAnswerDtoOutputReceipt _$result;
    try {
      _$result =
          _$v ??
          _$AdminRecordDepositAnswerDtoOutputReceipt._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminRecordDepositAnswerDtoOutputReceipt',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminRecordDepositAnswerDtoOutputReceipt',
              'cityId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminRecordDepositAnswerDtoOutputReceipt',
              'number',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminRecordDepositAnswerDtoOutputReceipt',
              'type',
            ),
            sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId,
              r'AdminRecordDepositAnswerDtoOutputReceipt',
              'sessionId',
            ),
            cashierId: BuiltValueNullFieldError.checkNotNull(
              cashierId,
              r'AdminRecordDepositAnswerDtoOutputReceipt',
              'cashierId',
            ),
            cashierName: cashierName,
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminRecordDepositAnswerDtoOutputReceipt',
              'captainId',
            ),
            captainName: BuiltValueNullFieldError.checkNotNull(
              captainName,
              r'AdminRecordDepositAnswerDtoOutputReceipt',
              'captainName',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminRecordDepositAnswerDtoOutputReceipt',
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
          r'AdminRecordDepositAnswerDtoOutputReceipt',
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
