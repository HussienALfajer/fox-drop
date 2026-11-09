//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_work_rules_dto_output.g.dart';

/// AdminWorkRulesDtoOutput
///
/// Properties:
/// * [workRules] 
@BuiltValue()
abstract class AdminWorkRulesDtoOutput implements Built<AdminWorkRulesDtoOutput, AdminWorkRulesDtoOutputBuilder> {
  @BuiltValueField(wireName: r'workRules')
  String get workRules;

  AdminWorkRulesDtoOutput._();

  factory AdminWorkRulesDtoOutput([void updates(AdminWorkRulesDtoOutputBuilder b)]) = _$AdminWorkRulesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminWorkRulesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminWorkRulesDtoOutput> get serializer => _$AdminWorkRulesDtoOutputSerializer();
}

class _$AdminWorkRulesDtoOutputSerializer implements PrimitiveSerializer<AdminWorkRulesDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminWorkRulesDtoOutput, _$AdminWorkRulesDtoOutput];

  @override
  final String wireName = r'AdminWorkRulesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminWorkRulesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'workRules';
    yield serializers.serialize(
      object.workRules,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminWorkRulesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminWorkRulesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'workRules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.workRules = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminWorkRulesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminWorkRulesDtoOutputBuilder();
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


