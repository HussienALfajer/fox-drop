//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_set_carried_currencies_dto.g.dart';

/// CaptainSetCarriedCurrenciesDto
///
/// Properties:
/// * [currencies] - The currencies carried, one at least, the base among them or not.
@BuiltValue()
abstract class CaptainSetCarriedCurrenciesDto
    implements
        Built<
          CaptainSetCarriedCurrenciesDto,
          CaptainSetCarriedCurrenciesDtoBuilder
        > {
  /// The currencies carried, one at least, the base among them or not.
  @BuiltValueField(wireName: r'currencies')
  BuiltList<String> get currencies;

  CaptainSetCarriedCurrenciesDto._();

  factory CaptainSetCarriedCurrenciesDto([
    void updates(CaptainSetCarriedCurrenciesDtoBuilder b),
  ]) = _$CaptainSetCarriedCurrenciesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainSetCarriedCurrenciesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainSetCarriedCurrenciesDto> get serializer =>
      _$CaptainSetCarriedCurrenciesDtoSerializer();
}

class _$CaptainSetCarriedCurrenciesDtoSerializer
    implements PrimitiveSerializer<CaptainSetCarriedCurrenciesDto> {
  @override
  final Iterable<Type> types = const [
    CaptainSetCarriedCurrenciesDto,
    _$CaptainSetCarriedCurrenciesDto,
  ];

  @override
  final String wireName = r'CaptainSetCarriedCurrenciesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainSetCarriedCurrenciesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainSetCarriedCurrenciesDto object, {
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
    required CaptainSetCarriedCurrenciesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.currencies.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainSetCarriedCurrenciesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainSetCarriedCurrenciesDtoBuilder();
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
