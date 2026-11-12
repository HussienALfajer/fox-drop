// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_receipt_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReceiptDtoOutputTypeEnum
_$adminReceiptDtoOutputTypeEnum_captainHandIn =
    const AdminReceiptDtoOutputTypeEnum._('captainHandIn');
const AdminReceiptDtoOutputTypeEnum
_$adminReceiptDtoOutputTypeEnum_captainReimbursement =
    const AdminReceiptDtoOutputTypeEnum._('captainReimbursement');

AdminReceiptDtoOutputTypeEnum _$adminReceiptDtoOutputTypeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'captainHandIn':
      return _$adminReceiptDtoOutputTypeEnum_captainHandIn;
    case 'captainReimbursement':
      return _$adminReceiptDtoOutputTypeEnum_captainReimbursement;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminReceiptDtoOutputTypeEnum>
_$adminReceiptDtoOutputTypeEnumValues = BuiltSet<AdminReceiptDtoOutputTypeEnum>(
  const <AdminReceiptDtoOutputTypeEnum>[
    _$adminReceiptDtoOutputTypeEnum_captainHandIn,
    _$adminReceiptDtoOutputTypeEnum_captainReimbursement,
  ],
);

Serializer<AdminReceiptDtoOutputTypeEnum>
_$adminReceiptDtoOutputTypeEnumSerializer =
    _$AdminReceiptDtoOutputTypeEnumSerializer();

class _$AdminReceiptDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<AdminReceiptDtoOutputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captainHandIn': 'captain_hand_in',
    'captainReimbursement': 'captain_reimbursement',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain_hand_in': 'captainHandIn',
    'captain_reimbursement': 'captainReimbursement',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminReceiptDtoOutputTypeEnum];
  @override
  final String wireName = 'AdminReceiptDtoOutputTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminReceiptDtoOutputTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminReceiptDtoOutputTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminReceiptDtoOutputTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminReceiptDtoOutput extends AdminReceiptDtoOutput {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String number;
  @override
  final AdminReceiptDtoOutputTypeEnum type;
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
  final BuiltList<AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner>
  conversions;
  @override
  final BuiltList<AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner> lines;

  factory _$AdminReceiptDtoOutput([
    void Function(AdminReceiptDtoOutputBuilder)? updates,
  ]) => (AdminReceiptDtoOutputBuilder()..update(updates))._build();

  _$AdminReceiptDtoOutput._({
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
  AdminReceiptDtoOutput rebuild(
    void Function(AdminReceiptDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReceiptDtoOutputBuilder toBuilder() =>
      AdminReceiptDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReceiptDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminReceiptDtoOutput')
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

class AdminReceiptDtoOutputBuilder
    implements Builder<AdminReceiptDtoOutput, AdminReceiptDtoOutputBuilder> {
  _$AdminReceiptDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  AdminReceiptDtoOutputTypeEnum? _type;
  AdminReceiptDtoOutputTypeEnum? get type => _$this._type;
  set type(AdminReceiptDtoOutputTypeEnum? type) => _$this._type = type;

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

  ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner>?
  _conversions;
  ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner>
  get conversions => _$this._conversions ??=
      ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner>();
  set conversions(
    ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner>?
    conversions,
  ) => _$this._conversions = conversions;

  ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner>? _lines;
  ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner>();
  set lines(
    ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner>? lines,
  ) => _$this._lines = lines;

  AdminReceiptDtoOutputBuilder() {
    AdminReceiptDtoOutput._defaults(this);
  }

  AdminReceiptDtoOutputBuilder get _$this {
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
  void replace(AdminReceiptDtoOutput other) {
    _$v = other as _$AdminReceiptDtoOutput;
  }

  @override
  void update(void Function(AdminReceiptDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReceiptDtoOutput build() => _build();

  _$AdminReceiptDtoOutput _build() {
    _$AdminReceiptDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminReceiptDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminReceiptDtoOutput',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminReceiptDtoOutput',
              'cityId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminReceiptDtoOutput',
              'number',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminReceiptDtoOutput',
              'type',
            ),
            sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId,
              r'AdminReceiptDtoOutput',
              'sessionId',
            ),
            cashierId: BuiltValueNullFieldError.checkNotNull(
              cashierId,
              r'AdminReceiptDtoOutput',
              'cashierId',
            ),
            cashierName: cashierName,
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminReceiptDtoOutput',
              'captainId',
            ),
            captainName: BuiltValueNullFieldError.checkNotNull(
              captainName,
              r'AdminReceiptDtoOutput',
              'captainName',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminReceiptDtoOutput',
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
          r'AdminReceiptDtoOutput',
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
