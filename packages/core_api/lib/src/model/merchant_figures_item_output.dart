//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_item_output.g.dart';

/// MerchantFiguresItemOutput
///
/// Properties:
/// * [itemId]
/// * [name] - Its name on the latest order.
/// * [quantity]
/// * [sales]
@BuiltValue()
abstract class MerchantFiguresItemOutput
    implements
        Built<MerchantFiguresItemOutput, MerchantFiguresItemOutputBuilder> {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  /// Its name on the latest order.
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  @BuiltValueField(wireName: r'sales')
  String get sales;

  MerchantFiguresItemOutput._();

  factory MerchantFiguresItemOutput([
    void updates(MerchantFiguresItemOutputBuilder b),
  ]) = _$MerchantFiguresItemOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantFiguresItemOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresItemOutput> get serializer =>
      _$MerchantFiguresItemOutputSerializer();
}

class _$MerchantFiguresItemOutputSerializer
    implements PrimitiveSerializer<MerchantFiguresItemOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresItemOutput,
    _$MerchantFiguresItemOutput,
  ];

  @override
  final String wireName = r'MerchantFiguresItemOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresItemOutput object, {
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
    MerchantFiguresItemOutput object, {
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
    required MerchantFiguresItemOutputBuilder result,
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
  MerchantFiguresItemOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresItemOutputBuilder();
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
