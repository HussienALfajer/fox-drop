//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output_troubled_restaurants_inner.g.dart';

/// AdminDashboardDtoOutputTroubledRestaurantsInner
///
/// Properties:
/// * [restaurantId]
/// * [name]
/// * [rejected]
/// * [late_]
@BuiltValue()
abstract class AdminDashboardDtoOutputTroubledRestaurantsInner
    implements
        Built<
          AdminDashboardDtoOutputTroubledRestaurantsInner,
          AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder
        > {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'rejected')
  int get rejected;

  @BuiltValueField(wireName: r'late')
  int get late_;

  AdminDashboardDtoOutputTroubledRestaurantsInner._();

  factory AdminDashboardDtoOutputTroubledRestaurantsInner([
    void updates(AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder b),
  ]) = _$AdminDashboardDtoOutputTroubledRestaurantsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutputTroubledRestaurantsInner>
  get serializer =>
      _$AdminDashboardDtoOutputTroubledRestaurantsInnerSerializer();
}

class _$AdminDashboardDtoOutputTroubledRestaurantsInnerSerializer
    implements
        PrimitiveSerializer<AdminDashboardDtoOutputTroubledRestaurantsInner> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutputTroubledRestaurantsInner,
    _$AdminDashboardDtoOutputTroubledRestaurantsInner,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutputTroubledRestaurantsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutputTroubledRestaurantsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'rejected';
    yield serializers.serialize(
      object.rejected,
      specifiedType: const FullType(int),
    );
    yield r'late';
    yield serializers.serialize(
      object.late_,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutputTroubledRestaurantsInner object, {
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
    required AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'rejected':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.rejected = valueDes;
          break;
        case r'late':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.late_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutputTroubledRestaurantsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder();
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
