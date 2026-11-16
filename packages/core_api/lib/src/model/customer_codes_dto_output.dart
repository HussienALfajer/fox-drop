//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_codes_dto_output_codes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_codes_dto_output.g.dart';

/// CustomerCodesDtoOutput
///
/// Properties:
/// * [currency] - The city base; null outside every city.
/// * [codes] - «متاحة» by the nearest end, then «منتهية» newest first.
@BuiltValue()
abstract class CustomerCodesDtoOutput
    implements Built<CustomerCodesDtoOutput, CustomerCodesDtoOutputBuilder> {
  /// The city base; null outside every city.
  @BuiltValueField(wireName: r'currency')
  String? get currency;

  /// «متاحة» by the nearest end, then «منتهية» newest first.
  @BuiltValueField(wireName: r'codes')
  BuiltList<CustomerCodesDtoOutputCodesInner> get codes;

  CustomerCodesDtoOutput._();

  factory CustomerCodesDtoOutput([
    void updates(CustomerCodesDtoOutputBuilder b),
  ]) = _$CustomerCodesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCodesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCodesDtoOutput> get serializer =>
      _$CustomerCodesDtoOutputSerializer();
}

class _$CustomerCodesDtoOutputSerializer
    implements PrimitiveSerializer<CustomerCodesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerCodesDtoOutput,
    _$CustomerCodesDtoOutput,
  ];

  @override
  final String wireName = r'CustomerCodesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCodesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield object.currency == null
        ? null
        : serializers.serialize(
            object.currency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'codes';
    yield serializers.serialize(
      object.codes,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerCodesDtoOutputCodesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerCodesDtoOutput object, {
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
    required CustomerCodesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.currency = valueDes;
          break;
        case r'codes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerCodesDtoOutputCodesInner),
                    ]),
                  )
                  as BuiltList<CustomerCodesDtoOutputCodesInner>;
          result.codes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerCodesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCodesDtoOutputBuilder();
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
