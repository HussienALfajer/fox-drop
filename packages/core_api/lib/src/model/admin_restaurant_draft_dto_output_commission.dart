//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_draft_dto_output_commission_launch.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_commission.g.dart';

/// AdminRestaurantDraftDtoOutputCommission
///
/// Properties:
/// * [rateBp] - The standard commission, in basis points of the items value.
/// * [launch]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputCommission
    implements
        Built<
          AdminRestaurantDraftDtoOutputCommission,
          AdminRestaurantDraftDtoOutputCommissionBuilder
        > {
  /// The standard commission, in basis points of the items value.
  @BuiltValueField(wireName: r'rateBp')
  int get rateBp;

  @BuiltValueField(wireName: r'launch')
  AdminRestaurantDraftDtoOutputCommissionLaunch? get launch;

  AdminRestaurantDraftDtoOutputCommission._();

  factory AdminRestaurantDraftDtoOutputCommission([
    void updates(AdminRestaurantDraftDtoOutputCommissionBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputCommission;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDraftDtoOutputCommissionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputCommission> get serializer =>
      _$AdminRestaurantDraftDtoOutputCommissionSerializer();
}

class _$AdminRestaurantDraftDtoOutputCommissionSerializer
    implements PrimitiveSerializer<AdminRestaurantDraftDtoOutputCommission> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputCommission,
    _$AdminRestaurantDraftDtoOutputCommission,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftDtoOutputCommission';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputCommission object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rateBp';
    yield serializers.serialize(
      object.rateBp,
      specifiedType: const FullType(int),
    );
    yield r'launch';
    yield object.launch == null
        ? null
        : serializers.serialize(
            object.launch,
            specifiedType: const FullType.nullable(
              AdminRestaurantDraftDtoOutputCommissionLaunch,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputCommission object, {
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
    required AdminRestaurantDraftDtoOutputCommissionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rateBp':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.rateBp = valueDes;
          break;
        case r'launch':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantDraftDtoOutputCommissionLaunch,
                    ),
                  )
                  as AdminRestaurantDraftDtoOutputCommissionLaunch?;
          if (valueDes == null) continue;
          result.launch.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftDtoOutputCommission deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputCommissionBuilder();
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
