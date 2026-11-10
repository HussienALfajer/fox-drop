// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_item_report_note.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerItemReportNote
    extends MerchantOrdersDtoOutputOrdersInnerItemReportNote {
  @override
  final String code;
  @override
  final String label;

  factory _$MerchantOrdersDtoOutputOrdersInnerItemReportNote([
    void Function(MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder)?
    updates,
  ]) =>
      (MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder()
            ..update(updates))
          ._build();

  _$MerchantOrdersDtoOutputOrdersInnerItemReportNote._({
    required this.code,
    required this.label,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerItemReportNote rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerItemReportNote &&
        code == other.code &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerItemReportNote',
          )
          ..add('code', code)
          ..add('label', label))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerItemReportNote,
          MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerItemReportNote? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder() {
    MerchantOrdersDtoOutputOrdersInnerItemReportNote._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerItemReportNote other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerItemReportNote;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerItemReportNote build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerItemReportNote _build() {
    final _$result =
        _$v ??
        _$MerchantOrdersDtoOutputOrdersInnerItemReportNote._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MerchantOrdersDtoOutputOrdersInnerItemReportNote',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'MerchantOrdersDtoOutputOrdersInnerItemReportNote',
            'label',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
