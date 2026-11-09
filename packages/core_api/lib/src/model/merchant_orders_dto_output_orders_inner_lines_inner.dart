//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_lines_inner_options_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_lines_inner.g.dart';

/// MerchantOrdersDtoOutputOrdersInnerLinesInner
///
/// Properties:
/// * [itemId] - «صنف غير متوفر» picks the items by it (RA §8.6).
/// * [name]
/// * [quantity]
/// * [options]
/// * [note]
/// * [lineTotal] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerLinesInner
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerLinesInner,
          MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder
        > {
  /// «صنف غير متوفر» picks the items by it (RA §8.6).
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  @BuiltValueField(wireName: r'options')
  BuiltList<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>
  get options;

  @BuiltValueField(wireName: r'note')
  String? get note;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'lineTotal')
  String get lineTotal;

  MerchantOrdersDtoOutputOrdersInnerLinesInner._();

  factory MerchantOrdersDtoOutputOrdersInnerLinesInner([
    void updates(MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder b),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerLinesInner>
  get serializer => _$MerchantOrdersDtoOutputOrdersInnerLinesInnerSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerLinesInnerSerializer
    implements
        PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerLinesInner> {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerLinesInner,
    _$MerchantOrdersDtoOutputOrdersInnerLinesInner,
  ];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerLinesInner object, {
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
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner),
      ]),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'lineTotal';
    yield serializers.serialize(
      object.lineTotal,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerLinesInner object, {
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
    required MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder result,
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
        case r'options':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner
                  >;
          result.options.replace(valueDes);
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
        case r'lineTotal':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
  MerchantOrdersDtoOutputOrdersInnerLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder();
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
