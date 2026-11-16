//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_exchange_rates_dto_output_currencies_inner_rate.g.dart';

/// Null for the base and before a first rate.
///
/// Properties:
/// * [versionId]
/// * [baseCurrency]
/// * [numerator] - Base major units per one major unit, as an exact fraction.
/// * [denominator]
/// * [editorId]
/// * [editorName]
/// * [reason]
/// * [setAt]
@BuiltValue()
abstract class AdminExchangeRatesDtoOutputCurrenciesInnerRate
    implements
        Built<
          AdminExchangeRatesDtoOutputCurrenciesInnerRate,
          AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder
        > {
  @BuiltValueField(wireName: r'versionId')
  String get versionId;

  @BuiltValueField(wireName: r'baseCurrency')
  String get baseCurrency;

  /// Base major units per one major unit, as an exact fraction.
  @BuiltValueField(wireName: r'numerator')
  String get numerator;

  @BuiltValueField(wireName: r'denominator')
  String get denominator;

  @BuiltValueField(wireName: r'editorId')
  String get editorId;

  @BuiltValueField(wireName: r'editorName')
  String? get editorName;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'setAt')
  DateTime get setAt;

  AdminExchangeRatesDtoOutputCurrenciesInnerRate._();

  factory AdminExchangeRatesDtoOutputCurrenciesInnerRate([
    void updates(AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder b),
  ]) = _$AdminExchangeRatesDtoOutputCurrenciesInnerRate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminExchangeRatesDtoOutputCurrenciesInnerRate>
  get serializer =>
      _$AdminExchangeRatesDtoOutputCurrenciesInnerRateSerializer();
}

class _$AdminExchangeRatesDtoOutputCurrenciesInnerRateSerializer
    implements
        PrimitiveSerializer<AdminExchangeRatesDtoOutputCurrenciesInnerRate> {
  @override
  final Iterable<Type> types = const [
    AdminExchangeRatesDtoOutputCurrenciesInnerRate,
    _$AdminExchangeRatesDtoOutputCurrenciesInnerRate,
  ];

  @override
  final String wireName = r'AdminExchangeRatesDtoOutputCurrenciesInnerRate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminExchangeRatesDtoOutputCurrenciesInnerRate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'versionId';
    yield serializers.serialize(
      object.versionId,
      specifiedType: const FullType(String),
    );
    yield r'baseCurrency';
    yield serializers.serialize(
      object.baseCurrency,
      specifiedType: const FullType(String),
    );
    yield r'numerator';
    yield serializers.serialize(
      object.numerator,
      specifiedType: const FullType(String),
    );
    yield r'denominator';
    yield serializers.serialize(
      object.denominator,
      specifiedType: const FullType(String),
    );
    yield r'editorId';
    yield serializers.serialize(
      object.editorId,
      specifiedType: const FullType(String),
    );
    yield r'editorName';
    yield object.editorName == null
        ? null
        : serializers.serialize(
            object.editorName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'setAt';
    yield serializers.serialize(
      object.setAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminExchangeRatesDtoOutputCurrenciesInnerRate object, {
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
    required AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'versionId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.versionId = valueDes;
          break;
        case r'baseCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.baseCurrency = valueDes;
          break;
        case r'numerator':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.numerator = valueDes;
          break;
        case r'denominator':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.denominator = valueDes;
          break;
        case r'editorId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.editorId = valueDes;
          break;
        case r'editorName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.editorName = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'setAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.setAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminExchangeRatesDtoOutputCurrenciesInnerRate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder();
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
