//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_documents_dto_output_documents_inner_valid.g.dart';

/// The one in force, valid until it expires.
///
/// Properties:
/// * [issueDate]
/// * [expiresOn]
/// * [uploadedAt]
@BuiltValue()
abstract class CaptainDocumentsDtoOutputDocumentsInnerValid
    implements
        Built<
          CaptainDocumentsDtoOutputDocumentsInnerValid,
          CaptainDocumentsDtoOutputDocumentsInnerValidBuilder
        > {
  @BuiltValueField(wireName: r'issueDate')
  Date? get issueDate;

  @BuiltValueField(wireName: r'expiresOn')
  Date? get expiresOn;

  @BuiltValueField(wireName: r'uploadedAt')
  DateTime get uploadedAt;

  CaptainDocumentsDtoOutputDocumentsInnerValid._();

  factory CaptainDocumentsDtoOutputDocumentsInnerValid([
    void updates(CaptainDocumentsDtoOutputDocumentsInnerValidBuilder b),
  ]) = _$CaptainDocumentsDtoOutputDocumentsInnerValid;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainDocumentsDtoOutputDocumentsInnerValidBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDocumentsDtoOutputDocumentsInnerValid>
  get serializer => _$CaptainDocumentsDtoOutputDocumentsInnerValidSerializer();
}

class _$CaptainDocumentsDtoOutputDocumentsInnerValidSerializer
    implements
        PrimitiveSerializer<CaptainDocumentsDtoOutputDocumentsInnerValid> {
  @override
  final Iterable<Type> types = const [
    CaptainDocumentsDtoOutputDocumentsInnerValid,
    _$CaptainDocumentsDtoOutputDocumentsInnerValid,
  ];

  @override
  final String wireName = r'CaptainDocumentsDtoOutputDocumentsInnerValid';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDocumentsDtoOutputDocumentsInnerValid object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'issueDate';
    yield object.issueDate == null
        ? null
        : serializers.serialize(
            object.issueDate,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'expiresOn';
    yield object.expiresOn == null
        ? null
        : serializers.serialize(
            object.expiresOn,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'uploadedAt';
    yield serializers.serialize(
      object.uploadedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDocumentsDtoOutputDocumentsInnerValid object, {
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
    required CaptainDocumentsDtoOutputDocumentsInnerValidBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'expiresOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(Date),
                  )
                  as Date?;
          if (valueDes == null) continue;
          result.expiresOn = valueDes;
          break;
        case r'uploadedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.uploadedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDocumentsDtoOutputDocumentsInnerValid deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDocumentsDtoOutputDocumentsInnerValidBuilder();
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
