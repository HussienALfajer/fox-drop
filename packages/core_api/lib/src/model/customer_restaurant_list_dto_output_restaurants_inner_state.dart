//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_list_dto_output_restaurants_inner_state.g.dart';

/// Only open takes orders.
///
/// Properties:
/// * [state] - CU §9.2: open; «المطعم مشغول حالياً، جرّب بعد قليل»; «المطعم متوقف مؤقتاً…»; «مغلق — يفتح…»; «مغلق حتى {التاريخ}».
/// * [busyMode] - Open with busy mode on: «قد يستغرق الطلب وقتاً أطول قليلاً».
/// * [until] - The end of a pause or a holiday close; null for a pause until resumed.
/// * [opensAt] - While closed by the schedule: its next opening.
/// * [message] - A holiday close's message, or an operations pause's.
@BuiltValue()
abstract class CustomerRestaurantListDtoOutputRestaurantsInnerState
    implements
        Built<
          CustomerRestaurantListDtoOutputRestaurantsInnerState,
          CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder
        > {
  /// CU §9.2: open; «المطعم مشغول حالياً، جرّب بعد قليل»; «المطعم متوقف مؤقتاً…»; «مغلق — يفتح…»; «مغلق حتى {التاريخ}».
  @BuiltValueField(wireName: r'state')
  CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum get state;
  // enum stateEnum {  open,  busy,  paused,  closed,  holiday,  };

  /// Open with busy mode on: «قد يستغرق الطلب وقتاً أطول قليلاً».
  @BuiltValueField(wireName: r'busyMode')
  bool get busyMode;

  /// The end of a pause or a holiday close; null for a pause until resumed.
  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  /// While closed by the schedule: its next opening.
  @BuiltValueField(wireName: r'opensAt')
  DateTime? get opensAt;

  /// A holiday close's message, or an operations pause's.
  @BuiltValueField(wireName: r'message')
  String? get message;

  CustomerRestaurantListDtoOutputRestaurantsInnerState._();

  factory CustomerRestaurantListDtoOutputRestaurantsInnerState([
    void updates(CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder b),
  ]) = _$CustomerRestaurantListDtoOutputRestaurantsInnerState;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantListDtoOutputRestaurantsInnerState>
  get serializer =>
      _$CustomerRestaurantListDtoOutputRestaurantsInnerStateSerializer();
}

class _$CustomerRestaurantListDtoOutputRestaurantsInnerStateSerializer
    implements
        PrimitiveSerializer<
          CustomerRestaurantListDtoOutputRestaurantsInnerState
        > {
  @override
  final Iterable<Type> types = const [
    CustomerRestaurantListDtoOutputRestaurantsInnerState,
    _$CustomerRestaurantListDtoOutputRestaurantsInnerState,
  ];

  @override
  final String wireName =
      r'CustomerRestaurantListDtoOutputRestaurantsInnerState';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantListDtoOutputRestaurantsInnerState object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum,
      ),
    );
    yield r'busyMode';
    yield serializers.serialize(
      object.busyMode,
      specifiedType: const FullType(bool),
    );
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'opensAt';
    yield object.opensAt == null
        ? null
        : serializers.serialize(
            object.opensAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'message';
    yield object.message == null
        ? null
        : serializers.serialize(
            object.message,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantListDtoOutputRestaurantsInnerState object, {
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
    required CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum,
                    ),
                  )
                  as CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum;
          result.state = valueDes;
          break;
        case r'busyMode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.busyMode = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
          break;
        case r'opensAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        case r'message':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
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
  CustomerRestaurantListDtoOutputRestaurantsInnerState deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder();
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

/// CU §9.2: open; «المطعم مشغول حالياً، جرّب بعد قليل»; «المطعم متوقف مؤقتاً…»; «مغلق — يفتح…»; «مغلق حتى {التاريخ}».
class CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
  open = _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_open;
  @BuiltValueEnumConst(wireName: r'busy')
  static const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
  busy = _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_busy;
  @BuiltValueEnumConst(wireName: r'paused')
  static const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
  paused =
      _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_paused;
  @BuiltValueEnumConst(wireName: r'closed')
  static const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
  closed =
      _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_closed;
  @BuiltValueEnumConst(wireName: r'holiday')
  static const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
  holiday =
      _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_holiday;

  static Serializer<
    CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
  >
  get serializer =>
      _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnumSerializer;

  const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum._(
    String name,
  ) : super(name);

  static BuiltSet<CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum>
  get values =>
      _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnumValues;
  static CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum valueOf(
    String name,
  ) => _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnumValueOf(
    name,
  );
}
