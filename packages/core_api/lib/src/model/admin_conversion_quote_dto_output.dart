//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_conversion_quote_dto_output_rates_inner.dart';
import 'package:core_api/src/model/admin_conversion_quote_dto_output_unit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_conversion_quote_dto_output.g.dart';

/// AdminConversionQuoteDtoOutput
///
/// Properties:
/// * [from]
/// * [to]
/// * [amount]
/// * [converted] - Rounded by the target currency's rule (AP §8.6).
/// * [rates] - The rate version of each currency but the base, as the quote gave them.
/// * [unit]
@BuiltValue()
abstract class AdminConversionQuoteDtoOutput
    implements
        Built<
          AdminConversionQuoteDtoOutput,
          AdminConversionQuoteDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'from')
  String get from;

  @BuiltValueField(wireName: r'to')
  String get to;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// Rounded by the target currency's rule (AP §8.6).
  @BuiltValueField(wireName: r'converted')
  String get converted;

  /// The rate version of each currency but the base, as the quote gave them.
  @BuiltValueField(wireName: r'rates')
  BuiltList<AdminConversionQuoteDtoOutputRatesInner> get rates;

  @BuiltValueField(wireName: r'unit')
  AdminConversionQuoteDtoOutputUnit get unit;

  AdminConversionQuoteDtoOutput._();

  factory AdminConversionQuoteDtoOutput([
    void updates(AdminConversionQuoteDtoOutputBuilder b),
  ]) = _$AdminConversionQuoteDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConversionQuoteDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConversionQuoteDtoOutput> get serializer =>
      _$AdminConversionQuoteDtoOutputSerializer();
}

class _$AdminConversionQuoteDtoOutputSerializer
    implements PrimitiveSerializer<AdminConversionQuoteDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminConversionQuoteDtoOutput,
    _$AdminConversionQuoteDtoOutput,
  ];

  @override
  final String wireName = r'AdminConversionQuoteDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConversionQuoteDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'converted';
    yield serializers.serialize(
      object.converted,
      specifiedType: const FullType(String),
    );
    yield r'rates';
    yield serializers.serialize(
      object.rates,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminConversionQuoteDtoOutputRatesInner),
      ]),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(AdminConversionQuoteDtoOutputUnit),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConversionQuoteDtoOutput object, {
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
    required AdminConversionQuoteDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.to = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'converted':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.converted = valueDes;
          break;
        case r'rates':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminConversionQuoteDtoOutputRatesInner),
                    ]),
                  )
                  as BuiltList<AdminConversionQuoteDtoOutputRatesInner>;
          result.rates.replace(valueDes);
          break;
        case r'unit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminConversionQuoteDtoOutputUnit,
                    ),
                  )
                  as AdminConversionQuoteDtoOutputUnit;
          result.unit.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConversionQuoteDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConversionQuoteDtoOutputBuilder();
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
