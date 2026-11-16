// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_entries_dto_output_entries_inner_corrects.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminManualEntriesDtoOutputEntriesInnerCorrects
    extends AdminManualEntriesDtoOutputEntriesInnerCorrects {
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

  factory _$AdminManualEntriesDtoOutputEntriesInnerCorrects([
    void Function(AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder)?
    updates,
  ]) =>
      (AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder()
            ..update(updates))
          ._build();

  _$AdminManualEntriesDtoOutputEntriesInnerCorrects._({
    required this.journalId,
    required this.type,
    this.reason,
    required this.createdAt,
    required this.lines,
    this.orderId,
    this.orderNumber,
    this.manualEntryId,
  }) : super._();
  @override
  AdminManualEntriesDtoOutputEntriesInnerCorrects rebuild(
    void Function(AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder toBuilder() =>
      AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualEntriesDtoOutputEntriesInnerCorrects &&
        journalId == other.journalId &&
        type == other.type &&
        reason == other.reason &&
        createdAt == other.createdAt &&
        lines == other.lines &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber &&
        manualEntryId == other.manualEntryId;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminManualEntriesDtoOutputEntriesInnerCorrects',
          )
          ..add('journalId', journalId)
          ..add('type', type)
          ..add('reason', reason)
          ..add('createdAt', createdAt)
          ..add('lines', lines)
          ..add('orderId', orderId)
          ..add('orderNumber', orderNumber)
          ..add('manualEntryId', manualEntryId))
        .toString();
  }
}

class AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder
    implements
        Builder<
          AdminManualEntriesDtoOutputEntriesInnerCorrects,
          AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder
        > {
  _$AdminManualEntriesDtoOutputEntriesInnerCorrects? _$v;

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

  AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder() {
    AdminManualEntriesDtoOutputEntriesInnerCorrects._defaults(this);
  }

  AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminManualEntriesDtoOutputEntriesInnerCorrects other) {
    _$v = other as _$AdminManualEntriesDtoOutputEntriesInnerCorrects;
  }

  @override
  void update(
    void Function(AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualEntriesDtoOutputEntriesInnerCorrects build() => _build();

  _$AdminManualEntriesDtoOutputEntriesInnerCorrects _build() {
    _$AdminManualEntriesDtoOutputEntriesInnerCorrects _$result;
    try {
      _$result =
          _$v ??
          _$AdminManualEntriesDtoOutputEntriesInnerCorrects._(
            journalId: BuiltValueNullFieldError.checkNotNull(
              journalId,
              r'AdminManualEntriesDtoOutputEntriesInnerCorrects',
              'journalId',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminManualEntriesDtoOutputEntriesInnerCorrects',
              'type',
            ),
            reason: reason,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminManualEntriesDtoOutputEntriesInnerCorrects',
              'createdAt',
            ),
            lines: lines.build(),
            orderId: orderId,
            orderNumber: orderNumber,
            manualEntryId: manualEntryId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminManualEntriesDtoOutputEntriesInnerCorrects',
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
