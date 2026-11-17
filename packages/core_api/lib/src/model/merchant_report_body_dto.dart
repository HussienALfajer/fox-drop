//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_report_body_dto.g.dart';

/// MerchantReportBodyDto
///
/// Properties:
/// * [typeCode] - A code of Content's merchant_ticket_type list (RA Appendix C).
/// * [orderId] - Optional: one of the restaurant's orders.
/// * [note] - Optional, up to 300 characters; the text of «أخرى».
/// * [subject] - «طلب تعديل بيانات» (data_change) only, and required with it.
/// * [photoUploadId] - One photo at most, from POST /v1/merchant/uploads/report-photo once uploaded.
@BuiltValue()
abstract class MerchantReportBodyDto
    implements Built<MerchantReportBodyDto, MerchantReportBodyDtoBuilder> {
  /// A code of Content's merchant_ticket_type list (RA Appendix C).
  @BuiltValueField(wireName: r'typeCode')
  String get typeCode;

  /// Optional: one of the restaurant's orders.
  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  /// Optional, up to 300 characters; the text of «أخرى».
  @BuiltValueField(wireName: r'note')
  String? get note;

  /// «طلب تعديل بيانات» (data_change) only, and required with it.
  @BuiltValueField(wireName: r'subject')
  MerchantReportBodyDtoSubjectEnum? get subject;
  // enum subjectEnum {  min_order,  coverage,  owners,  owner_phone,  };

  /// One photo at most, from POST /v1/merchant/uploads/report-photo once uploaded.
  @BuiltValueField(wireName: r'photoUploadId')
  String? get photoUploadId;

  MerchantReportBodyDto._();

  factory MerchantReportBodyDto([
    void updates(MerchantReportBodyDtoBuilder b),
  ]) = _$MerchantReportBodyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantReportBodyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantReportBodyDto> get serializer =>
      _$MerchantReportBodyDtoSerializer();
}

class _$MerchantReportBodyDtoSerializer
    implements PrimitiveSerializer<MerchantReportBodyDto> {
  @override
  final Iterable<Type> types = const [
    MerchantReportBodyDto,
    _$MerchantReportBodyDto,
  ];

  @override
  final String wireName = r'MerchantReportBodyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantReportBodyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'typeCode';
    yield serializers.serialize(
      object.typeCode,
      specifiedType: const FullType(String),
    );
    yield r'orderId';
    yield object.orderId == null
        ? null
        : serializers.serialize(
            object.orderId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'subject';
    yield object.subject == null
        ? null
        : serializers.serialize(
            object.subject,
            specifiedType: const FullType.nullable(
              MerchantReportBodyDtoSubjectEnum,
            ),
          );
    yield r'photoUploadId';
    yield object.photoUploadId == null
        ? null
        : serializers.serialize(
            object.photoUploadId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantReportBodyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantReportBodyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'typeCode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeCode = valueDes;
          break;
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'subject':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantReportBodyDtoSubjectEnum,
                    ),
                  )
                  as MerchantReportBodyDtoSubjectEnum?;
          if (valueDes == null) continue;
          result.subject = valueDes;
          break;
        case r'photoUploadId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.photoUploadId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantReportBodyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantReportBodyDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

/// «طلب تعديل بيانات» (data_change) only, and required with it.
class MerchantReportBodyDtoSubjectEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'min_order')
  static const MerchantReportBodyDtoSubjectEnum minOrder =
      _$merchantReportBodyDtoSubjectEnum_minOrder;
  @BuiltValueEnumConst(wireName: r'coverage')
  static const MerchantReportBodyDtoSubjectEnum coverage =
      _$merchantReportBodyDtoSubjectEnum_coverage;
  @BuiltValueEnumConst(wireName: r'owners')
  static const MerchantReportBodyDtoSubjectEnum owners =
      _$merchantReportBodyDtoSubjectEnum_owners;
  @BuiltValueEnumConst(wireName: r'owner_phone')
  static const MerchantReportBodyDtoSubjectEnum ownerPhone =
      _$merchantReportBodyDtoSubjectEnum_ownerPhone;

  static Serializer<MerchantReportBodyDtoSubjectEnum> get serializer =>
      _$merchantReportBodyDtoSubjectEnumSerializer;

  const MerchantReportBodyDtoSubjectEnum._(String name) : super(name);

  static BuiltSet<MerchantReportBodyDtoSubjectEnum> get values =>
      _$merchantReportBodyDtoSubjectEnumValues;
  static MerchantReportBodyDtoSubjectEnum valueOf(String name) =>
      _$merchantReportBodyDtoSubjectEnumValueOf(name);
}
