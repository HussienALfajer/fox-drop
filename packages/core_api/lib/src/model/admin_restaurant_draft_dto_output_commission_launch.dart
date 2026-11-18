//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_commission_launch.g.dart';

/// A launch commission in force until a moment, then the standard one.
///
/// Properties:
/// * [rateBp]
/// * [until]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputCommissionLaunch
    implements
        Built<
          AdminRestaurantDraftDtoOutputCommissionLaunch,
          AdminRestaurantDraftDtoOutputCommissionLaunchBuilder
        > {
  @BuiltValueField(wireName: r'rateBp')
  int get rateBp;

  @BuiltValueField(wireName: r'until')
  DateTime get until;

  AdminRestaurantDraftDtoOutputCommissionLaunch._();

  factory AdminRestaurantDraftDtoOutputCommissionLaunch([
    void updates(AdminRestaurantDraftDtoOutputCommissionLaunchBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputCommissionLaunch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantDraftDtoOutputCommissionLaunchBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputCommissionLaunch>
  get serializer => _$AdminRestaurantDraftDtoOutputCommissionLaunchSerializer();
}

class _$AdminRestaurantDraftDtoOutputCommissionLaunchSerializer
    implements
        PrimitiveSerializer<AdminRestaurantDraftDtoOutputCommissionLaunch> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputCommissionLaunch,
    _$AdminRestaurantDraftDtoOutputCommissionLaunch,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftDtoOutputCommissionLaunch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputCommissionLaunch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rateBp';
    yield serializers.serialize(
      object.rateBp,
      specifiedType: const FullType(int),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputCommissionLaunch object, {
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
    required AdminRestaurantDraftDtoOutputCommissionLaunchBuilder result,
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
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.until = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftDtoOutputCommissionLaunch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputCommissionLaunchBuilder();
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
