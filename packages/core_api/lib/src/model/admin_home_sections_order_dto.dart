//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_home_sections_order_dto.g.dart';

/// AdminHomeSectionsOrderDto
///
/// Properties:
/// * [cityId]
/// * [keys] - Every section of the city once, in the new order.
@BuiltValue()
abstract class AdminHomeSectionsOrderDto
    implements
        Built<AdminHomeSectionsOrderDto, AdminHomeSectionsOrderDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Every section of the city once, in the new order.
  @BuiltValueField(wireName: r'keys')
  BuiltList<String> get keys;

  AdminHomeSectionsOrderDto._();

  factory AdminHomeSectionsOrderDto([
    void updates(AdminHomeSectionsOrderDtoBuilder b),
  ]) = _$AdminHomeSectionsOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHomeSectionsOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHomeSectionsOrderDto> get serializer =>
      _$AdminHomeSectionsOrderDtoSerializer();
}

class _$AdminHomeSectionsOrderDtoSerializer
    implements PrimitiveSerializer<AdminHomeSectionsOrderDto> {
  @override
  final Iterable<Type> types = const [
    AdminHomeSectionsOrderDto,
    _$AdminHomeSectionsOrderDto,
  ];

  @override
  final String wireName = r'AdminHomeSectionsOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHomeSectionsOrderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'keys';
    yield serializers.serialize(
      object.keys,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminHomeSectionsOrderDto object, {
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
    required AdminHomeSectionsOrderDtoBuilder result,
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
        case r'keys':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.keys.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminHomeSectionsOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHomeSectionsOrderDtoBuilder();
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
