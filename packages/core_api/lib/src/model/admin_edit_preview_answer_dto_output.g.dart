// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_preview_answer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEditPreviewAnswerDtoOutput
    extends AdminEditPreviewAnswerDtoOutput {
  @override
  final String currency;
  @override
  final AdminEditPreviewAnswerDtoOutputBefore before;
  @override
  final AdminEditPreviewAnswerDtoOutputBefore after;
  @override
  final BuiltList<AdminEditPreviewAnswerDtoOutputChangesInner> changes;
  @override
  final bool addsItems;
  @override
  final bool backToPreparing;
  @override
  final DateTime? promisedAt;
  @override
  final bool afterPickup;
  @override
  final BuiltList<AdminEditPreviewAnswerDtoOutputEntriesInner> entries;

  factory _$AdminEditPreviewAnswerDtoOutput([
    void Function(AdminEditPreviewAnswerDtoOutputBuilder)? updates,
  ]) => (AdminEditPreviewAnswerDtoOutputBuilder()..update(updates))._build();

  _$AdminEditPreviewAnswerDtoOutput._({
    required this.currency,
    required this.before,
    required this.after,
    required this.changes,
    required this.addsItems,
    required this.backToPreparing,
    this.promisedAt,
    required this.afterPickup,
    required this.entries,
  }) : super._();
  @override
  AdminEditPreviewAnswerDtoOutput rebuild(
    void Function(AdminEditPreviewAnswerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEditPreviewAnswerDtoOutputBuilder toBuilder() =>
      AdminEditPreviewAnswerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditPreviewAnswerDtoOutput &&
        currency == other.currency &&
        before == other.before &&
        after == other.after &&
        changes == other.changes &&
        addsItems == other.addsItems &&
        backToPreparing == other.backToPreparing &&
        promisedAt == other.promisedAt &&
        afterPickup == other.afterPickup &&
        entries == other.entries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jc(_$hash, addsItems.hashCode);
    _$hash = $jc(_$hash, backToPreparing.hashCode);
    _$hash = $jc(_$hash, promisedAt.hashCode);
    _$hash = $jc(_$hash, afterPickup.hashCode);
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEditPreviewAnswerDtoOutput')
          ..add('currency', currency)
          ..add('before', before)
          ..add('after', after)
          ..add('changes', changes)
          ..add('addsItems', addsItems)
          ..add('backToPreparing', backToPreparing)
          ..add('promisedAt', promisedAt)
          ..add('afterPickup', afterPickup)
          ..add('entries', entries))
        .toString();
  }
}

class AdminEditPreviewAnswerDtoOutputBuilder
    implements
        Builder<
          AdminEditPreviewAnswerDtoOutput,
          AdminEditPreviewAnswerDtoOutputBuilder
        > {
  _$AdminEditPreviewAnswerDtoOutput? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminEditPreviewAnswerDtoOutputBeforeBuilder? _before;
  AdminEditPreviewAnswerDtoOutputBeforeBuilder get before =>
      _$this._before ??= AdminEditPreviewAnswerDtoOutputBeforeBuilder();
  set before(AdminEditPreviewAnswerDtoOutputBeforeBuilder? before) =>
      _$this._before = before;

  AdminEditPreviewAnswerDtoOutputBeforeBuilder? _after;
  AdminEditPreviewAnswerDtoOutputBeforeBuilder get after =>
      _$this._after ??= AdminEditPreviewAnswerDtoOutputBeforeBuilder();
  set after(AdminEditPreviewAnswerDtoOutputBeforeBuilder? after) =>
      _$this._after = after;

  ListBuilder<AdminEditPreviewAnswerDtoOutputChangesInner>? _changes;
  ListBuilder<AdminEditPreviewAnswerDtoOutputChangesInner> get changes =>
      _$this._changes ??=
          ListBuilder<AdminEditPreviewAnswerDtoOutputChangesInner>();
  set changes(
    ListBuilder<AdminEditPreviewAnswerDtoOutputChangesInner>? changes,
  ) => _$this._changes = changes;

  bool? _addsItems;
  bool? get addsItems => _$this._addsItems;
  set addsItems(bool? addsItems) => _$this._addsItems = addsItems;

  bool? _backToPreparing;
  bool? get backToPreparing => _$this._backToPreparing;
  set backToPreparing(bool? backToPreparing) =>
      _$this._backToPreparing = backToPreparing;

  DateTime? _promisedAt;
  DateTime? get promisedAt => _$this._promisedAt;
  set promisedAt(DateTime? promisedAt) => _$this._promisedAt = promisedAt;

  bool? _afterPickup;
  bool? get afterPickup => _$this._afterPickup;
  set afterPickup(bool? afterPickup) => _$this._afterPickup = afterPickup;

  ListBuilder<AdminEditPreviewAnswerDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminEditPreviewAnswerDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminEditPreviewAnswerDtoOutputEntriesInner>();
  set entries(
    ListBuilder<AdminEditPreviewAnswerDtoOutputEntriesInner>? entries,
  ) => _$this._entries = entries;

  AdminEditPreviewAnswerDtoOutputBuilder() {
    AdminEditPreviewAnswerDtoOutput._defaults(this);
  }

  AdminEditPreviewAnswerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _before = $v.before.toBuilder();
      _after = $v.after.toBuilder();
      _changes = $v.changes.toBuilder();
      _addsItems = $v.addsItems;
      _backToPreparing = $v.backToPreparing;
      _promisedAt = $v.promisedAt;
      _afterPickup = $v.afterPickup;
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEditPreviewAnswerDtoOutput other) {
    _$v = other as _$AdminEditPreviewAnswerDtoOutput;
  }

  @override
  void update(void Function(AdminEditPreviewAnswerDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditPreviewAnswerDtoOutput build() => _build();

  _$AdminEditPreviewAnswerDtoOutput _build() {
    _$AdminEditPreviewAnswerDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminEditPreviewAnswerDtoOutput._(
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminEditPreviewAnswerDtoOutput',
              'currency',
            ),
            before: before.build(),
            after: after.build(),
            changes: changes.build(),
            addsItems: BuiltValueNullFieldError.checkNotNull(
              addsItems,
              r'AdminEditPreviewAnswerDtoOutput',
              'addsItems',
            ),
            backToPreparing: BuiltValueNullFieldError.checkNotNull(
              backToPreparing,
              r'AdminEditPreviewAnswerDtoOutput',
              'backToPreparing',
            ),
            promisedAt: promisedAt,
            afterPickup: BuiltValueNullFieldError.checkNotNull(
              afterPickup,
              r'AdminEditPreviewAnswerDtoOutput',
              'afterPickup',
            ),
            entries: entries.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'before';
        before.build();
        _$failedField = 'after';
        after.build();
        _$failedField = 'changes';
        changes.build();

        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminEditPreviewAnswerDtoOutput',
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
