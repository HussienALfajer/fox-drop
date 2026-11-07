// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_reason_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateReasonDto extends UpdateReasonDto {
  @override
  final String label;
  @override
  final String? customerText;
  @override
  final bool needsText;
  @override
  final bool active;

  factory _$UpdateReasonDto([void Function(UpdateReasonDtoBuilder)? updates]) =>
      (UpdateReasonDtoBuilder()..update(updates))._build();

  _$UpdateReasonDto._({
    required this.label,
    this.customerText,
    required this.needsText,
    required this.active,
  }) : super._();
  @override
  UpdateReasonDto rebuild(void Function(UpdateReasonDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateReasonDtoBuilder toBuilder() => UpdateReasonDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateReasonDto &&
        label == other.label &&
        customerText == other.customerText &&
        needsText == other.needsText &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customerText.hashCode);
    _$hash = $jc(_$hash, needsText.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateReasonDto')
          ..add('label', label)
          ..add('customerText', customerText)
          ..add('needsText', needsText)
          ..add('active', active))
        .toString();
  }
}

class UpdateReasonDtoBuilder
    implements Builder<UpdateReasonDto, UpdateReasonDtoBuilder> {
  _$UpdateReasonDto? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _customerText;
  String? get customerText => _$this._customerText;
  set customerText(String? customerText) => _$this._customerText = customerText;

  bool? _needsText;
  bool? get needsText => _$this._needsText;
  set needsText(bool? needsText) => _$this._needsText = needsText;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  UpdateReasonDtoBuilder() {
    UpdateReasonDto._defaults(this);
  }

  UpdateReasonDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _customerText = $v.customerText;
      _needsText = $v.needsText;
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateReasonDto other) {
    _$v = other as _$UpdateReasonDto;
  }

  @override
  void update(void Function(UpdateReasonDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateReasonDto build() => _build();

  _$UpdateReasonDto _build() {
    final _$result =
        _$v ??
        _$UpdateReasonDto._(
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'UpdateReasonDto',
            'label',
          ),
          customerText: customerText,
          needsText: BuiltValueNullFieldError.checkNotNull(
            needsText,
            r'UpdateReasonDto',
            'needsText',
          ),
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'UpdateReasonDto',
            'active',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
