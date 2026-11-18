//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_operations_periods_inner.g.dart';

/// AdminRestaurantDraftDtoOutputOperationsPeriodsInner
///
/// Properties:
/// * [weekday] - 0 is Sunday, 6 Saturday.
/// * [opensAt] - Minutes after midnight on the city's clock.
/// * [closesAt] - Not after the opening: the period crosses midnight (00:00 to 00:00 is all day).
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputOperationsPeriodsInner
    implements
        Built<
          AdminRestaurantDraftDtoOutputOperationsPeriodsInner,
          AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder
        > {
  /// 0 is Sunday, 6 Saturday.
  @BuiltValueField(wireName: r'weekday')
  int get weekday;

  /// Minutes after midnight on the city's clock.
  @BuiltValueField(wireName: r'opensAt')
  int get opensAt;

  /// Not after the opening: the period crosses midnight (00:00 to 00:00 is all day).
  @BuiltValueField(wireName: r'closesAt')
  int get closesAt;

  AdminRestaurantDraftDtoOutputOperationsPeriodsInner._();

  factory AdminRestaurantDraftDtoOutputOperationsPeriodsInner([
    void updates(AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputOperationsPeriodsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputOperationsPeriodsInner>
  get serializer =>
      _$AdminRestaurantDraftDtoOutputOperationsPeriodsInnerSerializer();
}

class _$AdminRestaurantDraftDtoOutputOperationsPeriodsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDraftDtoOutputOperationsPeriodsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputOperationsPeriodsInner,
    _$AdminRestaurantDraftDtoOutputOperationsPeriodsInner,
  ];

  @override
  final String wireName =
      r'AdminRestaurantDraftDtoOutputOperationsPeriodsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsPeriodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weekday';
    yield serializers.serialize(
      object.weekday,
      specifiedType: const FullType(int),
    );
    yield r'opensAt';
    yield serializers.serialize(
      object.opensAt,
      specifiedType: const FullType(int),
    );
    yield r'closesAt';
    yield serializers.serialize(
      object.closesAt,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsPeriodsInner object, {
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
    required AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weekday':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.weekday = valueDes;
          break;
        case r'opensAt':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.opensAt = valueDes;
          break;
        case r'closesAt':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.closesAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftDtoOutputOperationsPeriodsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder();
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
