// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_checklist_dto_output_images.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChecklistDtoOutputImages extends AdminChecklistDtoOutputImages {
  @override
  final int withPhoto;
  @override
  final int total;
  @override
  final int requiredPct;

  factory _$AdminChecklistDtoOutputImages([
    void Function(AdminChecklistDtoOutputImagesBuilder)? updates,
  ]) => (AdminChecklistDtoOutputImagesBuilder()..update(updates))._build();

  _$AdminChecklistDtoOutputImages._({
    required this.withPhoto,
    required this.total,
    required this.requiredPct,
  }) : super._();
  @override
  AdminChecklistDtoOutputImages rebuild(
    void Function(AdminChecklistDtoOutputImagesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChecklistDtoOutputImagesBuilder toBuilder() =>
      AdminChecklistDtoOutputImagesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChecklistDtoOutputImages &&
        withPhoto == other.withPhoto &&
        total == other.total &&
        requiredPct == other.requiredPct;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, withPhoto.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, requiredPct.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChecklistDtoOutputImages')
          ..add('withPhoto', withPhoto)
          ..add('total', total)
          ..add('requiredPct', requiredPct))
        .toString();
  }
}

class AdminChecklistDtoOutputImagesBuilder
    implements
        Builder<
          AdminChecklistDtoOutputImages,
          AdminChecklistDtoOutputImagesBuilder
        > {
  _$AdminChecklistDtoOutputImages? _$v;

  int? _withPhoto;
  int? get withPhoto => _$this._withPhoto;
  set withPhoto(int? withPhoto) => _$this._withPhoto = withPhoto;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _requiredPct;
  int? get requiredPct => _$this._requiredPct;
  set requiredPct(int? requiredPct) => _$this._requiredPct = requiredPct;

  AdminChecklistDtoOutputImagesBuilder() {
    AdminChecklistDtoOutputImages._defaults(this);
  }

  AdminChecklistDtoOutputImagesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _withPhoto = $v.withPhoto;
      _total = $v.total;
      _requiredPct = $v.requiredPct;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChecklistDtoOutputImages other) {
    _$v = other as _$AdminChecklistDtoOutputImages;
  }

  @override
  void update(void Function(AdminChecklistDtoOutputImagesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChecklistDtoOutputImages build() => _build();

  _$AdminChecklistDtoOutputImages _build() {
    final _$result =
        _$v ??
        _$AdminChecklistDtoOutputImages._(
          withPhoto: BuiltValueNullFieldError.checkNotNull(
            withPhoto,
            r'AdminChecklistDtoOutputImages',
            'withPhoto',
          ),
          total: BuiltValueNullFieldError.checkNotNull(
            total,
            r'AdminChecklistDtoOutputImages',
            'total',
          ),
          requiredPct: BuiltValueNullFieldError.checkNotNull(
            requiredPct,
            r'AdminChecklistDtoOutputImages',
            'requiredPct',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
