// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_checklist_dto_output_images_waiver.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChecklistDtoOutputImagesWaiver
    extends AdminChecklistDtoOutputImagesWaiver {
  @override
  final DateTime at;
  @override
  final String by;

  factory _$AdminChecklistDtoOutputImagesWaiver([
    void Function(AdminChecklistDtoOutputImagesWaiverBuilder)? updates,
  ]) =>
      (AdminChecklistDtoOutputImagesWaiverBuilder()..update(updates))._build();

  _$AdminChecklistDtoOutputImagesWaiver._({required this.at, required this.by})
    : super._();
  @override
  AdminChecklistDtoOutputImagesWaiver rebuild(
    void Function(AdminChecklistDtoOutputImagesWaiverBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChecklistDtoOutputImagesWaiverBuilder toBuilder() =>
      AdminChecklistDtoOutputImagesWaiverBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChecklistDtoOutputImagesWaiver &&
        at == other.at &&
        by == other.by;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, by.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChecklistDtoOutputImagesWaiver')
          ..add('at', at)
          ..add('by', by))
        .toString();
  }
}

class AdminChecklistDtoOutputImagesWaiverBuilder
    implements
        Builder<
          AdminChecklistDtoOutputImagesWaiver,
          AdminChecklistDtoOutputImagesWaiverBuilder
        > {
  _$AdminChecklistDtoOutputImagesWaiver? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _by;
  String? get by => _$this._by;
  set by(String? by) => _$this._by = by;

  AdminChecklistDtoOutputImagesWaiverBuilder() {
    AdminChecklistDtoOutputImagesWaiver._defaults(this);
  }

  AdminChecklistDtoOutputImagesWaiverBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _by = $v.by;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChecklistDtoOutputImagesWaiver other) {
    _$v = other as _$AdminChecklistDtoOutputImagesWaiver;
  }

  @override
  void update(
    void Function(AdminChecklistDtoOutputImagesWaiverBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminChecklistDtoOutputImagesWaiver build() => _build();

  _$AdminChecklistDtoOutputImagesWaiver _build() {
    final _$result =
        _$v ??
        _$AdminChecklistDtoOutputImagesWaiver._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminChecklistDtoOutputImagesWaiver',
            'at',
          ),
          by: BuiltValueNullFieldError.checkNotNull(
            by,
            r'AdminChecklistDtoOutputImagesWaiver',
            'by',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
