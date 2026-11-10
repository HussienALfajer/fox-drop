// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_preview_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEditPreviewDto extends AdminEditPreviewDto {
  @override
  final BuiltList<AdminEditDtoKeepInner> keep;
  @override
  final BuiltList<AdminEditDtoAddInner> add;
  @override
  final String? deliveryFee;
  @override
  final int? extraPrepMin;

  factory _$AdminEditPreviewDto([
    void Function(AdminEditPreviewDtoBuilder)? updates,
  ]) => (AdminEditPreviewDtoBuilder()..update(updates))._build();

  _$AdminEditPreviewDto._({
    required this.keep,
    required this.add,
    this.deliveryFee,
    this.extraPrepMin,
  }) : super._();
  @override
  AdminEditPreviewDto rebuild(
    void Function(AdminEditPreviewDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEditPreviewDtoBuilder toBuilder() =>
      AdminEditPreviewDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditPreviewDto &&
        keep == other.keep &&
        add == other.add &&
        deliveryFee == other.deliveryFee &&
        extraPrepMin == other.extraPrepMin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, keep.hashCode);
    _$hash = $jc(_$hash, add.hashCode);
    _$hash = $jc(_$hash, deliveryFee.hashCode);
    _$hash = $jc(_$hash, extraPrepMin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEditPreviewDto')
          ..add('keep', keep)
          ..add('add', add)
          ..add('deliveryFee', deliveryFee)
          ..add('extraPrepMin', extraPrepMin))
        .toString();
  }
}

class AdminEditPreviewDtoBuilder
    implements Builder<AdminEditPreviewDto, AdminEditPreviewDtoBuilder> {
  _$AdminEditPreviewDto? _$v;

  ListBuilder<AdminEditDtoKeepInner>? _keep;
  ListBuilder<AdminEditDtoKeepInner> get keep =>
      _$this._keep ??= ListBuilder<AdminEditDtoKeepInner>();
  set keep(ListBuilder<AdminEditDtoKeepInner>? keep) => _$this._keep = keep;

  ListBuilder<AdminEditDtoAddInner>? _add;
  ListBuilder<AdminEditDtoAddInner> get add =>
      _$this._add ??= ListBuilder<AdminEditDtoAddInner>();
  set add(ListBuilder<AdminEditDtoAddInner>? add) => _$this._add = add;

  String? _deliveryFee;
  String? get deliveryFee => _$this._deliveryFee;
  set deliveryFee(String? deliveryFee) => _$this._deliveryFee = deliveryFee;

  int? _extraPrepMin;
  int? get extraPrepMin => _$this._extraPrepMin;
  set extraPrepMin(int? extraPrepMin) => _$this._extraPrepMin = extraPrepMin;

  AdminEditPreviewDtoBuilder() {
    AdminEditPreviewDto._defaults(this);
  }

  AdminEditPreviewDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _keep = $v.keep.toBuilder();
      _add = $v.add.toBuilder();
      _deliveryFee = $v.deliveryFee;
      _extraPrepMin = $v.extraPrepMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEditPreviewDto other) {
    _$v = other as _$AdminEditPreviewDto;
  }

  @override
  void update(void Function(AdminEditPreviewDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditPreviewDto build() => _build();

  _$AdminEditPreviewDto _build() {
    _$AdminEditPreviewDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminEditPreviewDto._(
            keep: keep.build(),
            add: add.build(),
            deliveryFee: deliveryFee,
            extraPrepMin: extraPrepMin,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'keep';
        keep.build();
        _$failedField = 'add';
        add.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminEditPreviewDto',
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
