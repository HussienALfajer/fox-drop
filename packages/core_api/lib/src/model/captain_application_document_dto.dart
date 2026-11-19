//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_document_dto.g.dart';

/// CaptainApplicationDocumentDto
///
/// Properties:
/// * [uploadIds] - From POST /v1/captain/application/documents/upload, once uploaded.
/// * [number] - The national ID’s number.
/// * [issueDate] - A calendar day, YYYY-MM-DD.
@BuiltValue()
abstract class CaptainApplicationDocumentDto
    implements
        Built<
          CaptainApplicationDocumentDto,
          CaptainApplicationDocumentDtoBuilder
        > {
  /// From POST /v1/captain/application/documents/upload, once uploaded.
  @BuiltValueField(wireName: r'uploadIds')
  BuiltList<String> get uploadIds;

  /// The national ID’s number.
  @BuiltValueField(wireName: r'number')
  String? get number;

  /// A calendar day, YYYY-MM-DD.
  @BuiltValueField(wireName: r'issueDate')
  Date? get issueDate;

  CaptainApplicationDocumentDto._();

  factory CaptainApplicationDocumentDto([
    void updates(CaptainApplicationDocumentDtoBuilder b),
  ]) = _$CaptainApplicationDocumentDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainApplicationDocumentDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationDocumentDto> get serializer =>
      _$CaptainApplicationDocumentDtoSerializer();
}

class _$CaptainApplicationDocumentDtoSerializer
    implements PrimitiveSerializer<CaptainApplicationDocumentDto> {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationDocumentDto,
    _$CaptainApplicationDocumentDto,
  ];

  @override
  final String wireName = r'CaptainApplicationDocumentDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationDocumentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'uploadIds';
    yield serializers.serialize(
      object.uploadIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.number != null) {
      yield r'number';
      yield serializers.serialize(
        object.number,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.issueDate != null) {
      yield r'issueDate';
      yield serializers.serialize(
        object.issueDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationDocumentDto object, {
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
    required CaptainApplicationDocumentDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'uploadIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.uploadIds.replace(valueDes);
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.number = valueDes;
          break;
        case r'issueDate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(Date),
                  )
                  as Date?;
          if (valueDes == null) continue;
          result.issueDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainApplicationDocumentDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainApplicationDocumentDtoBuilder();
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
