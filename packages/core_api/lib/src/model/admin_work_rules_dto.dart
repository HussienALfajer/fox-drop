//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_work_rules_dto.g.dart';

/// AdminWorkRulesDto
///
/// Properties:
/// * [workRules]
@BuiltValue()
abstract class AdminWorkRulesDto
    implements Built<AdminWorkRulesDto, AdminWorkRulesDtoBuilder> {
  @BuiltValueField(wireName: r'workRules')
  String get workRules;

  AdminWorkRulesDto._();

  factory AdminWorkRulesDto([void updates(AdminWorkRulesDtoBuilder b)]) =
      _$AdminWorkRulesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminWorkRulesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminWorkRulesDto> get serializer =>
      _$AdminWorkRulesDtoSerializer();
}

class _$AdminWorkRulesDtoSerializer
    implements PrimitiveSerializer<AdminWorkRulesDto> {
  @override
  final Iterable<Type> types = const [AdminWorkRulesDto, _$AdminWorkRulesDto];

  @override
  final String wireName = r'AdminWorkRulesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminWorkRulesDto object, {
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
    AdminWorkRulesDto object, {
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
    required AdminWorkRulesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'workRules':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
  AdminWorkRulesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminWorkRulesDtoBuilder();
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
