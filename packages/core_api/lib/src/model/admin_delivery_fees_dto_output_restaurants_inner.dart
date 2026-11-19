//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_delivery_fees_dto_output_restaurants_inner_own_rule.dart';
import 'package:core_api/src/model/admin_delivery_fees_dto_output_restaurants_inner_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_delivery_fees_dto_output_restaurants_inner.g.dart';

/// AdminDeliveryFeesDtoOutputRestaurantsInner
///
/// Properties:
/// * [id]
/// * [nameAr]
/// * [location]
/// * [ownRule]
@BuiltValue()
abstract class AdminDeliveryFeesDtoOutputRestaurantsInner
    implements
        Built<
          AdminDeliveryFeesDtoOutputRestaurantsInner,
          AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'location')
  AdminDeliveryFeesDtoOutputRestaurantsInnerLocation get location;

  @BuiltValueField(wireName: r'ownRule')
  AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule? get ownRule;

  AdminDeliveryFeesDtoOutputRestaurantsInner._();

  factory AdminDeliveryFeesDtoOutputRestaurantsInner([
    void updates(AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder b),
  ]) = _$AdminDeliveryFeesDtoOutputRestaurantsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeliveryFeesDtoOutputRestaurantsInner>
  get serializer => _$AdminDeliveryFeesDtoOutputRestaurantsInnerSerializer();
}

class _$AdminDeliveryFeesDtoOutputRestaurantsInnerSerializer
    implements PrimitiveSerializer<AdminDeliveryFeesDtoOutputRestaurantsInner> {
  @override
  final Iterable<Type> types = const [
    AdminDeliveryFeesDtoOutputRestaurantsInner,
    _$AdminDeliveryFeesDtoOutputRestaurantsInner,
  ];

  @override
  final String wireName = r'AdminDeliveryFeesDtoOutputRestaurantsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputRestaurantsInner object, {
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
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(
        AdminDeliveryFeesDtoOutputRestaurantsInnerLocation,
      ),
    );
    yield r'ownRule';
    yield object.ownRule == null
        ? null
        : serializers.serialize(
            object.ownRule,
            specifiedType: const FullType.nullable(
              AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputRestaurantsInner object, {
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
    required AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder result,
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
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeliveryFeesDtoOutputRestaurantsInnerLocation,
                    ),
                  )
                  as AdminDeliveryFeesDtoOutputRestaurantsInnerLocation;
          result.location.replace(valueDes);
          break;
        case r'ownRule':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule,
                    ),
                  )
                  as AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule?;
          if (valueDes == null) continue;
          result.ownRule.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeliveryFeesDtoOutputRestaurantsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder();
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
