//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_quote_dto_output_lines_inner_options_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_lines_inner.g.dart';

/// CustomerQuoteDtoOutputLinesInner
///
/// Properties:
/// * [itemId] 
/// * [name] - Null for an item no longer on the menu.
/// * [quantity] 
/// * [note] 
/// * [options] 
/// * [unitPrice] - Integer minor units (AP §8.6).
/// * [lineTotal] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class CustomerQuoteDtoOutputLinesInner implements Built<CustomerQuoteDtoOutputLinesInner, CustomerQuoteDtoOutputLinesInnerBuilder> {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  /// Null for an item no longer on the menu.
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'options')
  BuiltList<CustomerQuoteDtoOutputLinesInnerOptionsInner> get options;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'unitPrice')
  String? get unitPrice;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'lineTotal')
  String? get lineTotal;

  CustomerQuoteDtoOutputLinesInner._();

  factory CustomerQuoteDtoOutputLinesInner([void updates(CustomerQuoteDtoOutputLinesInnerBuilder b)]) = _$CustomerQuoteDtoOutputLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputLinesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputLinesInner> get serializer => _$CustomerQuoteDtoOutputLinesInnerSerializer();
}

class _$CustomerQuoteDtoOutputLinesInnerSerializer implements PrimitiveSerializer<CustomerQuoteDtoOutputLinesInner> {
  @override
  final Iterable<Type> types = const [CustomerQuoteDtoOutputLinesInner, _$CustomerQuoteDtoOutputLinesInner];

  @override
  final String wireName = r'CustomerQuoteDtoOutputLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [FullType(CustomerQuoteDtoOutputLinesInnerOptionsInner)]),
    );
    yield r'unitPrice';
    yield object.unitPrice == null ? null : serializers.serialize(
      object.unitPrice,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lineTotal';
    yield object.lineTotal == null ? null : serializers.serialize(
      object.lineTotal,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerQuoteDtoOutputLinesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.itemId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.quantity = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CustomerQuoteDtoOutputLinesInnerOptionsInner)]),
          ) as BuiltList<CustomerQuoteDtoOutputLinesInnerOptionsInner>;
          result.options.replace(valueDes);
          break;
        case r'unitPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unitPrice = valueDes;
          break;
        case r'lineTotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lineTotal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputLinesInnerBuilder();
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


