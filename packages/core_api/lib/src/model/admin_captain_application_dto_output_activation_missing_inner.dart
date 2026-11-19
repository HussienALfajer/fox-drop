//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'dart:core';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'admin_captain_application_dto_output_activation_missing_inner.g.dart';

/// AdminCaptainApplicationDtoOutputActivationMissingInner
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputActivationMissingInner
    implements
        Built<
          AdminCaptainApplicationDtoOutputActivationMissingInner,
          AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder
        > {
  /// Any Of [String]
  AnyOf get anyOf;

  AdminCaptainApplicationDtoOutputActivationMissingInner._();

  factory AdminCaptainApplicationDtoOutputActivationMissingInner([
    void updates(
      AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder b,
    ),
  ]) = _$AdminCaptainApplicationDtoOutputActivationMissingInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputActivationMissingInner>
  get serializer =>
      _$AdminCaptainApplicationDtoOutputActivationMissingInnerSerializer();
}

class _$AdminCaptainApplicationDtoOutputActivationMissingInnerSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainApplicationDtoOutputActivationMissingInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputActivationMissingInner,
    _$AdminCaptainApplicationDtoOutputActivationMissingInner,
  ];

  @override
  final String wireName =
      r'AdminCaptainApplicationDtoOutputActivationMissingInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationMissingInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationMissingInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(
      anyOf,
      specifiedType: FullType(
        AnyOf,
        anyOf.types.map((type) => FullType(type)).toList(),
      ),
    )!;
  }

  @override
  AdminCaptainApplicationDtoOutputActivationMissingInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [
      FullType(String),
      FullType(AnyOf1Enum),
    ]);
    anyOfDataSrc = serialized;
    result.anyOf =
        serializers.deserialize(anyOfDataSrc, specifiedType: targetType)
            as AnyOf;
    return result.build();
  }
}
