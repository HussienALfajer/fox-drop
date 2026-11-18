//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_drafts_dto_output_drafts_inner_steps.dart';
import 'package:core_api/src/model/admin_restaurant_draft_dto_output_basics.dart';
import 'package:core_api/src/model/admin_restaurant_draft_dto_output_location.dart';
import 'package:core_api/src/model/admin_restaurant_draft_dto_output_operations.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output.g.dart';

/// AdminRestaurantDraftDtoOutput
///
/// Properties:
/// * [id]
/// * [cityId]
/// * [accountStatus]
/// * [basics]
/// * [location]
/// * [operations]
/// * [steps]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutput
    implements
        Built<
          AdminRestaurantDraftDtoOutput,
          AdminRestaurantDraftDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'accountStatus')
  String get accountStatus;

  @BuiltValueField(wireName: r'basics')
  AdminRestaurantDraftDtoOutputBasics get basics;

  @BuiltValueField(wireName: r'location')
  AdminRestaurantDraftDtoOutputLocation get location;

  @BuiltValueField(wireName: r'operations')
  AdminRestaurantDraftDtoOutputOperations get operations;

  @BuiltValueField(wireName: r'steps')
  AdminRestaurantDraftsDtoOutputDraftsInnerSteps get steps;

  AdminRestaurantDraftDtoOutput._();

  factory AdminRestaurantDraftDtoOutput([
    void updates(AdminRestaurantDraftDtoOutputBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDraftDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutput> get serializer =>
      _$AdminRestaurantDraftDtoOutputSerializer();
}

class _$AdminRestaurantDraftDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantDraftDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutput,
    _$AdminRestaurantDraftDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'accountStatus';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(String),
    );
    yield r'basics';
    yield serializers.serialize(
      object.basics,
      specifiedType: const FullType(AdminRestaurantDraftDtoOutputBasics),
    );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(AdminRestaurantDraftDtoOutputLocation),
    );
    yield r'operations';
    yield serializers.serialize(
      object.operations,
      specifiedType: const FullType(AdminRestaurantDraftDtoOutputOperations),
    );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(
        AdminRestaurantDraftsDtoOutputDraftsInnerSteps,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutput object, {
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
    required AdminRestaurantDraftDtoOutputBuilder result,
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
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'accountStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.accountStatus = valueDes;
          break;
        case r'basics':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantDraftDtoOutputBasics,
                    ),
                  )
                  as AdminRestaurantDraftDtoOutputBasics;
          result.basics.replace(valueDes);
          break;
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantDraftDtoOutputLocation,
                    ),
                  )
                  as AdminRestaurantDraftDtoOutputLocation;
          result.location.replace(valueDes);
          break;
        case r'operations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantDraftDtoOutputOperations,
                    ),
                  )
                  as AdminRestaurantDraftDtoOutputOperations;
          result.operations.replace(valueDes);
          break;
        case r'steps':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantDraftsDtoOutputDraftsInnerSteps,
                    ),
                  )
                  as AdminRestaurantDraftsDtoOutputDraftsInnerSteps;
          result.steps.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputBuilder();
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
