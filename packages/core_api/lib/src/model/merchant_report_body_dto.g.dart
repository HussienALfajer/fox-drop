// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_report_body_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantReportBodyDtoSubjectEnum
_$merchantReportBodyDtoSubjectEnum_minOrder =
    const MerchantReportBodyDtoSubjectEnum._('minOrder');
const MerchantReportBodyDtoSubjectEnum
_$merchantReportBodyDtoSubjectEnum_coverage =
    const MerchantReportBodyDtoSubjectEnum._('coverage');
const MerchantReportBodyDtoSubjectEnum
_$merchantReportBodyDtoSubjectEnum_owners =
    const MerchantReportBodyDtoSubjectEnum._('owners');
const MerchantReportBodyDtoSubjectEnum
_$merchantReportBodyDtoSubjectEnum_ownerPhone =
    const MerchantReportBodyDtoSubjectEnum._('ownerPhone');

MerchantReportBodyDtoSubjectEnum _$merchantReportBodyDtoSubjectEnumValueOf(
  String name,
) {
  switch (name) {
    case 'minOrder':
      return _$merchantReportBodyDtoSubjectEnum_minOrder;
    case 'coverage':
      return _$merchantReportBodyDtoSubjectEnum_coverage;
    case 'owners':
      return _$merchantReportBodyDtoSubjectEnum_owners;
    case 'ownerPhone':
      return _$merchantReportBodyDtoSubjectEnum_ownerPhone;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantReportBodyDtoSubjectEnum>
_$merchantReportBodyDtoSubjectEnumValues =
    BuiltSet<MerchantReportBodyDtoSubjectEnum>(
      const <MerchantReportBodyDtoSubjectEnum>[
        _$merchantReportBodyDtoSubjectEnum_minOrder,
        _$merchantReportBodyDtoSubjectEnum_coverage,
        _$merchantReportBodyDtoSubjectEnum_owners,
        _$merchantReportBodyDtoSubjectEnum_ownerPhone,
      ],
    );

Serializer<MerchantReportBodyDtoSubjectEnum>
_$merchantReportBodyDtoSubjectEnumSerializer =
    _$MerchantReportBodyDtoSubjectEnumSerializer();

class _$MerchantReportBodyDtoSubjectEnumSerializer
    implements PrimitiveSerializer<MerchantReportBodyDtoSubjectEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'minOrder': 'min_order',
    'coverage': 'coverage',
    'owners': 'owners',
    'ownerPhone': 'owner_phone',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'min_order': 'minOrder',
    'coverage': 'coverage',
    'owners': 'owners',
    'owner_phone': 'ownerPhone',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantReportBodyDtoSubjectEnum];
  @override
  final String wireName = 'MerchantReportBodyDtoSubjectEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantReportBodyDtoSubjectEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantReportBodyDtoSubjectEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantReportBodyDtoSubjectEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantReportBodyDto extends MerchantReportBodyDto {
  @override
  final String typeCode;
  @override
  final String? orderId;
  @override
  final String? note;
  @override
  final MerchantReportBodyDtoSubjectEnum? subject;
  @override
  final String? photoUploadId;

  factory _$MerchantReportBodyDto([
    void Function(MerchantReportBodyDtoBuilder)? updates,
  ]) => (MerchantReportBodyDtoBuilder()..update(updates))._build();

  _$MerchantReportBodyDto._({
    required this.typeCode,
    this.orderId,
    this.note,
    this.subject,
    this.photoUploadId,
  }) : super._();
  @override
  MerchantReportBodyDto rebuild(
    void Function(MerchantReportBodyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantReportBodyDtoBuilder toBuilder() =>
      MerchantReportBodyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantReportBodyDto &&
        typeCode == other.typeCode &&
        orderId == other.orderId &&
        note == other.note &&
        subject == other.subject &&
        photoUploadId == other.photoUploadId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, typeCode.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jc(_$hash, photoUploadId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantReportBodyDto')
          ..add('typeCode', typeCode)
          ..add('orderId', orderId)
          ..add('note', note)
          ..add('subject', subject)
          ..add('photoUploadId', photoUploadId))
        .toString();
  }
}

class MerchantReportBodyDtoBuilder
    implements Builder<MerchantReportBodyDto, MerchantReportBodyDtoBuilder> {
  _$MerchantReportBodyDto? _$v;

  String? _typeCode;
  String? get typeCode => _$this._typeCode;
  set typeCode(String? typeCode) => _$this._typeCode = typeCode;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  MerchantReportBodyDtoSubjectEnum? _subject;
  MerchantReportBodyDtoSubjectEnum? get subject => _$this._subject;
  set subject(MerchantReportBodyDtoSubjectEnum? subject) =>
      _$this._subject = subject;

  String? _photoUploadId;
  String? get photoUploadId => _$this._photoUploadId;
  set photoUploadId(String? photoUploadId) =>
      _$this._photoUploadId = photoUploadId;

  MerchantReportBodyDtoBuilder() {
    MerchantReportBodyDto._defaults(this);
  }

  MerchantReportBodyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _typeCode = $v.typeCode;
      _orderId = $v.orderId;
      _note = $v.note;
      _subject = $v.subject;
      _photoUploadId = $v.photoUploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantReportBodyDto other) {
    _$v = other as _$MerchantReportBodyDto;
  }

  @override
  void update(void Function(MerchantReportBodyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantReportBodyDto build() => _build();

  _$MerchantReportBodyDto _build() {
    final _$result =
        _$v ??
        _$MerchantReportBodyDto._(
          typeCode: BuiltValueNullFieldError.checkNotNull(
            typeCode,
            r'MerchantReportBodyDto',
            'typeCode',
          ),
          orderId: orderId,
          note: note,
          subject: subject,
          photoUploadId: photoUploadId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
