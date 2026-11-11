//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_carried_currencies_dto_output_choices_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_carried_currencies_dto_output.g.dart';

/// CaptainCarriedCurrenciesDtoOutput
///
/// Properties:
/// * [baseCurrency] - Null while the city has none.
/// * [carried] - «العملات التي أحملها» (CA §10.5), in the city’s display order.
/// * [choices] - Every currency the city has enabled, the base among them, with its Arabic name.
@BuiltValue()
abstract class CaptainCarriedCurrenciesDtoOutput
    implements
        Built<
          CaptainCarriedCurrenciesDtoOutput,
          CaptainCarriedCurrenciesDtoOutputBuilder
        > {
  /// Null while the city has none.
  @BuiltValueField(wireName: r'baseCurrency')
  String? get baseCurrency;

  /// «العملات التي أحملها» (CA §10.5), in the city’s display order.
  @BuiltValueField(wireName: r'carried')
  BuiltList<String> get carried;

  /// Every currency the city has enabled, the base among them, with its Arabic name.
  @BuiltValueField(wireName: r'choices')
  BuiltList<CaptainCarriedCurrenciesDtoOutputChoicesInner> get choices;

  CaptainCarriedCurrenciesDtoOutput._();

  factory CaptainCarriedCurrenciesDtoOutput([
    void updates(CaptainCarriedCurrenciesDtoOutputBuilder b),
  ]) = _$CaptainCarriedCurrenciesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCarriedCurrenciesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCarriedCurrenciesDtoOutput> get serializer =>
      _$CaptainCarriedCurrenciesDtoOutputSerializer();
}

class _$CaptainCarriedCurrenciesDtoOutputSerializer
    implements PrimitiveSerializer<CaptainCarriedCurrenciesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainCarriedCurrenciesDtoOutput,
    _$CaptainCarriedCurrenciesDtoOutput,
  ];

  @override
  final String wireName = r'CaptainCarriedCurrenciesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCarriedCurrenciesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'baseCurrency';
    yield object.baseCurrency == null
        ? null
        : serializers.serialize(
            object.baseCurrency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'carried';
    yield serializers.serialize(
      object.carried,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'choices';
    yield serializers.serialize(
      object.choices,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainCarriedCurrenciesDtoOutputChoicesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCarriedCurrenciesDtoOutput object, {
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
    required CaptainCarriedCurrenciesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'baseCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.baseCurrency = valueDes;
          break;
        case r'carried':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.carried.replace(valueDes);
          break;
        case r'choices':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainCarriedCurrenciesDtoOutputChoicesInner),
                    ]),
                  )
                  as BuiltList<CaptainCarriedCurrenciesDtoOutputChoicesInner>;
          result.choices.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCarriedCurrenciesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCarriedCurrenciesDtoOutputBuilder();
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
