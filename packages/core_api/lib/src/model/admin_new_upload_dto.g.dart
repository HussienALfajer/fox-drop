// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_new_upload_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminNewUploadDtoPurposeEnum
_$adminNewUploadDtoPurposeEnum_restaurantLogo =
    const AdminNewUploadDtoPurposeEnum._('restaurantLogo');
const AdminNewUploadDtoPurposeEnum
_$adminNewUploadDtoPurposeEnum_restaurantCover =
    const AdminNewUploadDtoPurposeEnum._('restaurantCover');
const AdminNewUploadDtoPurposeEnum _$adminNewUploadDtoPurposeEnum_itemPhoto =
    const AdminNewUploadDtoPurposeEnum._('itemPhoto');

AdminNewUploadDtoPurposeEnum _$adminNewUploadDtoPurposeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'restaurantLogo':
      return _$adminNewUploadDtoPurposeEnum_restaurantLogo;
    case 'restaurantCover':
      return _$adminNewUploadDtoPurposeEnum_restaurantCover;
    case 'itemPhoto':
      return _$adminNewUploadDtoPurposeEnum_itemPhoto;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminNewUploadDtoPurposeEnum>
_$adminNewUploadDtoPurposeEnumValues =
    BuiltSet<AdminNewUploadDtoPurposeEnum>(const <AdminNewUploadDtoPurposeEnum>[
      _$adminNewUploadDtoPurposeEnum_restaurantLogo,
      _$adminNewUploadDtoPurposeEnum_restaurantCover,
      _$adminNewUploadDtoPurposeEnum_itemPhoto,
    ]);

const AdminNewUploadDtoContentTypeEnum
_$adminNewUploadDtoContentTypeEnum_imageSlashJpeg =
    const AdminNewUploadDtoContentTypeEnum._('imageSlashJpeg');
const AdminNewUploadDtoContentTypeEnum
_$adminNewUploadDtoContentTypeEnum_imageSlashPng =
    const AdminNewUploadDtoContentTypeEnum._('imageSlashPng');
const AdminNewUploadDtoContentTypeEnum
_$adminNewUploadDtoContentTypeEnum_imageSlashWebp =
    const AdminNewUploadDtoContentTypeEnum._('imageSlashWebp');

AdminNewUploadDtoContentTypeEnum _$adminNewUploadDtoContentTypeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$adminNewUploadDtoContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$adminNewUploadDtoContentTypeEnum_imageSlashPng;
    case 'imageSlashWebp':
      return _$adminNewUploadDtoContentTypeEnum_imageSlashWebp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminNewUploadDtoContentTypeEnum>
_$adminNewUploadDtoContentTypeEnumValues =
    BuiltSet<AdminNewUploadDtoContentTypeEnum>(
      const <AdminNewUploadDtoContentTypeEnum>[
        _$adminNewUploadDtoContentTypeEnum_imageSlashJpeg,
        _$adminNewUploadDtoContentTypeEnum_imageSlashPng,
        _$adminNewUploadDtoContentTypeEnum_imageSlashWebp,
      ],
    );

Serializer<AdminNewUploadDtoPurposeEnum>
_$adminNewUploadDtoPurposeEnumSerializer =
    _$AdminNewUploadDtoPurposeEnumSerializer();
Serializer<AdminNewUploadDtoContentTypeEnum>
_$adminNewUploadDtoContentTypeEnumSerializer =
    _$AdminNewUploadDtoContentTypeEnumSerializer();

class _$AdminNewUploadDtoPurposeEnumSerializer
    implements PrimitiveSerializer<AdminNewUploadDtoPurposeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurantLogo': 'restaurant_logo',
    'restaurantCover': 'restaurant_cover',
    'itemPhoto': 'item_photo',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant_logo': 'restaurantLogo',
    'restaurant_cover': 'restaurantCover',
    'item_photo': 'itemPhoto',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminNewUploadDtoPurposeEnum];
  @override
  final String wireName = 'AdminNewUploadDtoPurposeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminNewUploadDtoPurposeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminNewUploadDtoPurposeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminNewUploadDtoPurposeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminNewUploadDtoContentTypeEnumSerializer
    implements PrimitiveSerializer<AdminNewUploadDtoContentTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'imageSlashJpeg': 'image/jpeg',
    'imageSlashPng': 'image/png',
    'imageSlashWebp': 'image/webp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'image/jpeg': 'imageSlashJpeg',
    'image/png': 'imageSlashPng',
    'image/webp': 'imageSlashWebp',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminNewUploadDtoContentTypeEnum];
  @override
  final String wireName = 'AdminNewUploadDtoContentTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminNewUploadDtoContentTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminNewUploadDtoContentTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminNewUploadDtoContentTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminNewUploadDto extends AdminNewUploadDto {
  @override
  final AdminNewUploadDtoPurposeEnum purpose;
  @override
  final AdminNewUploadDtoContentTypeEnum contentType;
  @override
  final int sizeBytes;

  factory _$AdminNewUploadDto([
    void Function(AdminNewUploadDtoBuilder)? updates,
  ]) => (AdminNewUploadDtoBuilder()..update(updates))._build();

  _$AdminNewUploadDto._({
    required this.purpose,
    required this.contentType,
    required this.sizeBytes,
  }) : super._();
  @override
  AdminNewUploadDto rebuild(void Function(AdminNewUploadDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminNewUploadDtoBuilder toBuilder() =>
      AdminNewUploadDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminNewUploadDto &&
        purpose == other.purpose &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminNewUploadDto')
          ..add('purpose', purpose)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class AdminNewUploadDtoBuilder
    implements Builder<AdminNewUploadDto, AdminNewUploadDtoBuilder> {
  _$AdminNewUploadDto? _$v;

  AdminNewUploadDtoPurposeEnum? _purpose;
  AdminNewUploadDtoPurposeEnum? get purpose => _$this._purpose;
  set purpose(AdminNewUploadDtoPurposeEnum? purpose) =>
      _$this._purpose = purpose;

  AdminNewUploadDtoContentTypeEnum? _contentType;
  AdminNewUploadDtoContentTypeEnum? get contentType => _$this._contentType;
  set contentType(AdminNewUploadDtoContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  AdminNewUploadDtoBuilder() {
    AdminNewUploadDto._defaults(this);
  }

  AdminNewUploadDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _purpose = $v.purpose;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminNewUploadDto other) {
    _$v = other as _$AdminNewUploadDto;
  }

  @override
  void update(void Function(AdminNewUploadDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminNewUploadDto build() => _build();

  _$AdminNewUploadDto _build() {
    final _$result =
        _$v ??
        _$AdminNewUploadDto._(
          purpose: BuiltValueNullFieldError.checkNotNull(
            purpose,
            r'AdminNewUploadDto',
            'purpose',
          ),
          contentType: BuiltValueNullFieldError.checkNotNull(
            contentType,
            r'AdminNewUploadDto',
            'contentType',
          ),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
            sizeBytes,
            r'AdminNewUploadDto',
            'sizeBytes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
