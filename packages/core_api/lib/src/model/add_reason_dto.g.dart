// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_reason_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AddReasonDto extends AddReasonDto {
  @override
  final String label;
  @override
  final String? customerText;
  @override
  final bool needsText;

  factory _$AddReasonDto([void Function(AddReasonDtoBuilder)? updates]) =>
      (AddReasonDtoBuilder()..update(updates))._build();

  _$AddReasonDto._({
    required this.label,
    this.customerText,
    required this.needsText,
  }) : super._();
  @override
  AddReasonDto rebuild(void Function(AddReasonDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddReasonDtoBuilder toBuilder() => AddReasonDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AddReasonDto &&
        label == other.label &&
        customerText == other.customerText &&
        needsText == other.needsText;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customerText.hashCode);
    _$hash = $jc(_$hash, needsText.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AddReasonDto')
          ..add('label', label)
          ..add('customerText', customerText)
          ..add('needsText', needsText))
        .toString();
  }
}

class AddReasonDtoBuilder
    implements Builder<AddReasonDto, AddReasonDtoBuilder> {
  _$AddReasonDto? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _customerText;
  String? get customerText => _$this._customerText;
  set customerText(String? customerText) => _$this._customerText = customerText;

  bool? _needsText;
  bool? get needsText => _$this._needsText;
  set needsText(bool? needsText) => _$this._needsText = needsText;

  AddReasonDtoBuilder() {
    AddReasonDto._defaults(this);
  }

  AddReasonDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _customerText = $v.customerText;
      _needsText = $v.needsText;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AddReasonDto other) {
    _$v = other as _$AddReasonDto;
  }

  @override
  void update(void Function(AddReasonDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AddReasonDto build() => _build();

  _$AddReasonDto _build() {
    final _$result =
        _$v ??
        _$AddReasonDto._(
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AddReasonDto',
            'label',
          ),
          customerText: customerText,
          needsText: BuiltValueNullFieldError.checkNotNull(
            needsText,
            r'AddReasonDto',
            'needsText',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
