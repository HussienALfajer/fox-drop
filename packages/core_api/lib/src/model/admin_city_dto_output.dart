//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_city_dto_output_currencies_inner.dart';
import 'package:core_api/src/model/admin_city_dto_output_other_currencies_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_all_cities_dto_output_cities_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_city_dto_output.g.dart';

/// AdminCityDtoOutput
///
/// Properties:
/// * [city]
/// * [currencies] - The city's currencies in display order, enabled or not.
/// * [otherCurrencies] - The currencies in use the city does not have yet.
/// * [baseLocked] - Whether the first order has locked the base (D25).
@BuiltValue()
abstract class AdminCityDtoOutput
    implements Built<AdminCityDtoOutput, AdminCityDtoOutputBuilder> {
  @BuiltValueField(wireName: r'city')
  AdminAllCitiesDtoOutputCitiesInner get city;

  /// The city's currencies in display order, enabled or not.
  @BuiltValueField(wireName: r'currencies')
  BuiltList<AdminCityDtoOutputCurrenciesInner> get currencies;

  /// The currencies in use the city does not have yet.
  @BuiltValueField(wireName: r'otherCurrencies')
  BuiltList<AdminCityDtoOutputOtherCurrenciesInner> get otherCurrencies;

  /// Whether the first order has locked the base (D25).
  @BuiltValueField(wireName: r'baseLocked')
  bool get baseLocked;

  AdminCityDtoOutput._();

  factory AdminCityDtoOutput([void updates(AdminCityDtoOutputBuilder b)]) =
      _$AdminCityDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCityDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCityDtoOutput> get serializer =>
      _$AdminCityDtoOutputSerializer();
}

class _$AdminCityDtoOutputSerializer
    implements PrimitiveSerializer<AdminCityDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminCityDtoOutput, _$AdminCityDtoOutput];

  @override
  final String wireName = r'AdminCityDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCityDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(AdminAllCitiesDtoOutputCitiesInner),
    );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCityDtoOutputCurrenciesInner),
      ]),
    );
    yield r'otherCurrencies';
    yield serializers.serialize(
      object.otherCurrencies,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCityDtoOutputOtherCurrenciesInner),
      ]),
    );
    yield r'baseLocked';
    yield serializers.serialize(
      object.baseLocked,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCityDtoOutput object, {
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
    required AdminCityDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'city':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminAllCitiesDtoOutputCitiesInner,
                    ),
                  )
                  as AdminAllCitiesDtoOutputCitiesInner;
          result.city.replace(valueDes);
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCityDtoOutputCurrenciesInner),
                    ]),
                  )
                  as BuiltList<AdminCityDtoOutputCurrenciesInner>;
          result.currencies.replace(valueDes);
          break;
        case r'otherCurrencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCityDtoOutputOtherCurrenciesInner),
                    ]),
                  )
                  as BuiltList<AdminCityDtoOutputOtherCurrenciesInner>;
          result.otherCurrencies.replace(valueDes);
          break;
        case r'baseLocked':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.baseLocked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCityDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCityDtoOutputBuilder();
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
