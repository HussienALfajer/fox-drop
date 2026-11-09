//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurants_dto_output_restaurants_inner.g.dart';

/// AdminRestaurantsDtoOutputRestaurantsInner
///
/// Properties:
/// * [id]
/// * [nameAr]
@BuiltValue()
abstract class AdminRestaurantsDtoOutputRestaurantsInner
    implements
        Built<
          AdminRestaurantsDtoOutputRestaurantsInner,
          AdminRestaurantsDtoOutputRestaurantsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  AdminRestaurantsDtoOutputRestaurantsInner._();

  factory AdminRestaurantsDtoOutputRestaurantsInner([
    void updates(AdminRestaurantsDtoOutputRestaurantsInnerBuilder b),
  ]) = _$AdminRestaurantsDtoOutputRestaurantsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantsDtoOutputRestaurantsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantsDtoOutputRestaurantsInner> get serializer =>
      _$AdminRestaurantsDtoOutputRestaurantsInnerSerializer();
}

class _$AdminRestaurantsDtoOutputRestaurantsInnerSerializer
    implements PrimitiveSerializer<AdminRestaurantsDtoOutputRestaurantsInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantsDtoOutputRestaurantsInner,
    _$AdminRestaurantsDtoOutputRestaurantsInner,
  ];

  @override
  final String wireName = r'AdminRestaurantsDtoOutputRestaurantsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantsDtoOutputRestaurantsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantsDtoOutputRestaurantsInner object, {
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
    required AdminRestaurantsDtoOutputRestaurantsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'nameAr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nameAr = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantsDtoOutputRestaurantsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantsDtoOutputRestaurantsInnerBuilder();
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
