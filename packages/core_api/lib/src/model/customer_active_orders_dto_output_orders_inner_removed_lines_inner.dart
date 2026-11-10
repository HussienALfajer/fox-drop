//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_removed_lines_inner_options_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_removed_lines_inner.g.dart';

/// CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner
///
/// Properties:
/// * [name]
/// * [quantity]
/// * [options]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner,
          CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  @BuiltValueField(wireName: r'options')
  BuiltList<
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
  >
  get options;

  CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner([
    void updates(
      CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder b,
    ),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner,
    _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner,
  ];

  @override
  final String wireName =
      r'CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
        FullType(
          CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner,
        ),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder
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
                        CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
                  >;
          result.options.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder();
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
