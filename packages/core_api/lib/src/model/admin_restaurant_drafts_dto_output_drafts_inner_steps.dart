//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_drafts_dto_output_drafts_inner_steps.g.dart';

/// Which steps of AP §9.6.3 hold what they need.
///
/// Properties:
/// * [basics]
/// * [location]
/// * [operations]
@BuiltValue()
abstract class AdminRestaurantDraftsDtoOutputDraftsInnerSteps
    implements
        Built<
          AdminRestaurantDraftsDtoOutputDraftsInnerSteps,
          AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder
        > {
  @BuiltValueField(wireName: r'basics')
  bool get basics;

  @BuiltValueField(wireName: r'location')
  bool get location;

  @BuiltValueField(wireName: r'operations')
  bool get operations;

  AdminRestaurantDraftsDtoOutputDraftsInnerSteps._();

  factory AdminRestaurantDraftsDtoOutputDraftsInnerSteps([
    void updates(AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder b),
  ]) = _$AdminRestaurantDraftsDtoOutputDraftsInnerSteps;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftsDtoOutputDraftsInnerSteps>
  get serializer =>
      _$AdminRestaurantDraftsDtoOutputDraftsInnerStepsSerializer();
}

class _$AdminRestaurantDraftsDtoOutputDraftsInnerStepsSerializer
    implements
        PrimitiveSerializer<AdminRestaurantDraftsDtoOutputDraftsInnerSteps> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftsDtoOutputDraftsInnerSteps,
    _$AdminRestaurantDraftsDtoOutputDraftsInnerSteps,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftsDtoOutputDraftsInnerSteps';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftsDtoOutputDraftsInnerSteps object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'basics';
    yield serializers.serialize(
      object.basics,
      specifiedType: const FullType(bool),
    );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(bool),
    );
    yield r'operations';
    yield serializers.serialize(
      object.operations,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftsDtoOutputDraftsInnerSteps object, {
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
    required AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'basics':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.basics = valueDes;
          break;
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.location = valueDes;
          break;
        case r'operations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.operations = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftsDtoOutputDraftsInnerSteps deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder();
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
