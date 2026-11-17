// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_new_upload_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerNewUploadDtoContentTypeEnum
_$customerNewUploadDtoContentTypeEnum_imageSlashJpeg =
    const CustomerNewUploadDtoContentTypeEnum._('imageSlashJpeg');
const CustomerNewUploadDtoContentTypeEnum
_$customerNewUploadDtoContentTypeEnum_imageSlashPng =
    const CustomerNewUploadDtoContentTypeEnum._('imageSlashPng');
const CustomerNewUploadDtoContentTypeEnum
_$customerNewUploadDtoContentTypeEnum_imageSlashWebp =
    const CustomerNewUploadDtoContentTypeEnum._('imageSlashWebp');

CustomerNewUploadDtoContentTypeEnum
_$customerNewUploadDtoContentTypeEnumValueOf(String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$customerNewUploadDtoContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$customerNewUploadDtoContentTypeEnum_imageSlashPng;
    case 'imageSlashWebp':
      return _$customerNewUploadDtoContentTypeEnum_imageSlashWebp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerNewUploadDtoContentTypeEnum>
_$customerNewUploadDtoContentTypeEnumValues =
    BuiltSet<CustomerNewUploadDtoContentTypeEnum>(
      const <CustomerNewUploadDtoContentTypeEnum>[
        _$customerNewUploadDtoContentTypeEnum_imageSlashJpeg,
        _$customerNewUploadDtoContentTypeEnum_imageSlashPng,
        _$customerNewUploadDtoContentTypeEnum_imageSlashWebp,
      ],
    );

Serializer<CustomerNewUploadDtoContentTypeEnum>
_$customerNewUploadDtoContentTypeEnumSerializer =
    _$CustomerNewUploadDtoContentTypeEnumSerializer();

class _$CustomerNewUploadDtoContentTypeEnumSerializer
    implements PrimitiveSerializer<CustomerNewUploadDtoContentTypeEnum> {
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
    CustomerNewUploadDtoContentTypeEnum,
  ];
  @override
  final String wireName = 'CustomerNewUploadDtoContentTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerNewUploadDtoContentTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerNewUploadDtoContentTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerNewUploadDtoContentTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerNewUploadDto extends CustomerNewUploadDto {
  @override
  final CustomerNewUploadDtoContentTypeEnum contentType;
  @override
  final int sizeBytes;

  factory _$CustomerNewUploadDto([
    void Function(CustomerNewUploadDtoBuilder)? updates,
  ]) => (CustomerNewUploadDtoBuilder()..update(updates))._build();

  _$CustomerNewUploadDto._({required this.contentType, required this.sizeBytes})
    : super._();
  @override
  CustomerNewUploadDto rebuild(
    void Function(CustomerNewUploadDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerNewUploadDtoBuilder toBuilder() =>
      CustomerNewUploadDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerNewUploadDto &&
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
    return (newBuiltValueToStringHelper(r'CustomerNewUploadDto')
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class CustomerNewUploadDtoBuilder
    implements Builder<CustomerNewUploadDto, CustomerNewUploadDtoBuilder> {
  _$CustomerNewUploadDto? _$v;

  CustomerNewUploadDtoContentTypeEnum? _contentType;
  CustomerNewUploadDtoContentTypeEnum? get contentType => _$this._contentType;
  set contentType(CustomerNewUploadDtoContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  CustomerNewUploadDtoBuilder() {
    CustomerNewUploadDto._defaults(this);
  }

  CustomerNewUploadDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerNewUploadDto other) {
    _$v = other as _$CustomerNewUploadDto;
  }

  @override
  void update(void Function(CustomerNewUploadDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerNewUploadDto build() => _build();

  _$CustomerNewUploadDto _build() {
    final _$result =
        _$v ??
        _$CustomerNewUploadDto._(
          contentType: BuiltValueNullFieldError.checkNotNull(
            contentType,
            r'CustomerNewUploadDto',
            'contentType',
          ),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
            sizeBytes,
            r'CustomerNewUploadDto',
            'sizeBytes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
