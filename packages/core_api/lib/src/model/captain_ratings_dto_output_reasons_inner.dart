//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_ratings_dto_output_reasons_inner.g.dart';

/// CaptainRatingsDtoOutputReasonsInner
///
/// Properties:
/// * [code]
/// * [label]
/// * [count]
@BuiltValue()
abstract class CaptainRatingsDtoOutputReasonsInner
    implements
        Built<
          CaptainRatingsDtoOutputReasonsInner,
          CaptainRatingsDtoOutputReasonsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'count')
  int get count;

  CaptainRatingsDtoOutputReasonsInner._();

  factory CaptainRatingsDtoOutputReasonsInner([
    void updates(CaptainRatingsDtoOutputReasonsInnerBuilder b),
  ]) = _$CaptainRatingsDtoOutputReasonsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainRatingsDtoOutputReasonsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainRatingsDtoOutputReasonsInner> get serializer =>
      _$CaptainRatingsDtoOutputReasonsInnerSerializer();
}

class _$CaptainRatingsDtoOutputReasonsInnerSerializer
    implements PrimitiveSerializer<CaptainRatingsDtoOutputReasonsInner> {
  @override
  final Iterable<Type> types = const [
    CaptainRatingsDtoOutputReasonsInner,
    _$CaptainRatingsDtoOutputReasonsInner,
  ];

  @override
  final String wireName = r'CaptainRatingsDtoOutputReasonsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainRatingsDtoOutputReasonsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainRatingsDtoOutputReasonsInner object, {
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
    required CaptainRatingsDtoOutputReasonsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainRatingsDtoOutputReasonsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainRatingsDtoOutputReasonsInnerBuilder();
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
