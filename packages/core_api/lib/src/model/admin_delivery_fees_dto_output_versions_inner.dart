//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_delivery_fees_dto_output_versions_inner_rule.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_delivery_fees_dto_output_versions_inner.g.dart';

/// AdminDeliveryFeesDtoOutputVersionsInner
///
/// Properties:
/// * [rule]
/// * [editorName] - Null for the system or an unknown admin.
/// * [reason]
/// * [createdAt]
@BuiltValue()
abstract class AdminDeliveryFeesDtoOutputVersionsInner
    implements
        Built<
          AdminDeliveryFeesDtoOutputVersionsInner,
          AdminDeliveryFeesDtoOutputVersionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'rule')
  AdminDeliveryFeesDtoOutputVersionsInnerRule get rule;

  /// Null for the system or an unknown admin.
  @BuiltValueField(wireName: r'editorName')
  String? get editorName;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminDeliveryFeesDtoOutputVersionsInner._();

  factory AdminDeliveryFeesDtoOutputVersionsInner([
    void updates(AdminDeliveryFeesDtoOutputVersionsInnerBuilder b),
  ]) = _$AdminDeliveryFeesDtoOutputVersionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeliveryFeesDtoOutputVersionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeliveryFeesDtoOutputVersionsInner> get serializer =>
      _$AdminDeliveryFeesDtoOutputVersionsInnerSerializer();
}

class _$AdminDeliveryFeesDtoOutputVersionsInnerSerializer
    implements PrimitiveSerializer<AdminDeliveryFeesDtoOutputVersionsInner> {
  @override
  final Iterable<Type> types = const [
    AdminDeliveryFeesDtoOutputVersionsInner,
    _$AdminDeliveryFeesDtoOutputVersionsInner,
  ];

  @override
  final String wireName = r'AdminDeliveryFeesDtoOutputVersionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rule';
    yield serializers.serialize(
      object.rule,
      specifiedType: const FullType(
        AdminDeliveryFeesDtoOutputVersionsInnerRule,
      ),
    );
    yield r'editorName';
    yield object.editorName == null
        ? null
        : serializers.serialize(
            object.editorName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInner object, {
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
    required AdminDeliveryFeesDtoOutputVersionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rule':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeliveryFeesDtoOutputVersionsInnerRule,
                    ),
                  )
                  as AdminDeliveryFeesDtoOutputVersionsInnerRule;
          result.rule.replace(valueDes);
          break;
        case r'editorName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.editorName = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeliveryFeesDtoOutputVersionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeliveryFeesDtoOutputVersionsInnerBuilder();
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
