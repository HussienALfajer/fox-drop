//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_terminate_dto.g.dart';

/// AdminCaptainApplicationTerminateDto
///
/// Properties:
/// * [reason]
@BuiltValue()
abstract class AdminCaptainApplicationTerminateDto
    implements
        Built<
          AdminCaptainApplicationTerminateDto,
          AdminCaptainApplicationTerminateDtoBuilder
        > {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminCaptainApplicationTerminateDto._();

  factory AdminCaptainApplicationTerminateDto([
    void updates(AdminCaptainApplicationTerminateDtoBuilder b),
  ]) = _$AdminCaptainApplicationTerminateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationTerminateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationTerminateDto> get serializer =>
      _$AdminCaptainApplicationTerminateDtoSerializer();
}

class _$AdminCaptainApplicationTerminateDtoSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationTerminateDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationTerminateDto,
    _$AdminCaptainApplicationTerminateDto,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationTerminateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationTerminateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationTerminateDto object, {
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
    required AdminCaptainApplicationTerminateDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationTerminateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationTerminateDtoBuilder();
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
