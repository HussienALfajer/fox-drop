// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_new_upload_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantNewUploadDtoContentTypeEnum
_$merchantNewUploadDtoContentTypeEnum_imageSlashJpeg =
    const MerchantNewUploadDtoContentTypeEnum._('imageSlashJpeg');
const MerchantNewUploadDtoContentTypeEnum
_$merchantNewUploadDtoContentTypeEnum_imageSlashPng =
    const MerchantNewUploadDtoContentTypeEnum._('imageSlashPng');
const MerchantNewUploadDtoContentTypeEnum
_$merchantNewUploadDtoContentTypeEnum_imageSlashWebp =
    const MerchantNewUploadDtoContentTypeEnum._('imageSlashWebp');

MerchantNewUploadDtoContentTypeEnum
_$merchantNewUploadDtoContentTypeEnumValueOf(String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$merchantNewUploadDtoContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$merchantNewUploadDtoContentTypeEnum_imageSlashPng;
    case 'imageSlashWebp':
      return _$merchantNewUploadDtoContentTypeEnum_imageSlashWebp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantNewUploadDtoContentTypeEnum>
_$merchantNewUploadDtoContentTypeEnumValues =
    BuiltSet<MerchantNewUploadDtoContentTypeEnum>(
      const <MerchantNewUploadDtoContentTypeEnum>[
        _$merchantNewUploadDtoContentTypeEnum_imageSlashJpeg,
        _$merchantNewUploadDtoContentTypeEnum_imageSlashPng,
        _$merchantNewUploadDtoContentTypeEnum_imageSlashWebp,
      ],
    );

Serializer<MerchantNewUploadDtoContentTypeEnum>
_$merchantNewUploadDtoContentTypeEnumSerializer =
    _$MerchantNewUploadDtoContentTypeEnumSerializer();

class _$MerchantNewUploadDtoContentTypeEnumSerializer
    implements PrimitiveSerializer<MerchantNewUploadDtoContentTypeEnum> {
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
  final Iterable<Type> types = const <Type>[
    MerchantNewUploadDtoContentTypeEnum,
  ];
  @override
  final String wireName = 'MerchantNewUploadDtoContentTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantNewUploadDtoContentTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantNewUploadDtoContentTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantNewUploadDtoContentTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantNewUploadDto extends MerchantNewUploadDto {
  @override
  final MerchantNewUploadDtoContentTypeEnum contentType;
  @override
  final int sizeBytes;

  factory _$MerchantNewUploadDto([
    void Function(MerchantNewUploadDtoBuilder)? updates,
  ]) => (MerchantNewUploadDtoBuilder()..update(updates))._build();

  _$MerchantNewUploadDto._({required this.contentType, required this.sizeBytes})
    : super._();
  @override
  MerchantNewUploadDto rebuild(
    void Function(MerchantNewUploadDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantNewUploadDtoBuilder toBuilder() =>
      MerchantNewUploadDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantNewUploadDto &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantNewUploadDto')
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class MerchantNewUploadDtoBuilder
    implements Builder<MerchantNewUploadDto, MerchantNewUploadDtoBuilder> {
  _$MerchantNewUploadDto? _$v;

  MerchantNewUploadDtoContentTypeEnum? _contentType;
  MerchantNewUploadDtoContentTypeEnum? get contentType => _$this._contentType;
  set contentType(MerchantNewUploadDtoContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  MerchantNewUploadDtoBuilder() {
    MerchantNewUploadDto._defaults(this);
  }

  MerchantNewUploadDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantNewUploadDto other) {
    _$v = other as _$MerchantNewUploadDto;
  }

  @override
  void update(void Function(MerchantNewUploadDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantNewUploadDto build() => _build();

  _$MerchantNewUploadDto _build() {
    final _$result =
        _$v ??
        _$MerchantNewUploadDto._(
          contentType: BuiltValueNullFieldError.checkNotNull(
            contentType,
            r'MerchantNewUploadDto',
            'contentType',
          ),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
            sizeBytes,
            r'MerchantNewUploadDto',
            'sizeBytes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
