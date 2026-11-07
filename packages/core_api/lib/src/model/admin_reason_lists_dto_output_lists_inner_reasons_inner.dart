//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reason_lists_dto_output_lists_inner_reasons_inner.g.dart';

/// AdminReasonListsDtoOutputListsInnerReasonsInner
///
/// Properties:
/// * [code]
/// * [label]
/// * [customerText]
/// * [needsText]
/// * [fixed] - The code acts on it: it cannot be removed.
/// * [active] - False once removed: hidden from new choices, kept on orders.
@BuiltValue()
abstract class AdminReasonListsDtoOutputListsInnerReasonsInner
    implements
        Built<
          AdminReasonListsDtoOutputListsInnerReasonsInner,
          AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'customerText')
  String? get customerText;

  @BuiltValueField(wireName: r'needsText')
  bool get needsText;

  /// The code acts on it: it cannot be removed.
  @BuiltValueField(wireName: r'fixed')
  bool get fixed;

  /// False once removed: hidden from new choices, kept on orders.
  @BuiltValueField(wireName: r'active')
  bool get active;

  AdminReasonListsDtoOutputListsInnerReasonsInner._();

  factory AdminReasonListsDtoOutputListsInnerReasonsInner([
    void updates(AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder b),
  ]) = _$AdminReasonListsDtoOutputListsInnerReasonsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReasonListsDtoOutputListsInnerReasonsInner>
  get serializer =>
      _$AdminReasonListsDtoOutputListsInnerReasonsInnerSerializer();
}

class _$AdminReasonListsDtoOutputListsInnerReasonsInnerSerializer
    implements
        PrimitiveSerializer<AdminReasonListsDtoOutputListsInnerReasonsInner> {
  @override
  final Iterable<Type> types = const [
    AdminReasonListsDtoOutputListsInnerReasonsInner,
    _$AdminReasonListsDtoOutputListsInnerReasonsInner,
  ];

  @override
  final String wireName = r'AdminReasonListsDtoOutputListsInnerReasonsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReasonListsDtoOutputListsInnerReasonsInner object, {
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
    yield r'customerText';
    yield object.customerText == null
        ? null
        : serializers.serialize(
            object.customerText,
            specifiedType: const FullType.nullable(String),
          );
    yield r'needsText';
    yield serializers.serialize(
      object.needsText,
      specifiedType: const FullType(bool),
    );
    yield r'fixed';
    yield serializers.serialize(
      object.fixed,
      specifiedType: const FullType(bool),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReasonListsDtoOutputListsInnerReasonsInner object, {
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
    required AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder result,
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
        case r'customerText':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.customerText = valueDes;
          break;
        case r'needsText':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.needsText = valueDes;
          break;
        case r'fixed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.fixed = valueDes;
          break;
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReasonListsDtoOutputListsInnerReasonsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder();
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
