//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_reject_dto.g.dart';

/// AdminCaptainApplicationRejectDto
///
/// Properties:
/// * [reason] - Sent to the applicant (CA §5.4).
@BuiltValue()
abstract class AdminCaptainApplicationRejectDto
    implements
        Built<
          AdminCaptainApplicationRejectDto,
          AdminCaptainApplicationRejectDtoBuilder
        > {
  /// Sent to the applicant (CA §5.4).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminCaptainApplicationRejectDto._();

  factory AdminCaptainApplicationRejectDto([
    void updates(AdminCaptainApplicationRejectDtoBuilder b),
  ]) = _$AdminCaptainApplicationRejectDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationRejectDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationRejectDto> get serializer =>
      _$AdminCaptainApplicationRejectDtoSerializer();
}

class _$AdminCaptainApplicationRejectDtoSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationRejectDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationRejectDto,
    _$AdminCaptainApplicationRejectDto,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationRejectDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationRejectDto object, {
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
    AdminCaptainApplicationRejectDto object, {
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
    required AdminCaptainApplicationRejectDtoBuilder result,
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
  AdminCaptainApplicationRejectDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationRejectDtoBuilder();
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
