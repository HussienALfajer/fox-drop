//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_account_state_dto_output_block.g.dart';

/// CustomerAccountStateDtoOutputBlock
///
/// Properties:
/// * [until] - «حسابك محظور حتى {التاريخ}: {السبب}»; null «حسابك محظور: {السبب}. تواصل مع الدعم.»
/// * [reason] - The block reason's customer text (CU Appendix C).
@BuiltValue()
abstract class CustomerAccountStateDtoOutputBlock
    implements
        Built<
          CustomerAccountStateDtoOutputBlock,
          CustomerAccountStateDtoOutputBlockBuilder
        > {
  /// «حسابك محظور حتى {التاريخ}: {السبب}»; null «حسابك محظور: {السبب}. تواصل مع الدعم.»
  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  /// The block reason's customer text (CU Appendix C).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  CustomerAccountStateDtoOutputBlock._();

  factory CustomerAccountStateDtoOutputBlock([
    void updates(CustomerAccountStateDtoOutputBlockBuilder b),
  ]) = _$CustomerAccountStateDtoOutputBlock;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerAccountStateDtoOutputBlockBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerAccountStateDtoOutputBlock> get serializer =>
      _$CustomerAccountStateDtoOutputBlockSerializer();
}

class _$CustomerAccountStateDtoOutputBlockSerializer
    implements PrimitiveSerializer<CustomerAccountStateDtoOutputBlock> {
  @override
  final Iterable<Type> types = const [
    CustomerAccountStateDtoOutputBlock,
    _$CustomerAccountStateDtoOutputBlock,
  ];

  @override
  final String wireName = r'CustomerAccountStateDtoOutputBlock';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerAccountStateDtoOutputBlock object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerAccountStateDtoOutputBlock object, {
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
    required CustomerAccountStateDtoOutputBlockBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerAccountStateDtoOutputBlock deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerAccountStateDtoOutputBlockBuilder();
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
