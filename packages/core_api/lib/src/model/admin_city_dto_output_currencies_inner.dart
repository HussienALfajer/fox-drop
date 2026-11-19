//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_city_dto_output_currencies_inner.g.dart';

/// AdminCityDtoOutputCurrenciesInner
///
/// Properties:
/// * [code]
/// * [name]
/// * [symbol]
/// * [displayOrder]
/// * [enabled]
/// * [isBase]
@BuiltValue()
abstract class AdminCityDtoOutputCurrenciesInner
    implements
        Built<
          AdminCityDtoOutputCurrenciesInner,
          AdminCityDtoOutputCurrenciesInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'symbol')
  String get symbol;

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'isBase')
  bool get isBase;

  AdminCityDtoOutputCurrenciesInner._();

  factory AdminCityDtoOutputCurrenciesInner([
    void updates(AdminCityDtoOutputCurrenciesInnerBuilder b),
  ]) = _$AdminCityDtoOutputCurrenciesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCityDtoOutputCurrenciesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCityDtoOutputCurrenciesInner> get serializer =>
      _$AdminCityDtoOutputCurrenciesInnerSerializer();
}

class _$AdminCityDtoOutputCurrenciesInnerSerializer
    implements PrimitiveSerializer<AdminCityDtoOutputCurrenciesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCityDtoOutputCurrenciesInner,
    _$AdminCityDtoOutputCurrenciesInner,
  ];

  @override
  final String wireName = r'AdminCityDtoOutputCurrenciesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCityDtoOutputCurrenciesInner object, {
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
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
      specifiedType: const FullType(int),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'isBase';
    yield serializers.serialize(
      object.isBase,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCityDtoOutputCurrenciesInner object, {
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
    required AdminCityDtoOutputCurrenciesInnerBuilder result,
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
        case r'displayOrder':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.displayOrder = valueDes;
          break;
        case r'enabled':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.enabled = valueDes;
          break;
        case r'isBase':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.isBase = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCityDtoOutputCurrenciesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCityDtoOutputCurrenciesInnerBuilder();
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
