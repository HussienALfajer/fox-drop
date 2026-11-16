//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_shortfall_preview_dto.g.dart';

/// AdminShortfallPreviewDto
///
/// Properties:
/// * [responsible] - Who bears the missing amount: the captain (earn.charge), the customer (dues.charge, blocked until paid) or the platform (operating cost).
@BuiltValue()
abstract class AdminShortfallPreviewDto
    implements
        Built<AdminShortfallPreviewDto, AdminShortfallPreviewDtoBuilder> {
  /// Who bears the missing amount: the captain (earn.charge), the customer (dues.charge, blocked until paid) or the platform (operating cost).
  @BuiltValueField(wireName: r'responsible')
  AdminShortfallPreviewDtoResponsibleEnum get responsible;
  // enum responsibleEnum {  captain,  customer,  platform,  };

  AdminShortfallPreviewDto._();

  factory AdminShortfallPreviewDto([
    void updates(AdminShortfallPreviewDtoBuilder b),
  ]) = _$AdminShortfallPreviewDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminShortfallPreviewDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminShortfallPreviewDto> get serializer =>
      _$AdminShortfallPreviewDtoSerializer();
}

class _$AdminShortfallPreviewDtoSerializer
    implements PrimitiveSerializer<AdminShortfallPreviewDto> {
  @override
  final Iterable<Type> types = const [
    AdminShortfallPreviewDto,
    _$AdminShortfallPreviewDto,
  ];

  @override
  final String wireName = r'AdminShortfallPreviewDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminShortfallPreviewDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(AdminShortfallPreviewDtoResponsibleEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminShortfallPreviewDto object, {
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
    required AdminShortfallPreviewDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminShortfallPreviewDtoResponsibleEnum,
                    ),
                  )
                  as AdminShortfallPreviewDtoResponsibleEnum;
          result.responsible = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminShortfallPreviewDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminShortfallPreviewDtoBuilder();
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

/// Who bears the missing amount: the captain (earn.charge), the customer (dues.charge, blocked until paid) or the platform (operating cost).
class AdminShortfallPreviewDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminShortfallPreviewDtoResponsibleEnum captain =
      _$adminShortfallPreviewDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminShortfallPreviewDtoResponsibleEnum customer =
      _$adminShortfallPreviewDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminShortfallPreviewDtoResponsibleEnum platform =
      _$adminShortfallPreviewDtoResponsibleEnum_platform;

  static Serializer<AdminShortfallPreviewDtoResponsibleEnum> get serializer =>
      _$adminShortfallPreviewDtoResponsibleEnumSerializer;

  const AdminShortfallPreviewDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminShortfallPreviewDtoResponsibleEnum> get values =>
      _$adminShortfallPreviewDtoResponsibleEnumValues;
  static AdminShortfallPreviewDtoResponsibleEnum valueOf(String name) =>
      _$adminShortfallPreviewDtoResponsibleEnumValueOf(name);
}
