// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_account_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminManualAccountDtoOutputEntriesInner
    extends AdminManualAccountDtoOutputEntriesInner {
  @override
  final String journalId;
  @override
  final String type;
  @override
  final String? reason;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner>
  lines;
  @override
  final String? orderId;
  @override
  final String? orderNumber;
  @override
  final String? manualEntryId;
  @override
  final bool reversible;
  @override
  final bool reversed;

  factory _$AdminManualAccountDtoOutputEntriesInner([
    void Function(AdminManualAccountDtoOutputEntriesInnerBuilder)? updates,
  ]) => (AdminManualAccountDtoOutputEntriesInnerBuilder()..update(updates))
      ._build();

  _$AdminManualAccountDtoOutputEntriesInner._({
    required this.journalId,
    required this.type,
    this.reason,
    required this.createdAt,
    required this.lines,
    this.orderId,
    this.orderNumber,
    this.manualEntryId,
    required this.reversible,
    required this.reversed,
  }) : super._();
  @override
  AdminManualAccountDtoOutputEntriesInner rebuild(
    void Function(AdminManualAccountDtoOutputEntriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualAccountDtoOutputEntriesInnerBuilder toBuilder() =>
      AdminManualAccountDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualAccountDtoOutputEntriesInner &&
        journalId == other.journalId &&
        type == other.type &&
        reason == other.reason &&
        createdAt == other.createdAt &&
        lines == other.lines &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber &&
        manualEntryId == other.manualEntryId &&
        reversible == other.reversible &&
        reversed == other.reversed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, journalId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, manualEntryId.hashCode);
    _$hash = $jc(_$hash, reversible.hashCode);
    _$hash = $jc(_$hash, reversed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminManualAccountDtoOutputEntriesInner',
          )
          ..add('journalId', journalId)
          ..add('type', type)
          ..add('reason', reason)
          ..add('createdAt', createdAt)
          ..add('lines', lines)
          ..add('orderId', orderId)
          ..add('orderNumber', orderNumber)
          ..add('manualEntryId', manualEntryId)
          ..add('reversible', reversible)
          ..add('reversed', reversed))
        .toString();
  }
}

class AdminManualAccountDtoOutputEntriesInnerBuilder
    implements
        Builder<
          AdminManualAccountDtoOutputEntriesInner,
          AdminManualAccountDtoOutputEntriesInnerBuilder
        > {
  _$AdminManualAccountDtoOutputEntriesInner? _$v;

  String? _journalId;
  String? get journalId => _$this._journalId;
  set journalId(String? journalId) => _$this._journalId = journalId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner>? _lines;
  ListBuilder<AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner>
  get lines => _$this._lines ??=
      ListBuilder<AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner>();
  set lines(
    ListBuilder<AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner>?
    lines,
  ) => _$this._lines = lines;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  String? _manualEntryId;
  String? get manualEntryId => _$this._manualEntryId;
  set manualEntryId(String? manualEntryId) =>
      _$this._manualEntryId = manualEntryId;

  bool? _reversible;
  bool? get reversible => _$this._reversible;
  set reversible(bool? reversible) => _$this._reversible = reversible;

  bool? _reversed;
  bool? get reversed => _$this._reversed;
  set reversed(bool? reversed) => _$this._reversed = reversed;

  AdminManualAccountDtoOutputEntriesInnerBuilder() {
    AdminManualAccountDtoOutputEntriesInner._defaults(this);
  }

  AdminManualAccountDtoOutputEntriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _journalId = $v.journalId;
      _type = $v.type;
      _reason = $v.reason;
      _createdAt = $v.createdAt;
      _lines = $v.lines.toBuilder();
      _orderId = $v.orderId;
      _orderNumber = $v.orderNumber;
      _manualEntryId = $v.manualEntryId;
      _reversible = $v.reversible;
      _reversed = $v.reversed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminManualAccountDtoOutputEntriesInner other) {
    _$v = other as _$AdminManualAccountDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(AdminManualAccountDtoOutputEntriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualAccountDtoOutputEntriesInner build() => _build();

  _$AdminManualAccountDtoOutputEntriesInner _build() {
    _$AdminManualAccountDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminManualAccountDtoOutputEntriesInner._(
            journalId: BuiltValueNullFieldError.checkNotNull(
              journalId,
              r'AdminManualAccountDtoOutputEntriesInner',
              'journalId',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminManualAccountDtoOutputEntriesInner',
              'type',
            ),
            reason: reason,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminManualAccountDtoOutputEntriesInner',
              'createdAt',
            ),
            lines: lines.build(),
            orderId: orderId,
            orderNumber: orderNumber,
            manualEntryId: manualEntryId,
            reversible: BuiltValueNullFieldError.checkNotNull(
              reversible,
              r'AdminManualAccountDtoOutputEntriesInner',
              'reversible',
            ),
            reversed: BuiltValueNullFieldError.checkNotNull(
              reversed,
              r'AdminManualAccountDtoOutputEntriesInner',
              'reversed',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminManualAccountDtoOutputEntriesInner',
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
