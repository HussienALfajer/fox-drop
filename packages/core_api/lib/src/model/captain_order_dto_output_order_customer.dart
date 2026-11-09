//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_active_order_dto_output_order_customer_arrival.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_customer_address.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_customer_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_dto_output_order_customer.g.dart';

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
abstract class CaptainOrderDtoOutputOrderCustomer implements Built<CaptainOrderDtoOutputOrderCustomer, CaptainOrderDtoOutputOrderCustomerBuilder> {
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
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> get collectEquivalents;

  /// «التسليم المتوقع قبل {الساعة}».
  @BuiltValueField(wireName: r'promisedAt')
  DateTime get promisedAt;

  @BuiltValueField(wireName: r'arrival')
  CaptainActiveOrderDtoOutputOrderCustomerArrival? get arrival;

  CaptainOrderDtoOutputOrderCustomer._();

  factory CaptainOrderDtoOutputOrderCustomer([void updates(CaptainOrderDtoOutputOrderCustomerBuilder b)]) = _$CaptainOrderDtoOutputOrderCustomer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderDtoOutputOrderCustomerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderDtoOutputOrderCustomer> get serializer => _$CaptainOrderDtoOutputOrderCustomerSerializer();
}

class _$CaptainOrderDtoOutputOrderCustomerSerializer implements PrimitiveSerializer<CaptainOrderDtoOutputOrderCustomer> {
  @override
  final Iterable<Type> types = const [CaptainOrderDtoOutputOrderCustomer, _$CaptainOrderDtoOutputOrderCustomer];

  @override
  final String wireName = r'CaptainOrderDtoOutputOrderCustomer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderDtoOutputOrderCustomer object, {
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
      specifiedType: const FullType(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
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
    CaptainOrderDtoOutputOrderCustomer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainOrderDtoOutputOrderCustomerBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
          ) as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>;
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
  CaptainOrderDtoOutputOrderCustomer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderDtoOutputOrderCustomerBuilder();
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


