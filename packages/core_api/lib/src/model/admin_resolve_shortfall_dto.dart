//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_resolve_shortfall_dto.g.dart';

/// AdminResolveShortfallDto
///
/// Properties:
/// * [responsible] - Who bears the missing amount: the captain (earn.charge), the customer (dues.charge, blocked until paid) or the platform (operating cost).
/// * [reason] - Required: the internal note, never shown to the apps.
@BuiltValue()
abstract class AdminResolveShortfallDto
    implements
        Built<AdminResolveShortfallDto, AdminResolveShortfallDtoBuilder> {
  /// Who bears the missing amount: the captain (earn.charge), the customer (dues.charge, blocked until paid) or the platform (operating cost).
  @BuiltValueField(wireName: r'responsible')
  AdminResolveShortfallDtoResponsibleEnum get responsible;
  // enum responsibleEnum {  captain,  customer,  platform,  };

  /// Required: the internal note, never shown to the apps.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminResolveShortfallDto._();

  factory AdminResolveShortfallDto([
    void updates(AdminResolveShortfallDtoBuilder b),
  ]) = _$AdminResolveShortfallDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminResolveShortfallDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminResolveShortfallDto> get serializer =>
      _$AdminResolveShortfallDtoSerializer();
}

class _$AdminResolveShortfallDtoSerializer
    implements PrimitiveSerializer<AdminResolveShortfallDto> {
  @override
  final Iterable<Type> types = const [
    AdminResolveShortfallDto,
    _$AdminResolveShortfallDto,
  ];

  @override
  final String wireName = r'AdminResolveShortfallDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminResolveShortfallDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(AdminResolveShortfallDtoResponsibleEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminResolveShortfallDto object, {
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
    required AdminResolveShortfallDtoBuilder result,
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
                      AdminResolveShortfallDtoResponsibleEnum,
                    ),
                  )
                  as AdminResolveShortfallDtoResponsibleEnum;
          result.responsible = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminResolveShortfallDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminResolveShortfallDtoBuilder();
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
class AdminResolveShortfallDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminResolveShortfallDtoResponsibleEnum captain =
      _$adminResolveShortfallDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminResolveShortfallDtoResponsibleEnum customer =
      _$adminResolveShortfallDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminResolveShortfallDtoResponsibleEnum platform =
      _$adminResolveShortfallDtoResponsibleEnum_platform;

  static Serializer<AdminResolveShortfallDtoResponsibleEnum> get serializer =>
      _$adminResolveShortfallDtoResponsibleEnumSerializer;

  const AdminResolveShortfallDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminResolveShortfallDtoResponsibleEnum> get values =>
      _$adminResolveShortfallDtoResponsibleEnumValues;
  static AdminResolveShortfallDtoResponsibleEnum valueOf(String name) =>
      _$adminResolveShortfallDtoResponsibleEnumValueOf(name);
}
