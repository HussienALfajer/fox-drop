//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_violations_dto_output_types.dart';
import 'package:core_api/src/model/admin_captain_violations_dto_output_violations_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_violations_dto_output_suspensions_inner.dart';
import 'package:core_api/src/model/admin_captain_violations_dto_output_suggestion.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_violations_dto_output.g.dart';

/// AdminCaptainViolationsDtoOutput
///
/// Properties:
/// * [violations] - Newest first.
/// * [suggestion]
/// * [types]
/// * [suspensions] - The latest 50 status changes, newest first.
@BuiltValue()
abstract class AdminCaptainViolationsDtoOutput
    implements
        Built<
          AdminCaptainViolationsDtoOutput,
          AdminCaptainViolationsDtoOutputBuilder
        > {
  /// Newest first.
  @BuiltValueField(wireName: r'violations')
  BuiltList<AdminCaptainViolationsDtoOutputViolationsInner> get violations;

  @BuiltValueField(wireName: r'suggestion')
  AdminCaptainViolationsDtoOutputSuggestion get suggestion;

  @BuiltValueField(wireName: r'types')
  AdminCaptainViolationsDtoOutputTypes get types;

  /// The latest 50 status changes, newest first.
  @BuiltValueField(wireName: r'suspensions')
  BuiltList<AdminCaptainViolationsDtoOutputSuspensionsInner> get suspensions;

  AdminCaptainViolationsDtoOutput._();

  factory AdminCaptainViolationsDtoOutput([
    void updates(AdminCaptainViolationsDtoOutputBuilder b),
  ]) = _$AdminCaptainViolationsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainViolationsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainViolationsDtoOutput> get serializer =>
      _$AdminCaptainViolationsDtoOutputSerializer();
}

class _$AdminCaptainViolationsDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainViolationsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainViolationsDtoOutput,
    _$AdminCaptainViolationsDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainViolationsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainViolationsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'violations';
    yield serializers.serialize(
      object.violations,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainViolationsDtoOutputViolationsInner),
      ]),
    );
    yield r'suggestion';
    yield serializers.serialize(
      object.suggestion,
      specifiedType: const FullType(AdminCaptainViolationsDtoOutputSuggestion),
    );
    yield r'types';
    yield serializers.serialize(
      object.types,
      specifiedType: const FullType(AdminCaptainViolationsDtoOutputTypes),
    );
    yield r'suspensions';
    yield serializers.serialize(
      object.suspensions,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainViolationsDtoOutputSuspensionsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutput object, {
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
    required AdminCaptainViolationsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'violations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCaptainViolationsDtoOutputViolationsInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainViolationsDtoOutputViolationsInner>;
          result.violations.replace(valueDes);
          break;
        case r'suggestion':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainViolationsDtoOutputSuggestion,
                    ),
                  )
                  as AdminCaptainViolationsDtoOutputSuggestion;
          result.suggestion.replace(valueDes);
          break;
        case r'types':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainViolationsDtoOutputTypes,
                    ),
                  )
                  as AdminCaptainViolationsDtoOutputTypes;
          result.types.replace(valueDes);
          break;
        case r'suspensions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCaptainViolationsDtoOutputSuspensionsInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainViolationsDtoOutputSuspensionsInner>;
          result.suspensions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainViolationsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainViolationsDtoOutputBuilder();
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
