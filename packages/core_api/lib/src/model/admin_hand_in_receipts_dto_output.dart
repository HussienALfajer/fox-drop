//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_hand_in_receipts_dto_output_receipts_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_hand_in_receipts_dto_output.g.dart';

/// AdminHandInReceiptsDtoOutput
///
/// Properties:
/// * [receipts]
@BuiltValue()
abstract class AdminHandInReceiptsDtoOutput
    implements
        Built<
          AdminHandInReceiptsDtoOutput,
          AdminHandInReceiptsDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'receipts')
  BuiltList<AdminHandInReceiptsDtoOutputReceiptsInner> get receipts;

  AdminHandInReceiptsDtoOutput._();

  factory AdminHandInReceiptsDtoOutput([
    void updates(AdminHandInReceiptsDtoOutputBuilder b),
  ]) = _$AdminHandInReceiptsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHandInReceiptsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHandInReceiptsDtoOutput> get serializer =>
      _$AdminHandInReceiptsDtoOutputSerializer();
}

class _$AdminHandInReceiptsDtoOutputSerializer
    implements PrimitiveSerializer<AdminHandInReceiptsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminHandInReceiptsDtoOutput,
    _$AdminHandInReceiptsDtoOutput,
  ];

  @override
  final String wireName = r'AdminHandInReceiptsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHandInReceiptsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'receipts';
    yield serializers.serialize(
      object.receipts,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminHandInReceiptsDtoOutputReceiptsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminHandInReceiptsDtoOutput object, {
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
    required AdminHandInReceiptsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'receipts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminHandInReceiptsDtoOutputReceiptsInner),
                    ]),
                  )
                  as BuiltList<AdminHandInReceiptsDtoOutputReceiptsInner>;
          result.receipts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminHandInReceiptsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHandInReceiptsDtoOutputBuilder();
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
