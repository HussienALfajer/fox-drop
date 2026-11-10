//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order_edit_choices_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_edit_choices.g.dart';

/// While placed, accepted, ready, picked up or arrived: «تعديل الطلب» (AP §9.3.3).
///
/// Properties:
/// * [afterPickup] - Picked up or arrived: only lines removed or lowered and a lower fee, with a responsible party (no menu).
/// * [extraPrepMaxMin] - order.eta_change_max_min.
/// * [items] - The items customers can order now, with their available options.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderEditChoices
    implements
        Built<
          AdminOrderDtoOutputOrderEditChoices,
          AdminOrderDtoOutputOrderEditChoicesBuilder
        > {
  /// Picked up or arrived: only lines removed or lowered and a lower fee, with a responsible party (no menu).
  @BuiltValueField(wireName: r'afterPickup')
  bool get afterPickup;

  /// order.eta_change_max_min.
  @BuiltValueField(wireName: r'extraPrepMaxMin')
  int get extraPrepMaxMin;

  /// The items customers can order now, with their available options.
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminOrderDtoOutputOrderEditChoicesItemsInner> get items;

  AdminOrderDtoOutputOrderEditChoices._();

  factory AdminOrderDtoOutputOrderEditChoices([
    void updates(AdminOrderDtoOutputOrderEditChoicesBuilder b),
  ]) = _$AdminOrderDtoOutputOrderEditChoices;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderEditChoicesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderEditChoices> get serializer =>
      _$AdminOrderDtoOutputOrderEditChoicesSerializer();
}

class _$AdminOrderDtoOutputOrderEditChoicesSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderEditChoices> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderEditChoices,
    _$AdminOrderDtoOutputOrderEditChoices,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderEditChoices';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderEditChoices object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'afterPickup';
    yield serializers.serialize(
      object.afterPickup,
      specifiedType: const FullType(bool),
    );
    yield r'extraPrepMaxMin';
    yield serializers.serialize(
      object.extraPrepMaxMin,
      specifiedType: const FullType(int),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderEditChoicesItemsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderEditChoices object, {
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
    required AdminOrderDtoOutputOrderEditChoicesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'afterPickup':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.afterPickup = valueDes;
          break;
        case r'extraPrepMaxMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.extraPrepMaxMin = valueDes;
          break;
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderDtoOutputOrderEditChoicesItemsInner),
                    ]),
                  )
                  as BuiltList<AdminOrderDtoOutputOrderEditChoicesItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderEditChoices deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderEditChoicesBuilder();
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
