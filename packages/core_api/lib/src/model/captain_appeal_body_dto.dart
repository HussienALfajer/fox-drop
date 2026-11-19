//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_appeal_body_dto.g.dart';

/// CaptainAppealBodyDto
///
/// Properties:
/// * [text] - Why the captain appeals.
/// * [photoUploadId] - One photo at most, from POST /v1/captain/uploads/report-photo once uploaded.
@BuiltValue()
abstract class CaptainAppealBodyDto
    implements Built<CaptainAppealBodyDto, CaptainAppealBodyDtoBuilder> {
  /// Why the captain appeals.
  @BuiltValueField(wireName: r'text')
  String get text;

  /// One photo at most, from POST /v1/captain/uploads/report-photo once uploaded.
  @BuiltValueField(wireName: r'photoUploadId')
  String? get photoUploadId;

  CaptainAppealBodyDto._();

  factory CaptainAppealBodyDto([void updates(CaptainAppealBodyDtoBuilder b)]) =
      _$CaptainAppealBodyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainAppealBodyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAppealBodyDto> get serializer =>
      _$CaptainAppealBodyDtoSerializer();
}

class _$CaptainAppealBodyDtoSerializer
    implements PrimitiveSerializer<CaptainAppealBodyDto> {
  @override
  final Iterable<Type> types = const [
    CaptainAppealBodyDto,
    _$CaptainAppealBodyDto,
  ];

  @override
  final String wireName = r'CaptainAppealBodyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAppealBodyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'photoUploadId';
    yield object.photoUploadId == null
        ? null
        : serializers.serialize(
            object.photoUploadId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainAppealBodyDto object, {
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
    required CaptainAppealBodyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'text':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.text = valueDes;
          break;
        case r'photoUploadId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.photoUploadId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainAppealBodyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAppealBodyDtoBuilder();
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
