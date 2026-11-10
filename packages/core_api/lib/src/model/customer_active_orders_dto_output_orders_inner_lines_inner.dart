//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_quote_dto_output_lines_inner_options_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_lines_inner.g.dart';

/// CustomerActiveOrdersDtoOutputOrdersInnerLinesInner
///
/// Properties:
/// * [itemId]
/// * [name]
/// * [quantity]
/// * [note]
/// * [options]
/// * [unitPrice] - Integer minor units (AP §8.6).
/// * [lineTotal] - Integer minor units (AP §8.6).
/// * [added] - Added by an edit of FOX DROP: marked «أُضيف» (CU §11.6).
/// * [quantityBefore] - The quantity before an edit changed it, shown beside the new one (CU §11.6).
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerLinesInner
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerLinesInner,
          CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'options')
  BuiltList<CustomerQuoteDtoOutputLinesInnerOptionsInner> get options;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'unitPrice')
  String get unitPrice;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'lineTotal')
  String get lineTotal;

  /// Added by an edit of FOX DROP: marked «أُضيف» (CU §11.6).
  @BuiltValueField(wireName: r'added')
  bool get added;

  /// The quantity before an edit changed it, shown beside the new one (CU §11.6).
  @BuiltValueField(wireName: r'quantityBefore')
  int? get quantityBefore;

  CustomerActiveOrdersDtoOutputOrdersInnerLinesInner._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerLinesInner([
    void updates(CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder b),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerLinesInner
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerLinesInner,
    _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInner,
  ];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
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
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerQuoteDtoOutputLinesInnerOptionsInner),
      ]),
    );
    yield r'unitPrice';
    yield serializers.serialize(
      object.unitPrice,
      specifiedType: const FullType(String),
    );
    yield r'lineTotal';
    yield serializers.serialize(
      object.lineTotal,
      specifiedType: const FullType(String),
    );
    yield r'added';
    yield serializers.serialize(
      object.added,
      specifiedType: const FullType(bool),
    );
    yield r'quantityBefore';
    yield object.quantityBefore == null
        ? null
        : serializers.serialize(
            object.quantityBefore,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerLinesInner object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
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
        case r'options':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerQuoteDtoOutputLinesInnerOptionsInner),
                    ]),
                  )
                  as BuiltList<CustomerQuoteDtoOutputLinesInnerOptionsInner>;
          result.options.replace(valueDes);
          break;
        case r'unitPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.unitPrice = valueDes;
          break;
        case r'lineTotal':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.lineTotal = valueDes;
          break;
        case r'added':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.added = valueDes;
          break;
        case r'quantityBefore':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.quantityBefore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder();
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
