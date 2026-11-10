//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_removed_lines_inner.g.dart';

/// AdminOrderDtoOutputOrderRemovedLinesInner
///
/// Properties:
/// * [name]
/// * [quantity]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderRemovedLinesInner
    implements
        Built<
          AdminOrderDtoOutputOrderRemovedLinesInner,
          AdminOrderDtoOutputOrderRemovedLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  AdminOrderDtoOutputOrderRemovedLinesInner._();

  factory AdminOrderDtoOutputOrderRemovedLinesInner([
    void updates(AdminOrderDtoOutputOrderRemovedLinesInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderRemovedLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderRemovedLinesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderRemovedLinesInner> get serializer =>
      _$AdminOrderDtoOutputOrderRemovedLinesInnerSerializer();
}

class _$AdminOrderDtoOutputOrderRemovedLinesInnerSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderRemovedLinesInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderRemovedLinesInner,
    _$AdminOrderDtoOutputOrderRemovedLinesInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderRemovedLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderRemovedLinesInner object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderRemovedLinesInner object, {
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
    required AdminOrderDtoOutputOrderRemovedLinesInnerBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderRemovedLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderRemovedLinesInnerBuilder();
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
