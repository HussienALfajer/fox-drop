//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reject_compensation_dto.g.dart';

/// AdminRejectCompensationDto
///
/// Properties:
/// * [cityId]
@BuiltValue()
abstract class AdminRejectCompensationDto
    implements
        Built<AdminRejectCompensationDto, AdminRejectCompensationDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  AdminRejectCompensationDto._();

  factory AdminRejectCompensationDto([
    void updates(AdminRejectCompensationDtoBuilder b),
  ]) = _$AdminRejectCompensationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRejectCompensationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRejectCompensationDto> get serializer =>
      _$AdminRejectCompensationDtoSerializer();
}

class _$AdminRejectCompensationDtoSerializer
    implements PrimitiveSerializer<AdminRejectCompensationDto> {
  @override
  final Iterable<Type> types = const [
    AdminRejectCompensationDto,
    _$AdminRejectCompensationDto,
  ];

  @override
  final String wireName = r'AdminRejectCompensationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRejectCompensationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRejectCompensationDto object, {
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
    required AdminRejectCompensationDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRejectCompensationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRejectCompensationDtoBuilder();
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
