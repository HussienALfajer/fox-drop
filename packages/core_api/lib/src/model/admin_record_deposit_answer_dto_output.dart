//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_record_deposit_answer_dto_output_receipt.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_record_deposit_answer_dto_output.g.dart';

/// AdminRecordDepositAnswerDtoOutput
///
/// Properties:
/// * [receipt]
@BuiltValue()
abstract class AdminRecordDepositAnswerDtoOutput
    implements
        Built<
          AdminRecordDepositAnswerDtoOutput,
          AdminRecordDepositAnswerDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'receipt')
  AdminRecordDepositAnswerDtoOutputReceipt? get receipt;

  AdminRecordDepositAnswerDtoOutput._();

  factory AdminRecordDepositAnswerDtoOutput([
    void updates(AdminRecordDepositAnswerDtoOutputBuilder b),
  ]) = _$AdminRecordDepositAnswerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRecordDepositAnswerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRecordDepositAnswerDtoOutput> get serializer =>
      _$AdminRecordDepositAnswerDtoOutputSerializer();
}

class _$AdminRecordDepositAnswerDtoOutputSerializer
    implements PrimitiveSerializer<AdminRecordDepositAnswerDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRecordDepositAnswerDtoOutput,
    _$AdminRecordDepositAnswerDtoOutput,
  ];

  @override
  final String wireName = r'AdminRecordDepositAnswerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRecordDepositAnswerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'receipt';
    yield object.receipt == null
        ? null
        : serializers.serialize(
            object.receipt,
            specifiedType: const FullType.nullable(
              AdminRecordDepositAnswerDtoOutputReceipt,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRecordDepositAnswerDtoOutput object, {
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
    required AdminRecordDepositAnswerDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'receipt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRecordDepositAnswerDtoOutputReceipt,
                    ),
                  )
                  as AdminRecordDepositAnswerDtoOutputReceipt?;
          if (valueDes == null) continue;
          result.receipt.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRecordDepositAnswerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRecordDepositAnswerDtoOutputBuilder();
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
