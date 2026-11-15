//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_settlements_dto_output_restaurants_inner_latest.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_settlements_dto_output_restaurants_inner.g.dart';

/// AdminRestaurantSettlementsDtoOutputRestaurantsInner
///
/// Properties:
/// * [restaurantId]
/// * [restaurantName]
/// * [currency]
/// * [balance] - + the restaurant owes, − the platform owes it.
/// * [latest]
/// * [unpaid] - What is left of the latest statement after the payments.
/// * [overdueSince]
@BuiltValue()
abstract class AdminRestaurantSettlementsDtoOutputRestaurantsInner
    implements
        Built<
          AdminRestaurantSettlementsDtoOutputRestaurantsInner,
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder
        > {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// + the restaurant owes, − the platform owes it.
  @BuiltValueField(wireName: r'balance')
  String get balance;

  @BuiltValueField(wireName: r'latest')
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest? get latest;

  /// What is left of the latest statement after the payments.
  @BuiltValueField(wireName: r'unpaid')
  String get unpaid;

  @BuiltValueField(wireName: r'overdueSince')
  DateTime? get overdueSince;

  AdminRestaurantSettlementsDtoOutputRestaurantsInner._();

  factory AdminRestaurantSettlementsDtoOutputRestaurantsInner([
    void updates(AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder b),
  ]) = _$AdminRestaurantSettlementsDtoOutputRestaurantsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantSettlementsDtoOutputRestaurantsInner>
  get serializer =>
      _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerSerializer();
}

class _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantSettlementsDtoOutputRestaurantsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantSettlementsDtoOutputRestaurantsInner,
    _$AdminRestaurantSettlementsDtoOutputRestaurantsInner,
  ];

  @override
  final String wireName =
      r'AdminRestaurantSettlementsDtoOutputRestaurantsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantSettlementsDtoOutputRestaurantsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'balance';
    yield serializers.serialize(
      object.balance,
      specifiedType: const FullType(String),
    );
    yield r'latest';
    yield object.latest == null
        ? null
        : serializers.serialize(
            object.latest,
            specifiedType: const FullType.nullable(
              AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest,
            ),
          );
    yield r'unpaid';
    yield serializers.serialize(
      object.unpaid,
      specifiedType: const FullType(String),
    );
    yield r'overdueSince';
    yield object.overdueSince == null
        ? null
        : serializers.serialize(
            object.overdueSince,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSettlementsDtoOutputRestaurantsInner object, {
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
    required AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder result,
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
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'balance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.balance = valueDes;
          break;
        case r'latest':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest,
                    ),
                  )
                  as AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest?;
          if (valueDes == null) continue;
          result.latest.replace(valueDes);
          break;
        case r'unpaid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.unpaid = valueDes;
          break;
        case r'overdueSince':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.overdueSince = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder();
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
