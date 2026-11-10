//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_edits_inner_items_value.g.dart';

/// AdminOrderDtoOutputOrderEditsInnerItemsValue
///
/// Properties:
/// * [before] - Integer minor units (AP §8.6).
/// * [after] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class AdminOrderDtoOutputOrderEditsInnerItemsValue
    implements
        Built<
          AdminOrderDtoOutputOrderEditsInnerItemsValue,
          AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'before')
  String get before;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'after')
  String get after;

  AdminOrderDtoOutputOrderEditsInnerItemsValue._();

  factory AdminOrderDtoOutputOrderEditsInnerItemsValue([
    void updates(AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder b),
  ]) = _$AdminOrderDtoOutputOrderEditsInnerItemsValue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderEditsInnerItemsValue>
  get serializer => _$AdminOrderDtoOutputOrderEditsInnerItemsValueSerializer();
}

class _$AdminOrderDtoOutputOrderEditsInnerItemsValueSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderEditsInnerItemsValue> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderEditsInnerItemsValue,
    _$AdminOrderDtoOutputOrderEditsInnerItemsValue,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderEditsInnerItemsValue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderEditsInnerItemsValue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'before';
    yield serializers.serialize(
      object.before,
      specifiedType: const FullType(String),
    );
    yield r'after';
    yield serializers.serialize(
      object.after,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderEditsInnerItemsValue object, {
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
    required AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'before':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.before = valueDes;
          break;
        case r'after':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.after = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderEditsInnerItemsValue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder();
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
