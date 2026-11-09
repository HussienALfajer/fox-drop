//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_restaurant.g.dart';

/// CustomerQuoteDtoOutputRestaurant
///
/// Properties:
/// * [id] 
/// * [state] 
/// * [busyMode] 
/// * [until] 
/// * [opensAt] 
/// * [message] 
@BuiltValue()
abstract class CustomerQuoteDtoOutputRestaurant implements Built<CustomerQuoteDtoOutputRestaurant, CustomerQuoteDtoOutputRestaurantBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'state')
  CustomerQuoteDtoOutputRestaurantStateEnum get state;
  // enum stateEnum {  open,  busy,  paused,  closed,  holiday,  };

  @BuiltValueField(wireName: r'busyMode')
  bool get busyMode;

  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  @BuiltValueField(wireName: r'opensAt')
  DateTime? get opensAt;

  @BuiltValueField(wireName: r'message')
  String? get message;

  CustomerQuoteDtoOutputRestaurant._();

  factory CustomerQuoteDtoOutputRestaurant([void updates(CustomerQuoteDtoOutputRestaurantBuilder b)]) = _$CustomerQuoteDtoOutputRestaurant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputRestaurantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputRestaurant> get serializer => _$CustomerQuoteDtoOutputRestaurantSerializer();
}

class _$CustomerQuoteDtoOutputRestaurantSerializer implements PrimitiveSerializer<CustomerQuoteDtoOutputRestaurant> {
  @override
  final Iterable<Type> types = const [CustomerQuoteDtoOutputRestaurant, _$CustomerQuoteDtoOutputRestaurant];

  @override
  final String wireName = r'CustomerQuoteDtoOutputRestaurant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputRestaurant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(CustomerQuoteDtoOutputRestaurantStateEnum),
    );
    yield r'busyMode';
    yield serializers.serialize(
      object.busyMode,
      specifiedType: const FullType(bool),
    );
    yield r'until';
    yield object.until == null ? null : serializers.serialize(
      object.until,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'opensAt';
    yield object.opensAt == null ? null : serializers.serialize(
      object.opensAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'message';
    yield object.message == null ? null : serializers.serialize(
      object.message,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputRestaurant object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerQuoteDtoOutputRestaurantBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerQuoteDtoOutputRestaurantStateEnum),
          ) as CustomerQuoteDtoOutputRestaurantStateEnum;
          result.state = valueDes;
          break;
        case r'busyMode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.busyMode = valueDes;
          break;
        case r'until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
          break;
        case r'opensAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputRestaurant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputRestaurantBuilder();
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


class CustomerQuoteDtoOutputRestaurantStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'open')
  static const CustomerQuoteDtoOutputRestaurantStateEnum open = _$customerQuoteDtoOutputRestaurantStateEnum_open;
  @BuiltValueEnumConst(wireName: r'busy')
  static const CustomerQuoteDtoOutputRestaurantStateEnum busy = _$customerQuoteDtoOutputRestaurantStateEnum_busy;
  @BuiltValueEnumConst(wireName: r'paused')
  static const CustomerQuoteDtoOutputRestaurantStateEnum paused = _$customerQuoteDtoOutputRestaurantStateEnum_paused;
  @BuiltValueEnumConst(wireName: r'closed')
  static const CustomerQuoteDtoOutputRestaurantStateEnum closed = _$customerQuoteDtoOutputRestaurantStateEnum_closed;
  @BuiltValueEnumConst(wireName: r'holiday')
  static const CustomerQuoteDtoOutputRestaurantStateEnum holiday = _$customerQuoteDtoOutputRestaurantStateEnum_holiday;

  static Serializer<CustomerQuoteDtoOutputRestaurantStateEnum> get serializer => _$customerQuoteDtoOutputRestaurantStateEnumSerializer;

  const CustomerQuoteDtoOutputRestaurantStateEnum._(String name): super(name);

  static BuiltSet<CustomerQuoteDtoOutputRestaurantStateEnum> get values => _$customerQuoteDtoOutputRestaurantStateEnumValues;
  static CustomerQuoteDtoOutputRestaurantStateEnum valueOf(String name) => _$customerQuoteDtoOutputRestaurantStateEnumValueOf(name);
}

