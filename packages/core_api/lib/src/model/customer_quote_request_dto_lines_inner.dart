//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_request_dto_lines_inner.g.dart';

/// CustomerQuoteRequestDtoLinesInner
///
/// Properties:
/// * [itemId]
/// * [optionIds]
/// * [quantity] - 1 to 20 per line (fixed).
/// * [note] - «مثلاً: بدون بصل», up to 100 characters; no phone number.
/// * [knownUnitPrice] - The unit price the customer last saw, with the options; a change is price_changed.
@BuiltValue()
abstract class CustomerQuoteRequestDtoLinesInner
    implements
        Built<
          CustomerQuoteRequestDtoLinesInner,
          CustomerQuoteRequestDtoLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  @BuiltValueField(wireName: r'optionIds')
  BuiltList<String> get optionIds;

  /// 1 to 20 per line (fixed).
  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  /// «مثلاً: بدون بصل», up to 100 characters; no phone number.
  @BuiltValueField(wireName: r'note')
  String? get note;

  /// The unit price the customer last saw, with the options; a change is price_changed.
  @BuiltValueField(wireName: r'knownUnitPrice')
  String get knownUnitPrice;

  CustomerQuoteRequestDtoLinesInner._();

  factory CustomerQuoteRequestDtoLinesInner([
    void updates(CustomerQuoteRequestDtoLinesInnerBuilder b),
  ]) = _$CustomerQuoteRequestDtoLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteRequestDtoLinesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteRequestDtoLinesInner> get serializer =>
      _$CustomerQuoteRequestDtoLinesInnerSerializer();
}

class _$CustomerQuoteRequestDtoLinesInnerSerializer
    implements PrimitiveSerializer<CustomerQuoteRequestDtoLinesInner> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteRequestDtoLinesInner,
    _$CustomerQuoteRequestDtoLinesInner,
  ];

  @override
  final String wireName = r'CustomerQuoteRequestDtoLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteRequestDtoLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'optionIds';
    yield serializers.serialize(
      object.optionIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'knownUnitPrice';
    yield serializers.serialize(
      object.knownUnitPrice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteRequestDtoLinesInner object, {
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
    required CustomerQuoteRequestDtoLinesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemId = valueDes;
          break;
        case r'optionIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.optionIds.replace(valueDes);
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'knownUnitPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.knownUnitPrice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteRequestDtoLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteRequestDtoLinesInnerBuilder();
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
