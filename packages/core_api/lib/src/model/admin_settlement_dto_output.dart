//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_settlement_dto_output_receipts_inner.dart';
import 'package:core_api/src/model/admin_settlement_dto_output_statement.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlement_dto_output.g.dart';

/// AdminSettlementDtoOutput
///
/// Properties:
/// * [statement]
/// * [receipts]
@BuiltValue()
abstract class AdminSettlementDtoOutput
    implements
        Built<AdminSettlementDtoOutput, AdminSettlementDtoOutputBuilder> {
  @BuiltValueField(wireName: r'statement')
  AdminSettlementDtoOutputStatement get statement;

  @BuiltValueField(wireName: r'receipts')
  BuiltList<AdminSettlementDtoOutputReceiptsInner> get receipts;

  AdminSettlementDtoOutput._();

  factory AdminSettlementDtoOutput([
    void updates(AdminSettlementDtoOutputBuilder b),
  ]) = _$AdminSettlementDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettlementDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementDtoOutput> get serializer =>
      _$AdminSettlementDtoOutputSerializer();
}

class _$AdminSettlementDtoOutputSerializer
    implements PrimitiveSerializer<AdminSettlementDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminSettlementDtoOutput,
    _$AdminSettlementDtoOutput,
  ];

  @override
  final String wireName = r'AdminSettlementDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'statement';
    yield serializers.serialize(
      object.statement,
      specifiedType: const FullType(AdminSettlementDtoOutputStatement),
    );
    yield r'receipts';
    yield serializers.serialize(
      object.receipts,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSettlementDtoOutputReceiptsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementDtoOutput object, {
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
    required AdminSettlementDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'statement':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSettlementDtoOutputStatement,
                    ),
                  )
                  as AdminSettlementDtoOutputStatement;
          result.statement.replace(valueDes);
          break;
        case r'receipts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSettlementDtoOutputReceiptsInner),
                    ]),
                  )
                  as BuiltList<AdminSettlementDtoOutputReceiptsInner>;
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
  AdminSettlementDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettlementDtoOutputBuilder();
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
