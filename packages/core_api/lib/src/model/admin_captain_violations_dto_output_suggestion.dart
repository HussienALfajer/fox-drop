//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_violations_dto_output_suggestion.g.dart';

/// The next step for a type not severe; a severe one is always termination.
///
/// Properties:
/// * [step]
/// * [windowDays]
@BuiltValue()
abstract class AdminCaptainViolationsDtoOutputSuggestion
    implements
        Built<
          AdminCaptainViolationsDtoOutputSuggestion,
          AdminCaptainViolationsDtoOutputSuggestionBuilder
        > {
  @BuiltValueField(wireName: r'step')
  AdminCaptainViolationsDtoOutputSuggestionStepEnum get step;
  // enum stepEnum {  warning,  suspension_1d,  suspension_7d,  termination,  };

  @BuiltValueField(wireName: r'windowDays')
  int get windowDays;

  AdminCaptainViolationsDtoOutputSuggestion._();

  factory AdminCaptainViolationsDtoOutputSuggestion([
    void updates(AdminCaptainViolationsDtoOutputSuggestionBuilder b),
  ]) = _$AdminCaptainViolationsDtoOutputSuggestion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainViolationsDtoOutputSuggestionBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainViolationsDtoOutputSuggestion> get serializer =>
      _$AdminCaptainViolationsDtoOutputSuggestionSerializer();
}

class _$AdminCaptainViolationsDtoOutputSuggestionSerializer
    implements PrimitiveSerializer<AdminCaptainViolationsDtoOutputSuggestion> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainViolationsDtoOutputSuggestion,
    _$AdminCaptainViolationsDtoOutputSuggestion,
  ];

  @override
  final String wireName = r'AdminCaptainViolationsDtoOutputSuggestion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputSuggestion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'step';
    yield serializers.serialize(
      object.step,
      specifiedType: const FullType(
        AdminCaptainViolationsDtoOutputSuggestionStepEnum,
      ),
    );
    yield r'windowDays';
    yield serializers.serialize(
      object.windowDays,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputSuggestion object, {
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
    required AdminCaptainViolationsDtoOutputSuggestionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'step':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainViolationsDtoOutputSuggestionStepEnum,
                    ),
                  )
                  as AdminCaptainViolationsDtoOutputSuggestionStepEnum;
          result.step = valueDes;
          break;
        case r'windowDays':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.windowDays = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainViolationsDtoOutputSuggestion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainViolationsDtoOutputSuggestionBuilder();
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

class AdminCaptainViolationsDtoOutputSuggestionStepEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'warning')
  static const AdminCaptainViolationsDtoOutputSuggestionStepEnum warning =
      _$adminCaptainViolationsDtoOutputSuggestionStepEnum_warning;
  @BuiltValueEnumConst(wireName: r'suspension_1d')
  static const AdminCaptainViolationsDtoOutputSuggestionStepEnum suspension1d =
      _$adminCaptainViolationsDtoOutputSuggestionStepEnum_suspension1d;
  @BuiltValueEnumConst(wireName: r'suspension_7d')
  static const AdminCaptainViolationsDtoOutputSuggestionStepEnum suspension7d =
      _$adminCaptainViolationsDtoOutputSuggestionStepEnum_suspension7d;
  @BuiltValueEnumConst(wireName: r'termination')
  static const AdminCaptainViolationsDtoOutputSuggestionStepEnum termination =
      _$adminCaptainViolationsDtoOutputSuggestionStepEnum_termination;

  static Serializer<AdminCaptainViolationsDtoOutputSuggestionStepEnum>
  get serializer =>
      _$adminCaptainViolationsDtoOutputSuggestionStepEnumSerializer;

  const AdminCaptainViolationsDtoOutputSuggestionStepEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainViolationsDtoOutputSuggestionStepEnum>
  get values => _$adminCaptainViolationsDtoOutputSuggestionStepEnumValues;
  static AdminCaptainViolationsDtoOutputSuggestionStepEnum valueOf(
    String name,
  ) => _$adminCaptainViolationsDtoOutputSuggestionStepEnumValueOf(name);
}
