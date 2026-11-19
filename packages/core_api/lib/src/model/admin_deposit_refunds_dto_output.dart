//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_deposit_refunds_dto_output_contracts_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_deposit_refunds_dto_output.g.dart';

/// AdminDepositRefundsDtoOutput
///
/// Properties:
/// * [contracts]
@BuiltValue()
abstract class AdminDepositRefundsDtoOutput
    implements
        Built<
          AdminDepositRefundsDtoOutput,
          AdminDepositRefundsDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'contracts')
  BuiltList<AdminDepositRefundsDtoOutputContractsInner> get contracts;

  AdminDepositRefundsDtoOutput._();

  factory AdminDepositRefundsDtoOutput([
    void updates(AdminDepositRefundsDtoOutputBuilder b),
  ]) = _$AdminDepositRefundsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDepositRefundsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDepositRefundsDtoOutput> get serializer =>
      _$AdminDepositRefundsDtoOutputSerializer();
}

class _$AdminDepositRefundsDtoOutputSerializer
    implements PrimitiveSerializer<AdminDepositRefundsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDepositRefundsDtoOutput,
    _$AdminDepositRefundsDtoOutput,
  ];

  @override
  final String wireName = r'AdminDepositRefundsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDepositRefundsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contracts';
    yield serializers.serialize(
      object.contracts,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDepositRefundsDtoOutputContractsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDepositRefundsDtoOutput object, {
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
    required AdminDepositRefundsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contracts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDepositRefundsDtoOutputContractsInner),
                    ]),
                  )
                  as BuiltList<AdminDepositRefundsDtoOutputContractsInner>;
          result.contracts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDepositRefundsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDepositRefundsDtoOutputBuilder();
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
