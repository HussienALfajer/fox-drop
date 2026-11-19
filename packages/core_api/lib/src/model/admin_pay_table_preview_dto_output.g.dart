// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_pay_table_preview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPayTablePreviewDtoOutput extends AdminPayTablePreviewDtoOutput {
  @override
  final int waitingThresholdMin;
  @override
  final AdminPayTablePreviewDtoOutputInForce? inForce;
  @override
  final BuiltList<AdminPayTablePreviewDtoOutputAnnouncedInner> announced;
  @override
  final AdminPayTablePreviewDtoOutputDraft? draft;

  factory _$AdminPayTablePreviewDtoOutput([
    void Function(AdminPayTablePreviewDtoOutputBuilder)? updates,
  ]) => (AdminPayTablePreviewDtoOutputBuilder()..update(updates))._build();

  _$AdminPayTablePreviewDtoOutput._({
    required this.waitingThresholdMin,
    this.inForce,
    required this.announced,
    this.draft,
  }) : super._();
  @override
  AdminPayTablePreviewDtoOutput rebuild(
    void Function(AdminPayTablePreviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPayTablePreviewDtoOutputBuilder toBuilder() =>
      AdminPayTablePreviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayTablePreviewDtoOutput &&
        waitingThresholdMin == other.waitingThresholdMin &&
        inForce == other.inForce &&
        announced == other.announced &&
        draft == other.draft;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, waitingThresholdMin.hashCode);
    _$hash = $jc(_$hash, inForce.hashCode);
    _$hash = $jc(_$hash, announced.hashCode);
    _$hash = $jc(_$hash, draft.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPayTablePreviewDtoOutput')
          ..add('waitingThresholdMin', waitingThresholdMin)
          ..add('inForce', inForce)
          ..add('announced', announced)
          ..add('draft', draft))
        .toString();
  }
}

class AdminPayTablePreviewDtoOutputBuilder
    implements
        Builder<
          AdminPayTablePreviewDtoOutput,
          AdminPayTablePreviewDtoOutputBuilder
        > {
  _$AdminPayTablePreviewDtoOutput? _$v;

  int? _waitingThresholdMin;
  int? get waitingThresholdMin => _$this._waitingThresholdMin;
  set waitingThresholdMin(int? waitingThresholdMin) =>
      _$this._waitingThresholdMin = waitingThresholdMin;

  AdminPayTablePreviewDtoOutputInForceBuilder? _inForce;
  AdminPayTablePreviewDtoOutputInForceBuilder get inForce =>
      _$this._inForce ??= AdminPayTablePreviewDtoOutputInForceBuilder();
  set inForce(AdminPayTablePreviewDtoOutputInForceBuilder? inForce) =>
      _$this._inForce = inForce;

  ListBuilder<AdminPayTablePreviewDtoOutputAnnouncedInner>? _announced;
  ListBuilder<AdminPayTablePreviewDtoOutputAnnouncedInner> get announced =>
      _$this._announced ??=
          ListBuilder<AdminPayTablePreviewDtoOutputAnnouncedInner>();
  set announced(
    ListBuilder<AdminPayTablePreviewDtoOutputAnnouncedInner>? announced,
  ) => _$this._announced = announced;

  AdminPayTablePreviewDtoOutputDraftBuilder? _draft;
  AdminPayTablePreviewDtoOutputDraftBuilder get draft =>
      _$this._draft ??= AdminPayTablePreviewDtoOutputDraftBuilder();
  set draft(AdminPayTablePreviewDtoOutputDraftBuilder? draft) =>
      _$this._draft = draft;

  AdminPayTablePreviewDtoOutputBuilder() {
    AdminPayTablePreviewDtoOutput._defaults(this);
  }

  AdminPayTablePreviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _waitingThresholdMin = $v.waitingThresholdMin;
      _inForce = $v.inForce?.toBuilder();
      _announced = $v.announced.toBuilder();
      _draft = $v.draft?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPayTablePreviewDtoOutput other) {
    _$v = other as _$AdminPayTablePreviewDtoOutput;
  }

  @override
  void update(void Function(AdminPayTablePreviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayTablePreviewDtoOutput build() => _build();

  _$AdminPayTablePreviewDtoOutput _build() {
    _$AdminPayTablePreviewDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminPayTablePreviewDtoOutput._(
            waitingThresholdMin: BuiltValueNullFieldError.checkNotNull(
              waitingThresholdMin,
              r'AdminPayTablePreviewDtoOutput',
              'waitingThresholdMin',
            ),
            inForce: _inForce?.build(),
            announced: announced.build(),
            draft: _draft?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'inForce';
        _inForce?.build();
        _$failedField = 'announced';
        announced.build();
        _$failedField = 'draft';
        _draft?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPayTablePreviewDtoOutput',
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
