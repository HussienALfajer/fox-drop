//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_reassign_choices_reasons_inner.g.dart';

/// AdminOrderDtoOutputOrderReassignChoicesReasonsInner
///
/// Properties:
/// * [code]
/// * [label]
/// * [captainFault] - The default fault the dialog prefills.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderReassignChoicesReasonsInner
    implements
        Built<
          AdminOrderDtoOutputOrderReassignChoicesReasonsInner,
          AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  /// The default fault the dialog prefills.
  @BuiltValueField(wireName: r'captainFault')
  bool get captainFault;

  AdminOrderDtoOutputOrderReassignChoicesReasonsInner._();

  factory AdminOrderDtoOutputOrderReassignChoicesReasonsInner([
    void updates(AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderReassignChoicesReasonsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderReassignChoicesReasonsInner>
  get serializer =>
      _$AdminOrderDtoOutputOrderReassignChoicesReasonsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderReassignChoicesReasonsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderReassignChoicesReasonsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderReassignChoicesReasonsInner,
    _$AdminOrderDtoOutputOrderReassignChoicesReasonsInner,
  ];

  @override
  final String wireName =
      r'AdminOrderDtoOutputOrderReassignChoicesReasonsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderReassignChoicesReasonsInner object, {
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
    yield r'captainFault';
    yield serializers.serialize(
      object.captainFault,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderReassignChoicesReasonsInner object, {
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
    required AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder result,
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
        case r'captainFault':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.captainFault = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderReassignChoicesReasonsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder();
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
