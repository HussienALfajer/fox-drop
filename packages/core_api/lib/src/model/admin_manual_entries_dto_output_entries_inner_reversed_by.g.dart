// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_entries_dto_output_entries_inner_reversed_by.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminManualEntriesDtoOutputEntriesInnerReversedBy
    extends AdminManualEntriesDtoOutputEntriesInnerReversedBy {
  @override
  final String journalId;
  @override
  final String? manualEntryId;
  @override
  final DateTime at;

  factory _$AdminManualEntriesDtoOutputEntriesInnerReversedBy([
    void Function(AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder)?
    updates,
  ]) =>
      (AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder()
            ..update(updates))
          ._build();

  _$AdminManualEntriesDtoOutputEntriesInnerReversedBy._({
    required this.journalId,
    this.manualEntryId,
    required this.at,
  }) : super._();
  @override
  AdminManualEntriesDtoOutputEntriesInnerReversedBy rebuild(
    void Function(AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder toBuilder() =>
      AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualEntriesDtoOutputEntriesInnerReversedBy &&
        journalId == other.journalId &&
        manualEntryId == other.manualEntryId &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, journalId.hashCode);
    _$hash = $jc(_$hash, manualEntryId.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminManualEntriesDtoOutputEntriesInnerReversedBy',
          )
          ..add('journalId', journalId)
          ..add('manualEntryId', manualEntryId)
          ..add('at', at))
        .toString();
  }
}

class AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder
    implements
        Builder<
          AdminManualEntriesDtoOutputEntriesInnerReversedBy,
          AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder
        > {
  _$AdminManualEntriesDtoOutputEntriesInnerReversedBy? _$v;

  String? _journalId;
  String? get journalId => _$this._journalId;
  set journalId(String? journalId) => _$this._journalId = journalId;

  String? _manualEntryId;
  String? get manualEntryId => _$this._manualEntryId;
  set manualEntryId(String? manualEntryId) =>
      _$this._manualEntryId = manualEntryId;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder() {
    AdminManualEntriesDtoOutputEntriesInnerReversedBy._defaults(this);
  }

  AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _journalId = $v.journalId;
      _manualEntryId = $v.manualEntryId;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminManualEntriesDtoOutputEntriesInnerReversedBy other) {
    _$v = other as _$AdminManualEntriesDtoOutputEntriesInnerReversedBy;
  }

  @override
  void update(
    void Function(AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualEntriesDtoOutputEntriesInnerReversedBy build() => _build();

  _$AdminManualEntriesDtoOutputEntriesInnerReversedBy _build() {
    final _$result =
        _$v ??
        _$AdminManualEntriesDtoOutputEntriesInnerReversedBy._(
          journalId: BuiltValueNullFieldError.checkNotNull(
            journalId,
            r'AdminManualEntriesDtoOutputEntriesInnerReversedBy',
            'journalId',
          ),
          manualEntryId: manualEntryId,
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminManualEntriesDtoOutputEntriesInnerReversedBy',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
