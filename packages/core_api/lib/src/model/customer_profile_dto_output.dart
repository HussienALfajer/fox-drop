//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_profile_dto_output_profile.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_profile_dto_output.g.dart';

/// CustomerProfileDtoOutput
///
/// Properties:
/// * [completed] - false until «أكمل بياناتك» is sent (CU §5.3).
/// * [profile]
@BuiltValue()
abstract class CustomerProfileDtoOutput
    implements
        Built<CustomerProfileDtoOutput, CustomerProfileDtoOutputBuilder> {
  /// false until «أكمل بياناتك» is sent (CU §5.3).
  @BuiltValueField(wireName: r'completed')
  bool get completed;

  @BuiltValueField(wireName: r'profile')
  CustomerProfileDtoOutputProfile? get profile;

  CustomerProfileDtoOutput._();

  factory CustomerProfileDtoOutput([
    void updates(CustomerProfileDtoOutputBuilder b),
  ]) = _$CustomerProfileDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerProfileDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerProfileDtoOutput> get serializer =>
      _$CustomerProfileDtoOutputSerializer();
}

class _$CustomerProfileDtoOutputSerializer
    implements PrimitiveSerializer<CustomerProfileDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerProfileDtoOutput,
    _$CustomerProfileDtoOutput,
  ];

  @override
  final String wireName = r'CustomerProfileDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerProfileDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'completed';
    yield serializers.serialize(
      object.completed,
      specifiedType: const FullType(bool),
    );
    yield r'profile';
    yield object.profile == null
        ? null
        : serializers.serialize(
            object.profile,
            specifiedType: const FullType.nullable(
              CustomerProfileDtoOutputProfile,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerProfileDtoOutput object, {
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
    required CustomerProfileDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'completed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.completed = valueDes;
          break;
        case r'profile':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerProfileDtoOutputProfile,
                    ),
                  )
                  as CustomerProfileDtoOutputProfile?;
          if (valueDes == null) continue;
          result.profile.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerProfileDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerProfileDtoOutputBuilder();
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
