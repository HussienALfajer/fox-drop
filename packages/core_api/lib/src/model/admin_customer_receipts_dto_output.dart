//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_customer_receipts_dto_output_receipts_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_receipts_dto_output.g.dart';

/// AdminCustomerReceiptsDtoOutput
///
/// Properties:
/// * [receipts]
@BuiltValue()
abstract class AdminCustomerReceiptsDtoOutput
    implements
        Built<
          AdminCustomerReceiptsDtoOutput,
          AdminCustomerReceiptsDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'receipts')
  BuiltList<AdminCustomerReceiptsDtoOutputReceiptsInner> get receipts;

  AdminCustomerReceiptsDtoOutput._();

  factory AdminCustomerReceiptsDtoOutput([
    void updates(AdminCustomerReceiptsDtoOutputBuilder b),
  ]) = _$AdminCustomerReceiptsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerReceiptsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerReceiptsDtoOutput> get serializer =>
      _$AdminCustomerReceiptsDtoOutputSerializer();
}

class _$AdminCustomerReceiptsDtoOutputSerializer
    implements PrimitiveSerializer<AdminCustomerReceiptsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerReceiptsDtoOutput,
    _$AdminCustomerReceiptsDtoOutput,
  ];

  @override
  final String wireName = r'AdminCustomerReceiptsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerReceiptsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'receipts';
    yield serializers.serialize(
      object.receipts,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerReceiptsDtoOutputReceiptsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerReceiptsDtoOutput object, {
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
    required AdminCustomerReceiptsDtoOutputBuilder result,
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
                      FullType(AdminCustomerReceiptsDtoOutputReceiptsInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerReceiptsDtoOutputReceiptsInner>;
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
  AdminCustomerReceiptsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerReceiptsDtoOutputBuilder();
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
