//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_choices_dto_output_centre.g.dart';

/// Where the map starts: the centre of the city's active zones; null without any.
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class AdminRestaurantDraftChoicesDtoOutputCentre
    implements
        Built<
          AdminRestaurantDraftChoicesDtoOutputCentre,
          AdminRestaurantDraftChoicesDtoOutputCentreBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  AdminRestaurantDraftChoicesDtoOutputCentre._();

  factory AdminRestaurantDraftChoicesDtoOutputCentre([
    void updates(AdminRestaurantDraftChoicesDtoOutputCentreBuilder b),
  ]) = _$AdminRestaurantDraftChoicesDtoOutputCentre;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDraftChoicesDtoOutputCentreBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftChoicesDtoOutputCentre>
  get serializer => _$AdminRestaurantDraftChoicesDtoOutputCentreSerializer();
}

class _$AdminRestaurantDraftChoicesDtoOutputCentreSerializer
    implements PrimitiveSerializer<AdminRestaurantDraftChoicesDtoOutputCentre> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftChoicesDtoOutputCentre,
    _$AdminRestaurantDraftChoicesDtoOutputCentre,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftChoicesDtoOutputCentre';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftChoicesDtoOutputCentre object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftChoicesDtoOutputCentre object, {
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
    required AdminRestaurantDraftChoicesDtoOutputCentreBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.longitude = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftChoicesDtoOutputCentre deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftChoicesDtoOutputCentreBuilder();
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
