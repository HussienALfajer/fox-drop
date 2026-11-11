//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_carried_currencies_dto_output_choices_inner.g.dart';

/// CaptainCarriedCurrenciesDtoOutputChoicesInner
///
/// Properties:
/// * [currency]
/// * [name]
@BuiltValue()
abstract class CaptainCarriedCurrenciesDtoOutputChoicesInner
    implements
        Built<
          CaptainCarriedCurrenciesDtoOutputChoicesInner,
          CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'name')
  String get name;

  CaptainCarriedCurrenciesDtoOutputChoicesInner._();

  factory CaptainCarriedCurrenciesDtoOutputChoicesInner([
    void updates(CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder b),
  ]) = _$CaptainCarriedCurrenciesDtoOutputChoicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCarriedCurrenciesDtoOutputChoicesInner>
  get serializer => _$CaptainCarriedCurrenciesDtoOutputChoicesInnerSerializer();
}

class _$CaptainCarriedCurrenciesDtoOutputChoicesInnerSerializer
    implements
        PrimitiveSerializer<CaptainCarriedCurrenciesDtoOutputChoicesInner> {
  @override
  final Iterable<Type> types = const [
    CaptainCarriedCurrenciesDtoOutputChoicesInner,
    _$CaptainCarriedCurrenciesDtoOutputChoicesInner,
  ];

  @override
  final String wireName = r'CaptainCarriedCurrenciesDtoOutputChoicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCarriedCurrenciesDtoOutputChoicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCarriedCurrenciesDtoOutputChoicesInner object, {
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
    required CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder result,
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
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCarriedCurrenciesDtoOutputChoicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder();
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
