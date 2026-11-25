//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_availability_dto_output_office_hours_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_account_state_dto_output_office.g.dart';

/// The dues sheet's office and its hours (AP §9.12.1); null until the owner sets it.
///
/// Properties:
/// * [latitude]
/// * [longitude]
/// * [landmark] - «وصف المكان», such as «بجانب جامع …» (slice D.11a); null for none.
/// * [hours] - The desk hours per weekday; a weekday not listed is closed.
/// * [timeZone]
/// * [open]
/// * [closesAt]
/// * [opensAt]
@BuiltValue()
abstract class CustomerAccountStateDtoOutputOffice
    implements
        Built<
          CustomerAccountStateDtoOutputOffice,
          CustomerAccountStateDtoOutputOfficeBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  /// «وصف المكان», such as «بجانب جامع …» (slice D.11a); null for none.
  @BuiltValueField(wireName: r'landmark')
  String? get landmark;

  /// The desk hours per weekday; a weekday not listed is closed.
  @BuiltValueField(wireName: r'hours')
  BuiltList<CaptainAvailabilityDtoOutputOfficeHoursInner> get hours;

  @BuiltValueField(wireName: r'timeZone')
  String get timeZone;

  @BuiltValueField(wireName: r'open')
  bool get open;

  @BuiltValueField(wireName: r'closesAt')
  DateTime? get closesAt;

  @BuiltValueField(wireName: r'opensAt')
  DateTime? get opensAt;

  CustomerAccountStateDtoOutputOffice._();

  factory CustomerAccountStateDtoOutputOffice([
    void updates(CustomerAccountStateDtoOutputOfficeBuilder b),
  ]) = _$CustomerAccountStateDtoOutputOffice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerAccountStateDtoOutputOfficeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerAccountStateDtoOutputOffice> get serializer =>
      _$CustomerAccountStateDtoOutputOfficeSerializer();
}

class _$CustomerAccountStateDtoOutputOfficeSerializer
    implements PrimitiveSerializer<CustomerAccountStateDtoOutputOffice> {
  @override
  final Iterable<Type> types = const [
    CustomerAccountStateDtoOutputOffice,
    _$CustomerAccountStateDtoOutputOffice,
  ];

  @override
  final String wireName = r'CustomerAccountStateDtoOutputOffice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerAccountStateDtoOutputOffice object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'landmark';
    yield object.landmark == null
        ? null
        : serializers.serialize(
            object.landmark,
            specifiedType: const FullType.nullable(String),
          );
    yield r'hours';
    yield serializers.serialize(
      object.hours,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainAvailabilityDtoOutputOfficeHoursInner),
      ]),
    );
    yield r'timeZone';
    yield serializers.serialize(
      object.timeZone,
      specifiedType: const FullType(String),
    );
    yield r'open';
    yield serializers.serialize(
      object.open,
      specifiedType: const FullType(bool),
    );
    yield r'closesAt';
    yield object.closesAt == null
        ? null
        : serializers.serialize(
            object.closesAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'opensAt';
    yield object.opensAt == null
        ? null
        : serializers.serialize(
            object.opensAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerAccountStateDtoOutputOffice object, {
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
    required CustomerAccountStateDtoOutputOfficeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.longitude = valueDes;
          break;
        case r'landmark':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.landmark = valueDes;
          break;
        case r'hours':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainAvailabilityDtoOutputOfficeHoursInner),
                    ]),
                  )
                  as BuiltList<CaptainAvailabilityDtoOutputOfficeHoursInner>;
          result.hours.replace(valueDes);
          break;
        case r'timeZone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.timeZone = valueDes;
          break;
        case r'open':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.open = valueDes;
          break;
        case r'closesAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.closesAt = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerAccountStateDtoOutputOffice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerAccountStateDtoOutputOfficeBuilder();
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
