//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_signed_out_dto_output.g.dart';

/// AdminCustomerSignedOutDtoOutput
///
/// Properties:
/// * [sessionsEnded] - The devices signed out.
@BuiltValue()
abstract class AdminCustomerSignedOutDtoOutput
    implements
        Built<
          AdminCustomerSignedOutDtoOutput,
          AdminCustomerSignedOutDtoOutputBuilder
        > {
  /// The devices signed out.
  @BuiltValueField(wireName: r'sessionsEnded')
  int get sessionsEnded;

  AdminCustomerSignedOutDtoOutput._();

  factory AdminCustomerSignedOutDtoOutput([
    void updates(AdminCustomerSignedOutDtoOutputBuilder b),
  ]) = _$AdminCustomerSignedOutDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerSignedOutDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerSignedOutDtoOutput> get serializer =>
      _$AdminCustomerSignedOutDtoOutputSerializer();
}

class _$AdminCustomerSignedOutDtoOutputSerializer
    implements PrimitiveSerializer<AdminCustomerSignedOutDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerSignedOutDtoOutput,
    _$AdminCustomerSignedOutDtoOutput,
  ];

  @override
  final String wireName = r'AdminCustomerSignedOutDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerSignedOutDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sessionsEnded';
    yield serializers.serialize(
      object.sessionsEnded,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerSignedOutDtoOutput object, {
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
    required AdminCustomerSignedOutDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sessionsEnded':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.sessionsEnded = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerSignedOutDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerSignedOutDtoOutputBuilder();
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
