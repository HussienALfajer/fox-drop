//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_documents_dto_output_documents_inner_rejection.g.dart';

/// CaptainDocumentsDtoOutputDocumentsInnerRejection
///
/// Properties:
/// * [reason]
/// * [at]
@BuiltValue()
abstract class CaptainDocumentsDtoOutputDocumentsInnerRejection
    implements
        Built<
          CaptainDocumentsDtoOutputDocumentsInnerRejection,
          CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder
        > {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainDocumentsDtoOutputDocumentsInnerRejection._();

  factory CaptainDocumentsDtoOutputDocumentsInnerRejection([
    void updates(CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder b),
  ]) = _$CaptainDocumentsDtoOutputDocumentsInnerRejection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDocumentsDtoOutputDocumentsInnerRejection>
  get serializer =>
      _$CaptainDocumentsDtoOutputDocumentsInnerRejectionSerializer();
}

class _$CaptainDocumentsDtoOutputDocumentsInnerRejectionSerializer
    implements
        PrimitiveSerializer<CaptainDocumentsDtoOutputDocumentsInnerRejection> {
  @override
  final Iterable<Type> types = const [
    CaptainDocumentsDtoOutputDocumentsInnerRejection,
    _$CaptainDocumentsDtoOutputDocumentsInnerRejection,
  ];

  @override
  final String wireName = r'CaptainDocumentsDtoOutputDocumentsInnerRejection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDocumentsDtoOutputDocumentsInnerRejection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDocumentsDtoOutputDocumentsInnerRejection object, {
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
    required CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder result,
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
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDocumentsDtoOutputDocumentsInnerRejection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder();
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
