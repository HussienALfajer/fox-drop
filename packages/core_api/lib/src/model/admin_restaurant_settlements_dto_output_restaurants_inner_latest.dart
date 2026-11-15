//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_settlements_dto_output_restaurants_inner_latest.g.dart';

/// AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest
///
/// Properties:
/// * [id]
/// * [cutoff]
/// * [commission]
/// * [discountShare]
/// * [exceptions]
/// * [totalDue]
@BuiltValue()
abstract class AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest
    implements
        Built<
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest,
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cutoff')
  DateTime get cutoff;

  @BuiltValueField(wireName: r'commission')
  String get commission;

  @BuiltValueField(wireName: r'discountShare')
  String get discountShare;

  @BuiltValueField(wireName: r'exceptions')
  String get exceptions;

  @BuiltValueField(wireName: r'totalDue')
  String get totalDue;

  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest._();

  factory AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest([
    void updates(
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder b,
    ),
  ]) = _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest>
  get serializer =>
      _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestSerializer();
}

class _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest,
    _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest,
  ];

  @override
  final String wireName =
      r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'cutoff';
    yield serializers.serialize(
      object.cutoff,
      specifiedType: const FullType(DateTime),
    );
    yield r'commission';
    yield serializers.serialize(
      object.commission,
      specifiedType: const FullType(String),
    );
    yield r'discountShare';
    yield serializers.serialize(
      object.discountShare,
      specifiedType: const FullType(String),
    );
    yield r'exceptions';
    yield serializers.serialize(
      object.exceptions,
      specifiedType: const FullType(String),
    );
    yield r'totalDue';
    yield serializers.serialize(
      object.totalDue,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest object, {
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
    required AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder
    result,
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
        case r'cutoff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.cutoff = valueDes;
          break;
        case r'commission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.commission = valueDes;
          break;
        case r'discountShare':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.discountShare = valueDes;
          break;
        case r'exceptions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.exceptions = valueDes;
          break;
        case r'totalDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.totalDue = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder();
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
