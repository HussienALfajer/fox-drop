//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_customer_arrival.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_customer_address.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_customer_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_customer.g.dart';

/// Steps 3 and 4, to and at the customer (CA §9.5–9.6).
///
/// Properties:
/// * [name] - The recipient's name when the order is for someone else, else the customer's.
/// * [phone] - «اتصال بالزبون» and «واتساب الزبون» (C10) open it; the app shows it nowhere else.
/// * [location] 
/// * [address] 
/// * [payIn] - «الزبون سيدفع بـ {العملة}», an indication only (CU U10).
/// * [collectEquivalents] - «تقبض من الزبون» in the other accepted currencies, each by its rounding.
/// * [promisedAt] - «التسليم المتوقع قبل {الساعة}».
/// * [arrival] 
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderCustomer implements Built<CaptainActiveOrderDtoOutputOrderCustomer, CaptainActiveOrderDtoOutputOrderCustomerBuilder> {
  /// The recipient's name when the order is for someone else, else the customer's.
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// «اتصال بالزبون» and «واتساب الزبون» (C10) open it; the app shows it nowhere else.
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'location')
  CaptainActiveOrderDtoOutputOrderCustomerLocation get location;

  @BuiltValueField(wireName: r'address')
  CaptainActiveOrderDtoOutputOrderCustomerAddress get address;

  /// «الزبون سيدفع بـ {العملة}», an indication only (CU U10).
  @BuiltValueField(wireName: r'payIn')
  String? get payIn;

  /// «تقبض من الزبون» in the other accepted currencies, each by its rounding.
  @BuiltValueField(wireName: r'collectEquivalents')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get collectEquivalents;

  /// «التسليم المتوقع قبل {الساعة}».
  @BuiltValueField(wireName: r'promisedAt')
  DateTime get promisedAt;

  @BuiltValueField(wireName: r'arrival')
  CaptainActiveOrderDtoOutputOrderCustomerArrival? get arrival;

  CaptainActiveOrderDtoOutputOrderCustomer._();

  factory CaptainActiveOrderDtoOutputOrderCustomer([void updates(CaptainActiveOrderDtoOutputOrderCustomerBuilder b)]) = _$CaptainActiveOrderDtoOutputOrderCustomer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderCustomerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderCustomer> get serializer => _$CaptainActiveOrderDtoOutputOrderCustomerSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderCustomerSerializer implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderCustomer> {
  @override
  final Iterable<Type> types = const [CaptainActiveOrderDtoOutputOrderCustomer, _$CaptainActiveOrderDtoOutputOrderCustomer];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderCustomer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCustomer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderCustomerLocation),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderCustomerAddress),
    );
    yield r'payIn';
    yield object.payIn == null ? null : serializers.serialize(
      object.payIn,
      specifiedType: const FullType.nullable(String),
    );
    yield r'collectEquivalents';
    yield serializers.serialize(
      object.collectEquivalents,
      specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
    );
    yield r'promisedAt';
    yield serializers.serialize(
      object.promisedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'arrival';
    yield object.arrival == null ? null : serializers.serialize(
      object.arrival,
      specifiedType: const FullType.nullable(CaptainActiveOrderDtoOutputOrderCustomerArrival),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCustomer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainActiveOrderDtoOutputOrderCustomerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderCustomerLocation),
          ) as CaptainActiveOrderDtoOutputOrderCustomerLocation;
          result.location.replace(valueDes);
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderCustomerAddress),
          ) as CaptainActiveOrderDtoOutputOrderCustomerAddress;
          result.address.replace(valueDes);
          break;
        case r'payIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.payIn = valueDes;
          break;
        case r'collectEquivalents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
          ) as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.collectEquivalents.replace(valueDes);
          break;
        case r'promisedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.promisedAt = valueDes;
          break;
        case r'arrival':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CaptainActiveOrderDtoOutputOrderCustomerArrival),
          ) as CaptainActiveOrderDtoOutputOrderCustomerArrival?;
          if (valueDes == null) continue;
          result.arrival.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderCustomer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderCustomerBuilder();
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


