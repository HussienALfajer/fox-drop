//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_block_reasons_inner.g.dart';

/// AdminCustomerDtoOutputBlockReasonsInner
///
/// Properties:
/// * [code]
/// * [label]
@BuiltValue()
abstract class AdminCustomerDtoOutputBlockReasonsInner
    implements
        Built<
          AdminCustomerDtoOutputBlockReasonsInner,
          AdminCustomerDtoOutputBlockReasonsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  AdminCustomerDtoOutputBlockReasonsInner._();

  factory AdminCustomerDtoOutputBlockReasonsInner([
    void updates(AdminCustomerDtoOutputBlockReasonsInnerBuilder b),
  ]) = _$AdminCustomerDtoOutputBlockReasonsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputBlockReasonsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputBlockReasonsInner> get serializer =>
      _$AdminCustomerDtoOutputBlockReasonsInnerSerializer();
}

class _$AdminCustomerDtoOutputBlockReasonsInnerSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputBlockReasonsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputBlockReasonsInner,
    _$AdminCustomerDtoOutputBlockReasonsInner,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputBlockReasonsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputBlockReasonsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputBlockReasonsInner object, {
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
    required AdminCustomerDtoOutputBlockReasonsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputBlockReasonsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputBlockReasonsInnerBuilder();
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
