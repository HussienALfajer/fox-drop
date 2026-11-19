//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_documents_dto_output_documents_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_documents_dto_output.g.dart';

/// CaptainDocumentsDtoOutput
///
/// Properties:
/// * [documents]
@BuiltValue()
abstract class CaptainDocumentsDtoOutput
    implements
        Built<CaptainDocumentsDtoOutput, CaptainDocumentsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'documents')
  BuiltList<CaptainDocumentsDtoOutputDocumentsInner> get documents;

  CaptainDocumentsDtoOutput._();

  factory CaptainDocumentsDtoOutput([
    void updates(CaptainDocumentsDtoOutputBuilder b),
  ]) = _$CaptainDocumentsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainDocumentsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDocumentsDtoOutput> get serializer =>
      _$CaptainDocumentsDtoOutputSerializer();
}

class _$CaptainDocumentsDtoOutputSerializer
    implements PrimitiveSerializer<CaptainDocumentsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainDocumentsDtoOutput,
    _$CaptainDocumentsDtoOutput,
  ];

  @override
  final String wireName = r'CaptainDocumentsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDocumentsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainDocumentsDtoOutputDocumentsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDocumentsDtoOutput object, {
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
    required CaptainDocumentsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'documents':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainDocumentsDtoOutputDocumentsInner),
                    ]),
                  )
                  as BuiltList<CaptainDocumentsDtoOutputDocumentsInner>;
          result.documents.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDocumentsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDocumentsDtoOutputBuilder();
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
