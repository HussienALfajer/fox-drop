//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_profile_dto_output_suspension.g.dart';

/// Running now; null otherwise.
///
/// Properties:
/// * [reason]
/// * [until]
@BuiltValue()
abstract class AdminCaptainProfileDtoOutputSuspension
    implements
        Built<
          AdminCaptainProfileDtoOutputSuspension,
          AdminCaptainProfileDtoOutputSuspensionBuilder
        > {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  AdminCaptainProfileDtoOutputSuspension._();

  factory AdminCaptainProfileDtoOutputSuspension([
    void updates(AdminCaptainProfileDtoOutputSuspensionBuilder b),
  ]) = _$AdminCaptainProfileDtoOutputSuspension;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainProfileDtoOutputSuspensionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainProfileDtoOutputSuspension> get serializer =>
      _$AdminCaptainProfileDtoOutputSuspensionSerializer();
}

class _$AdminCaptainProfileDtoOutputSuspensionSerializer
    implements PrimitiveSerializer<AdminCaptainProfileDtoOutputSuspension> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainProfileDtoOutputSuspension,
    _$AdminCaptainProfileDtoOutputSuspension,
  ];

  @override
  final String wireName = r'AdminCaptainProfileDtoOutputSuspension';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainProfileDtoOutputSuspension object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutputSuspension object, {
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
    required AdminCaptainProfileDtoOutputSuspensionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainProfileDtoOutputSuspension deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainProfileDtoOutputSuspensionBuilder();
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
