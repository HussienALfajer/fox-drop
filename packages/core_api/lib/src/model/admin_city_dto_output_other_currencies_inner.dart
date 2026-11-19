//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_city_dto_output_other_currencies_inner.g.dart';

/// AdminCityDtoOutputOtherCurrenciesInner
///
/// Properties:
/// * [code]
/// * [name]
/// * [symbol]
@BuiltValue()
abstract class AdminCityDtoOutputOtherCurrenciesInner
    implements
        Built<
          AdminCityDtoOutputOtherCurrenciesInner,
          AdminCityDtoOutputOtherCurrenciesInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'symbol')
  String get symbol;

  AdminCityDtoOutputOtherCurrenciesInner._();

  factory AdminCityDtoOutputOtherCurrenciesInner([
    void updates(AdminCityDtoOutputOtherCurrenciesInnerBuilder b),
  ]) = _$AdminCityDtoOutputOtherCurrenciesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCityDtoOutputOtherCurrenciesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCityDtoOutputOtherCurrenciesInner> get serializer =>
      _$AdminCityDtoOutputOtherCurrenciesInnerSerializer();
}

class _$AdminCityDtoOutputOtherCurrenciesInnerSerializer
    implements PrimitiveSerializer<AdminCityDtoOutputOtherCurrenciesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCityDtoOutputOtherCurrenciesInner,
    _$AdminCityDtoOutputOtherCurrenciesInner,
  ];

  @override
  final String wireName = r'AdminCityDtoOutputOtherCurrenciesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCityDtoOutputOtherCurrenciesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'symbol';
    yield serializers.serialize(
      object.symbol,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCityDtoOutputOtherCurrenciesInner object, {
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
    required AdminCityDtoOutputOtherCurrenciesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
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
        case r'symbol':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.symbol = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCityDtoOutputOtherCurrenciesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCityDtoOutputOtherCurrenciesInnerBuilder();
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
