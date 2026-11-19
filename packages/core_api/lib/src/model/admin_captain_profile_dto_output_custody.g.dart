// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_profile_dto_output_custody.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainProfileDtoOutputCustodyBlocksEnum
_$adminCaptainProfileDtoOutputCustodyBlocksEnum_closedDue =
    const AdminCaptainProfileDtoOutputCustodyBlocksEnum._('closedDue');
const AdminCaptainProfileDtoOutputCustodyBlocksEnum
_$adminCaptainProfileDtoOutputCustodyBlocksEnum_cashLimit =
    const AdminCaptainProfileDtoOutputCustodyBlocksEnum._('cashLimit');

AdminCaptainProfileDtoOutputCustodyBlocksEnum
_$adminCaptainProfileDtoOutputCustodyBlocksEnumValueOf(String name) {
  switch (name) {
    case 'closedDue':
      return _$adminCaptainProfileDtoOutputCustodyBlocksEnum_closedDue;
    case 'cashLimit':
      return _$adminCaptainProfileDtoOutputCustodyBlocksEnum_cashLimit;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainProfileDtoOutputCustodyBlocksEnum>
_$adminCaptainProfileDtoOutputCustodyBlocksEnumValues =
    BuiltSet<AdminCaptainProfileDtoOutputCustodyBlocksEnum>(
      const <AdminCaptainProfileDtoOutputCustodyBlocksEnum>[
        _$adminCaptainProfileDtoOutputCustodyBlocksEnum_closedDue,
        _$adminCaptainProfileDtoOutputCustodyBlocksEnum_cashLimit,
      ],
    );

Serializer<AdminCaptainProfileDtoOutputCustodyBlocksEnum>
_$adminCaptainProfileDtoOutputCustodyBlocksEnumSerializer =
    _$AdminCaptainProfileDtoOutputCustodyBlocksEnumSerializer();

class _$AdminCaptainProfileDtoOutputCustodyBlocksEnumSerializer
    implements
        PrimitiveSerializer<AdminCaptainProfileDtoOutputCustodyBlocksEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'closedDue': 'closed_due',
    'cashLimit': 'cash_limit',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'closed_due': 'closedDue',
    'cash_limit': 'cashLimit',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainProfileDtoOutputCustodyBlocksEnum,
  ];
  @override
  final String wireName = 'AdminCaptainProfileDtoOutputCustodyBlocksEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutputCustodyBlocksEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainProfileDtoOutputCustodyBlocksEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainProfileDtoOutputCustodyBlocksEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainProfileDtoOutputCustody
    extends AdminCaptainProfileDtoOutputCustody {
  @override
  final AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? usage;
  @override
  final AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? limit;
  @override
  final AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? closedDue;
  @override
  final BuiltList<AdminCaptainProfileDtoOutputCustodyCurrenciesInner>
  currencies;
  @override
  final BuiltList<AdminCaptainProfileDtoOutputCustodyBlocksEnum> blocks;
  @override
  final DateTime? handInGraceUntil;

  factory _$AdminCaptainProfileDtoOutputCustody([
    void Function(AdminCaptainProfileDtoOutputCustodyBuilder)? updates,
  ]) =>
      (AdminCaptainProfileDtoOutputCustodyBuilder()..update(updates))._build();

  _$AdminCaptainProfileDtoOutputCustody._({
    this.usage,
    this.limit,
    this.closedDue,
    required this.currencies,
    required this.blocks,
    this.handInGraceUntil,
  }) : super._();
  @override
  AdminCaptainProfileDtoOutputCustody rebuild(
    void Function(AdminCaptainProfileDtoOutputCustodyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainProfileDtoOutputCustodyBuilder toBuilder() =>
      AdminCaptainProfileDtoOutputCustodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainProfileDtoOutputCustody &&
        usage == other.usage &&
        limit == other.limit &&
        closedDue == other.closedDue &&
        currencies == other.currencies &&
        blocks == other.blocks &&
        handInGraceUntil == other.handInGraceUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, usage.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, closedDue.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jc(_$hash, blocks.hashCode);
    _$hash = $jc(_$hash, handInGraceUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainProfileDtoOutputCustody')
          ..add('usage', usage)
          ..add('limit', limit)
          ..add('closedDue', closedDue)
          ..add('currencies', currencies)
          ..add('blocks', blocks)
          ..add('handInGraceUntil', handInGraceUntil))
        .toString();
  }
}

class AdminCaptainProfileDtoOutputCustodyBuilder
    implements
        Builder<
          AdminCaptainProfileDtoOutputCustody,
          AdminCaptainProfileDtoOutputCustodyBuilder
        > {
  _$AdminCaptainProfileDtoOutputCustody? _$v;

  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder? _usage;
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder get usage =>
      _$this._usage ??=
          AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder();
  set usage(
    AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder? usage,
  ) => _$this._usage = usage;

  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder? _limit;
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder get limit =>
      _$this._limit ??=
          AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder();
  set limit(
    AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder? limit,
  ) => _$this._limit = limit;

  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder? _closedDue;
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder get closedDue =>
      _$this._closedDue ??=
          AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder();
  set closedDue(
    AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder? closedDue,
  ) => _$this._closedDue = closedDue;

  ListBuilder<AdminCaptainProfileDtoOutputCustodyCurrenciesInner>? _currencies;
  ListBuilder<AdminCaptainProfileDtoOutputCustodyCurrenciesInner>
  get currencies => _$this._currencies ??=
      ListBuilder<AdminCaptainProfileDtoOutputCustodyCurrenciesInner>();
  set currencies(
    ListBuilder<AdminCaptainProfileDtoOutputCustodyCurrenciesInner>? currencies,
  ) => _$this._currencies = currencies;

  ListBuilder<AdminCaptainProfileDtoOutputCustodyBlocksEnum>? _blocks;
  ListBuilder<AdminCaptainProfileDtoOutputCustodyBlocksEnum> get blocks =>
      _$this._blocks ??=
          ListBuilder<AdminCaptainProfileDtoOutputCustodyBlocksEnum>();
  set blocks(
    ListBuilder<AdminCaptainProfileDtoOutputCustodyBlocksEnum>? blocks,
  ) => _$this._blocks = blocks;

  DateTime? _handInGraceUntil;
  DateTime? get handInGraceUntil => _$this._handInGraceUntil;
  set handInGraceUntil(DateTime? handInGraceUntil) =>
      _$this._handInGraceUntil = handInGraceUntil;

  AdminCaptainProfileDtoOutputCustodyBuilder() {
    AdminCaptainProfileDtoOutputCustody._defaults(this);
  }

  AdminCaptainProfileDtoOutputCustodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _usage = $v.usage?.toBuilder();
      _limit = $v.limit?.toBuilder();
      _closedDue = $v.closedDue?.toBuilder();
      _currencies = $v.currencies.toBuilder();
      _blocks = $v.blocks.toBuilder();
      _handInGraceUntil = $v.handInGraceUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainProfileDtoOutputCustody other) {
    _$v = other as _$AdminCaptainProfileDtoOutputCustody;
  }

  @override
  void update(
    void Function(AdminCaptainProfileDtoOutputCustodyBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainProfileDtoOutputCustody build() => _build();

  _$AdminCaptainProfileDtoOutputCustody _build() {
    _$AdminCaptainProfileDtoOutputCustody _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainProfileDtoOutputCustody._(
            usage: _usage?.build(),
            limit: _limit?.build(),
            closedDue: _closedDue?.build(),
            currencies: currencies.build(),
            blocks: blocks.build(),
            handInGraceUntil: handInGraceUntil,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'usage';
        _usage?.build();
        _$failedField = 'limit';
        _limit?.build();
        _$failedField = 'closedDue';
        _closedDue?.build();
        _$failedField = 'currencies';
        currencies.build();
        _$failedField = 'blocks';
        blocks.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainProfileDtoOutputCustody',
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
