//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_dto_output_current_top_by_quantity_inner.g.dart';

/// MerchantFiguresDtoOutputCurrentTopByQuantityInner
///
/// Properties:
/// * [itemId]
/// * [name] - Its name on the latest order.
/// * [quantity]
/// * [sales]
@BuiltValue()
abstract class MerchantFiguresDtoOutputCurrentTopByQuantityInner
    implements
        Built<
          MerchantFiguresDtoOutputCurrentTopByQuantityInner,
          MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder
        > {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  /// Its name on the latest order.
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  @BuiltValueField(wireName: r'sales')
  String get sales;

  MerchantFiguresDtoOutputCurrentTopByQuantityInner._();

  factory MerchantFiguresDtoOutputCurrentTopByQuantityInner([
    void updates(MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder b),
  ]) = _$MerchantFiguresDtoOutputCurrentTopByQuantityInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresDtoOutputCurrentTopByQuantityInner>
  get serializer =>
      _$MerchantFiguresDtoOutputCurrentTopByQuantityInnerSerializer();
}

class _$MerchantFiguresDtoOutputCurrentTopByQuantityInnerSerializer
    implements
        PrimitiveSerializer<MerchantFiguresDtoOutputCurrentTopByQuantityInner> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresDtoOutputCurrentTopByQuantityInner,
    _$MerchantFiguresDtoOutputCurrentTopByQuantityInner,
  ];

  @override
  final String wireName = r'MerchantFiguresDtoOutputCurrentTopByQuantityInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresDtoOutputCurrentTopByQuantityInner object, {
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
    yield r'sales';
    yield serializers.serialize(
      object.sales,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantFiguresDtoOutputCurrentTopByQuantityInner object, {
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
    required MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder result,
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
        case r'sales':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.sales = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantFiguresDtoOutputCurrentTopByQuantityInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder();
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
