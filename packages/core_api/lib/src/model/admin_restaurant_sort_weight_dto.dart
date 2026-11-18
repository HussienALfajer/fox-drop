//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_sort_weight_dto.g.dart';

/// AdminRestaurantSortWeightDto
///
/// Properties:
/// * [sortWeight] - 0 to 1000, the higher first.
@BuiltValue()
abstract class AdminRestaurantSortWeightDto
    implements
        Built<
          AdminRestaurantSortWeightDto,
          AdminRestaurantSortWeightDtoBuilder
        > {
  /// 0 to 1000, the higher first.
  @BuiltValueField(wireName: r'sortWeight')
  int get sortWeight;

  AdminRestaurantSortWeightDto._();

  factory AdminRestaurantSortWeightDto([
    void updates(AdminRestaurantSortWeightDtoBuilder b),
  ]) = _$AdminRestaurantSortWeightDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantSortWeightDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantSortWeightDto> get serializer =>
      _$AdminRestaurantSortWeightDtoSerializer();
}

class _$AdminRestaurantSortWeightDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantSortWeightDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantSortWeightDto,
    _$AdminRestaurantSortWeightDto,
  ];

  @override
  final String wireName = r'AdminRestaurantSortWeightDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantSortWeightDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sortWeight';
    yield serializers.serialize(
      object.sortWeight,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSortWeightDto object, {
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
    required AdminRestaurantSortWeightDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sortWeight':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.sortWeight = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantSortWeightDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantSortWeightDtoBuilder();
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
