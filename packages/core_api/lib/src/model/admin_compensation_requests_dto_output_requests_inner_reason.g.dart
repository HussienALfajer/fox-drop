// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_compensation_requests_dto_output_requests_inner_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCompensationRequestsDtoOutputRequestsInnerReason
    extends AdminCompensationRequestsDtoOutputRequestsInnerReason {
  @override
  final String code;
  @override
  final String label;

  factory _$AdminCompensationRequestsDtoOutputRequestsInnerReason([
    void Function(AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder)?
    updates,
  ]) =>
      (AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder()
            ..update(updates))
          ._build();

  _$AdminCompensationRequestsDtoOutputRequestsInnerReason._({
    required this.code,
    required this.label,
  }) : super._();
  @override
  AdminCompensationRequestsDtoOutputRequestsInnerReason rebuild(
    void Function(AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder toBuilder() =>
      AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCompensationRequestsDtoOutputRequestsInnerReason &&
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
            r'AdminCompensationRequestsDtoOutputRequestsInnerReason',
          )
          ..add('code', code)
          ..add('label', label))
        .toString();
  }
}

class AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder
    implements
        Builder<
          AdminCompensationRequestsDtoOutputRequestsInnerReason,
          AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder
        > {
  _$AdminCompensationRequestsDtoOutputRequestsInnerReason? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder() {
    AdminCompensationRequestsDtoOutputRequestsInnerReason._defaults(this);
  }

  AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCompensationRequestsDtoOutputRequestsInnerReason other) {
    _$v = other as _$AdminCompensationRequestsDtoOutputRequestsInnerReason;
  }

  @override
  void update(
    void Function(AdminCompensationRequestsDtoOutputRequestsInnerReasonBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCompensationRequestsDtoOutputRequestsInnerReason build() => _build();

  _$AdminCompensationRequestsDtoOutputRequestsInnerReason _build() {
    final _$result =
        _$v ??
        _$AdminCompensationRequestsDtoOutputRequestsInnerReason._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCompensationRequestsDtoOutputRequestsInnerReason',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminCompensationRequestsDtoOutputRequestsInnerReason',
            'label',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
