//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_cancel_choices_reasons_inner.g.dart';

/// AdminOrderDtoOutputOrderCancelChoicesReasonsInner
///
/// Properties:
/// * [code]
/// * [label]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderCancelChoicesReasonsInner
    implements
        Built<
          AdminOrderDtoOutputOrderCancelChoicesReasonsInner,
          AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  AdminOrderDtoOutputOrderCancelChoicesReasonsInner._();

  factory AdminOrderDtoOutputOrderCancelChoicesReasonsInner([
    void updates(AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderCancelChoicesReasonsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderCancelChoicesReasonsInner>
  get serializer =>
      _$AdminOrderDtoOutputOrderCancelChoicesReasonsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderCancelChoicesReasonsInnerSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderCancelChoicesReasonsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderCancelChoicesReasonsInner,
    _$AdminOrderDtoOutputOrderCancelChoicesReasonsInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderCancelChoicesReasonsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderCancelChoicesReasonsInner object, {
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
    AdminOrderDtoOutputOrderCancelChoicesReasonsInner object, {
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
    required AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder result,
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
  AdminOrderDtoOutputOrderCancelChoicesReasonsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder();
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
