//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_draft_dto_output_operations_periods_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_draft_dto_output_operations_coverage.dart';
import 'package:core_api/src/model/admin_restaurant_draft_dto_output_operations_minimum_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_operations.g.dart';

/// AdminRestaurantDraftDtoOutputOperations
///
/// Properties:
/// * [periods]
/// * [defaultPrepMin]
/// * [minimumOrder]
/// * [coverage]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputOperations
    implements
        Built<
          AdminRestaurantDraftDtoOutputOperations,
          AdminRestaurantDraftDtoOutputOperationsBuilder
        > {
  @BuiltValueField(wireName: r'periods')
  BuiltList<AdminRestaurantDraftDtoOutputOperationsPeriodsInner> get periods;

  @BuiltValueField(wireName: r'defaultPrepMin')
  int? get defaultPrepMin;

  @BuiltValueField(wireName: r'minimumOrder')
  AdminRestaurantDraftDtoOutputOperationsMinimumOrder? get minimumOrder;

  @BuiltValueField(wireName: r'coverage')
  AdminRestaurantDraftDtoOutputOperationsCoverage? get coverage;

  AdminRestaurantDraftDtoOutputOperations._();

  factory AdminRestaurantDraftDtoOutputOperations([
    void updates(AdminRestaurantDraftDtoOutputOperationsBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputOperations;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDraftDtoOutputOperationsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputOperations> get serializer =>
      _$AdminRestaurantDraftDtoOutputOperationsSerializer();
}

class _$AdminRestaurantDraftDtoOutputOperationsSerializer
    implements PrimitiveSerializer<AdminRestaurantDraftDtoOutputOperations> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputOperations,
    _$AdminRestaurantDraftDtoOutputOperations,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftDtoOutputOperations';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperations object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'periods';
    yield serializers.serialize(
      object.periods,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantDraftDtoOutputOperationsPeriodsInner),
      ]),
    );
    yield r'defaultPrepMin';
    yield object.defaultPrepMin == null
        ? null
        : serializers.serialize(
            object.defaultPrepMin,
            specifiedType: const FullType.nullable(int),
          );
    yield r'minimumOrder';
    yield object.minimumOrder == null
        ? null
        : serializers.serialize(
            object.minimumOrder,
            specifiedType: const FullType.nullable(
              AdminRestaurantDraftDtoOutputOperationsMinimumOrder,
            ),
          );
    yield r'coverage';
    yield object.coverage == null
        ? null
        : serializers.serialize(
            object.coverage,
            specifiedType: const FullType.nullable(
              AdminRestaurantDraftDtoOutputOperationsCoverage,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperations object, {
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
    required AdminRestaurantDraftDtoOutputOperationsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'periods':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRestaurantDraftDtoOutputOperationsPeriodsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantDraftDtoOutputOperationsPeriodsInner
                  >;
          result.periods.replace(valueDes);
          break;
        case r'defaultPrepMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.defaultPrepMin = valueDes;
          break;
        case r'minimumOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantDraftDtoOutputOperationsMinimumOrder,
                    ),
                  )
                  as AdminRestaurantDraftDtoOutputOperationsMinimumOrder?;
          if (valueDes == null) continue;
          result.minimumOrder.replace(valueDes);
          break;
        case r'coverage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantDraftDtoOutputOperationsCoverage,
                    ),
                  )
                  as AdminRestaurantDraftDtoOutputOperationsCoverage?;
          if (valueDes == null) continue;
          result.coverage.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftDtoOutputOperations deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputOperationsBuilder();
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
