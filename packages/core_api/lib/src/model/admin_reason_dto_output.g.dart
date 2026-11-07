// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reason_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReasonDtoOutput extends AdminReasonDtoOutput {
  @override
  final String code;
  @override
  final String label;
  @override
  final String? customerText;
  @override
  final bool needsText;
  @override
  final bool fixed;
  @override
  final bool active;

  factory _$AdminReasonDtoOutput([
    void Function(AdminReasonDtoOutputBuilder)? updates,
  ]) => (AdminReasonDtoOutputBuilder()..update(updates))._build();

  _$AdminReasonDtoOutput._({
    required this.code,
    required this.label,
    this.customerText,
    required this.needsText,
    required this.fixed,
    required this.active,
  }) : super._();
  @override
  AdminReasonDtoOutput rebuild(
    void Function(AdminReasonDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReasonDtoOutputBuilder toBuilder() =>
      AdminReasonDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReasonDtoOutput &&
        code == other.code &&
        label == other.label &&
        customerText == other.customerText &&
        needsText == other.needsText &&
        fixed == other.fixed &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customerText.hashCode);
    _$hash = $jc(_$hash, needsText.hashCode);
    _$hash = $jc(_$hash, fixed.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReasonDtoOutput')
          ..add('code', code)
          ..add('label', label)
          ..add('customerText', customerText)
          ..add('needsText', needsText)
          ..add('fixed', fixed)
          ..add('active', active))
        .toString();
  }
}

class AdminReasonDtoOutputBuilder
    implements Builder<AdminReasonDtoOutput, AdminReasonDtoOutputBuilder> {
  _$AdminReasonDtoOutput? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _customerText;
  String? get customerText => _$this._customerText;
  set customerText(String? customerText) => _$this._customerText = customerText;

  bool? _needsText;
  bool? get needsText => _$this._needsText;
  set needsText(bool? needsText) => _$this._needsText = needsText;

  bool? _fixed;
  bool? get fixed => _$this._fixed;
  set fixed(bool? fixed) => _$this._fixed = fixed;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  AdminReasonDtoOutputBuilder() {
    AdminReasonDtoOutput._defaults(this);
  }

  AdminReasonDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _customerText = $v.customerText;
      _needsText = $v.needsText;
      _fixed = $v.fixed;
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReasonDtoOutput other) {
    _$v = other as _$AdminReasonDtoOutput;
  }

  @override
  void update(void Function(AdminReasonDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReasonDtoOutput build() => _build();

  _$AdminReasonDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminReasonDtoOutput._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminReasonDtoOutput',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminReasonDtoOutput',
            'label',
          ),
          customerText: customerText,
          needsText: BuiltValueNullFieldError.checkNotNull(
            needsText,
            r'AdminReasonDtoOutput',
            'needsText',
          ),
          fixed: BuiltValueNullFieldError.checkNotNull(
            fixed,
            r'AdminReasonDtoOutput',
            'fixed',
          ),
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'AdminReasonDtoOutput',
            'active',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
