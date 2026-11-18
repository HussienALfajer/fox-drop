// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_images_waiver_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminImagesWaiverDto extends AdminImagesWaiverDto {
  @override
  final bool waived;

  factory _$AdminImagesWaiverDto([
    void Function(AdminImagesWaiverDtoBuilder)? updates,
  ]) => (AdminImagesWaiverDtoBuilder()..update(updates))._build();

  _$AdminImagesWaiverDto._({required this.waived}) : super._();
  @override
  AdminImagesWaiverDto rebuild(
    void Function(AdminImagesWaiverDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminImagesWaiverDtoBuilder toBuilder() =>
      AdminImagesWaiverDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminImagesWaiverDto && waived == other.waived;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, waived.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminImagesWaiverDto',
    )..add('waived', waived)).toString();
  }
}

class AdminImagesWaiverDtoBuilder
    implements Builder<AdminImagesWaiverDto, AdminImagesWaiverDtoBuilder> {
  _$AdminImagesWaiverDto? _$v;

  bool? _waived;
  bool? get waived => _$this._waived;
  set waived(bool? waived) => _$this._waived = waived;

  AdminImagesWaiverDtoBuilder() {
    AdminImagesWaiverDto._defaults(this);
  }

  AdminImagesWaiverDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _waived = $v.waived;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminImagesWaiverDto other) {
    _$v = other as _$AdminImagesWaiverDto;
  }

  @override
  void update(void Function(AdminImagesWaiverDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminImagesWaiverDto build() => _build();

  _$AdminImagesWaiverDto _build() {
    final _$result =
        _$v ??
        _$AdminImagesWaiverDto._(
          waived: BuiltValueNullFieldError.checkNotNull(
            waived,
            r'AdminImagesWaiverDto',
            'waived',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
