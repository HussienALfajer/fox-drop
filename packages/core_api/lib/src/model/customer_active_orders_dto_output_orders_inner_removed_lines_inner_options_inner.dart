//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_removed_lines_inner_options_inner.g.dart';

/// CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
///
/// Properties:
/// * [name]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner,
          CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'name')
  String get name;

  CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner([
    void updates(
      CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInnerBuilder
      b,
    ),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInnerBuilder
    b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
  >
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInnerSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInnerSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner,
    _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner,
  ];

  @override
  final String wireName =
      r'CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
    object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
    object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInnerBuilder();
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
