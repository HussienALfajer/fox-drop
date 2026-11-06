//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_lines_inner_options_inner.g.dart';

/// CustomerQuoteDtoOutputLinesInnerOptionsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [priceDelta] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class CustomerQuoteDtoOutputLinesInnerOptionsInner
    implements
        Built<
          CustomerQuoteDtoOutputLinesInnerOptionsInner,
          CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'priceDelta')
  String get priceDelta;

  CustomerQuoteDtoOutputLinesInnerOptionsInner._();

  factory CustomerQuoteDtoOutputLinesInnerOptionsInner([
    void updates(CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder b),
  ]) = _$CustomerQuoteDtoOutputLinesInnerOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputLinesInnerOptionsInner>
  get serializer => _$CustomerQuoteDtoOutputLinesInnerOptionsInnerSerializer();
}

class _$CustomerQuoteDtoOutputLinesInnerOptionsInnerSerializer
    implements
        PrimitiveSerializer<CustomerQuoteDtoOutputLinesInnerOptionsInner> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteDtoOutputLinesInnerOptionsInner,
    _$CustomerQuoteDtoOutputLinesInnerOptionsInner,
  ];

  @override
  final String wireName = r'CustomerQuoteDtoOutputLinesInnerOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputLinesInnerOptionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'priceDelta';
    yield serializers.serialize(
      object.priceDelta,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputLinesInnerOptionsInner object, {
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
    required CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
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
        case r'priceDelta':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.priceDelta = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputLinesInnerOptionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder();
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
