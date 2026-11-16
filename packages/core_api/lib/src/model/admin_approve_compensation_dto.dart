//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_approve_compensation_dto_value.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_approve_compensation_dto.g.dart';

/// AdminApproveCompensationDto
///
/// Properties:
/// * [cityId]
/// * [value]
@BuiltValue()
abstract class AdminApproveCompensationDto
    implements
        Built<AdminApproveCompensationDto, AdminApproveCompensationDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'value')
  AdminApproveCompensationDtoValue? get value;

  AdminApproveCompensationDto._();

  factory AdminApproveCompensationDto([
    void updates(AdminApproveCompensationDtoBuilder b),
  ]) = _$AdminApproveCompensationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminApproveCompensationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminApproveCompensationDto> get serializer =>
      _$AdminApproveCompensationDtoSerializer();
}

class _$AdminApproveCompensationDtoSerializer
    implements PrimitiveSerializer<AdminApproveCompensationDto> {
  @override
  final Iterable<Type> types = const [
    AdminApproveCompensationDto,
    _$AdminApproveCompensationDto,
  ];

  @override
  final String wireName = r'AdminApproveCompensationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminApproveCompensationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield object.value == null
        ? null
        : serializers.serialize(
            object.value,
            specifiedType: const FullType.nullable(
              AdminApproveCompensationDtoValue,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminApproveCompensationDto object, {
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
    required AdminApproveCompensationDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'value':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminApproveCompensationDtoValue,
                    ),
                  )
                  as AdminApproveCompensationDtoValue?;
          if (valueDes == null) continue;
          result.value.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminApproveCompensationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminApproveCompensationDtoBuilder();
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
