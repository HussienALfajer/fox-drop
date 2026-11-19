//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_publish_pay_table_dto_rates_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_publish_pay_table_dto.g.dart';

/// AdminPublishPayTableDto
///
/// Properties:
/// * [cityId]
/// * [currency]
/// * [effectiveFrom]
/// * [rates] - One per vehicle.
/// * [reason]
@BuiltValue()
abstract class AdminPublishPayTableDto
    implements Built<AdminPublishPayTableDto, AdminPublishPayTableDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  /// One per vehicle.
  @BuiltValueField(wireName: r'rates')
  BuiltList<AdminPublishPayTableDtoRatesInner> get rates;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminPublishPayTableDto._();

  factory AdminPublishPayTableDto([
    void updates(AdminPublishPayTableDtoBuilder b),
  ]) = _$AdminPublishPayTableDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPublishPayTableDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPublishPayTableDto> get serializer =>
      _$AdminPublishPayTableDtoSerializer();
}

class _$AdminPublishPayTableDtoSerializer
    implements PrimitiveSerializer<AdminPublishPayTableDto> {
  @override
  final Iterable<Type> types = const [
    AdminPublishPayTableDto,
    _$AdminPublishPayTableDto,
  ];

  @override
  final String wireName = r'AdminPublishPayTableDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPublishPayTableDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'rates';
    yield serializers.serialize(
      object.rates,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminPublishPayTableDtoRatesInner),
      ]),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPublishPayTableDto object, {
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
    required AdminPublishPayTableDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
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
        case r'effectiveFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.effectiveFrom = valueDes;
          break;
        case r'rates':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminPublishPayTableDtoRatesInner),
                    ]),
                  )
                  as BuiltList<AdminPublishPayTableDtoRatesInner>;
          result.rates.replace(valueDes);
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPublishPayTableDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPublishPayTableDtoBuilder();
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
