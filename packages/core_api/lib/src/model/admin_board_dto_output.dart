//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_board_dto_output.g.dart';

/// AdminBoardDtoOutput
///
/// Properties:
/// * [orders] - Every live order, oldest first.
@BuiltValue()
abstract class AdminBoardDtoOutput
    implements Built<AdminBoardDtoOutput, AdminBoardDtoOutputBuilder> {
  /// Every live order, oldest first.
  @BuiltValueField(wireName: r'orders')
  BuiltList<AdminOrderCardDtoOutputOrder> get orders;

  AdminBoardDtoOutput._();

  factory AdminBoardDtoOutput([void updates(AdminBoardDtoOutputBuilder b)]) =
      _$AdminBoardDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBoardDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBoardDtoOutput> get serializer =>
      _$AdminBoardDtoOutputSerializer();
}

class _$AdminBoardDtoOutputSerializer
    implements PrimitiveSerializer<AdminBoardDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminBoardDtoOutput,
    _$AdminBoardDtoOutput,
  ];

  @override
  final String wireName = r'AdminBoardDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBoardDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderCardDtoOutputOrder),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBoardDtoOutput object, {
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
    required AdminBoardDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderCardDtoOutputOrder),
                    ]),
                  )
                  as BuiltList<AdminOrderCardDtoOutputOrder>;
          result.orders.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBoardDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBoardDtoOutputBuilder();
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
