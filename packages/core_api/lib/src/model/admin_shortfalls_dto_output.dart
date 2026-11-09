//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_shortfalls_dto_output_shortfalls_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_shortfalls_dto_output.g.dart';

/// AdminShortfallsDtoOutput
///
/// Properties:
/// * [shortfalls] - «نقص في التحصيل» (AP §8.6), newest first; all open until resolution is built.
@BuiltValue()
abstract class AdminShortfallsDtoOutput
    implements
        Built<AdminShortfallsDtoOutput, AdminShortfallsDtoOutputBuilder> {
  /// «نقص في التحصيل» (AP §8.6), newest first; all open until resolution is built.
  @BuiltValueField(wireName: r'shortfalls')
  BuiltList<AdminShortfallsDtoOutputShortfallsInner> get shortfalls;

  AdminShortfallsDtoOutput._();

  factory AdminShortfallsDtoOutput([
    void updates(AdminShortfallsDtoOutputBuilder b),
  ]) = _$AdminShortfallsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminShortfallsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminShortfallsDtoOutput> get serializer =>
      _$AdminShortfallsDtoOutputSerializer();
}

class _$AdminShortfallsDtoOutputSerializer
    implements PrimitiveSerializer<AdminShortfallsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminShortfallsDtoOutput,
    _$AdminShortfallsDtoOutput,
  ];

  @override
  final String wireName = r'AdminShortfallsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminShortfallsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'shortfalls';
    yield serializers.serialize(
      object.shortfalls,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminShortfallsDtoOutputShortfallsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminShortfallsDtoOutput object, {
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
    required AdminShortfallsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'shortfalls':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminShortfallsDtoOutputShortfallsInner),
                    ]),
                  )
                  as BuiltList<AdminShortfallsDtoOutputShortfallsInner>;
          result.shortfalls.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminShortfallsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminShortfallsDtoOutputBuilder();
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
