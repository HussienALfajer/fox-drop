//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_new_home_section_dto.g.dart';

/// AdminNewHomeSectionDto
///
/// Properties:
/// * [cityId]
/// * [title] - Trimmed, 1 to 40 characters.
/// * [restaurantIds] - 1 to 30 of the city's restaurants, in the home's order.
@BuiltValue()
abstract class AdminNewHomeSectionDto
    implements Built<AdminNewHomeSectionDto, AdminNewHomeSectionDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Trimmed, 1 to 40 characters.
  @BuiltValueField(wireName: r'title')
  String get title;

  /// 1 to 30 of the city's restaurants, in the home's order.
  @BuiltValueField(wireName: r'restaurantIds')
  BuiltList<String> get restaurantIds;

  AdminNewHomeSectionDto._();

  factory AdminNewHomeSectionDto([
    void updates(AdminNewHomeSectionDtoBuilder b),
  ]) = _$AdminNewHomeSectionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminNewHomeSectionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNewHomeSectionDto> get serializer =>
      _$AdminNewHomeSectionDtoSerializer();
}

class _$AdminNewHomeSectionDtoSerializer
    implements PrimitiveSerializer<AdminNewHomeSectionDto> {
  @override
  final Iterable<Type> types = const [
    AdminNewHomeSectionDto,
    _$AdminNewHomeSectionDto,
  ];

  @override
  final String wireName = r'AdminNewHomeSectionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNewHomeSectionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'restaurantIds';
    yield serializers.serialize(
      object.restaurantIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminNewHomeSectionDto object, {
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
    required AdminNewHomeSectionDtoBuilder result,
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
        case r'title':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.title = valueDes;
          break;
        case r'restaurantIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.restaurantIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminNewHomeSectionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNewHomeSectionDtoBuilder();
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
