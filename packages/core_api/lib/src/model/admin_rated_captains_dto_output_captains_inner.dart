//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_rated_captains_dto_output_captains_inner.g.dart';

/// AdminRatedCaptainsDtoOutputCaptainsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [count]
/// * [average]
@BuiltValue()
abstract class AdminRatedCaptainsDtoOutputCaptainsInner
    implements
        Built<
          AdminRatedCaptainsDtoOutputCaptainsInner,
          AdminRatedCaptainsDtoOutputCaptainsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'average')
  num? get average;

  AdminRatedCaptainsDtoOutputCaptainsInner._();

  factory AdminRatedCaptainsDtoOutputCaptainsInner([
    void updates(AdminRatedCaptainsDtoOutputCaptainsInnerBuilder b),
  ]) = _$AdminRatedCaptainsDtoOutputCaptainsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRatedCaptainsDtoOutputCaptainsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRatedCaptainsDtoOutputCaptainsInner> get serializer =>
      _$AdminRatedCaptainsDtoOutputCaptainsInnerSerializer();
}

class _$AdminRatedCaptainsDtoOutputCaptainsInnerSerializer
    implements PrimitiveSerializer<AdminRatedCaptainsDtoOutputCaptainsInner> {
  @override
  final Iterable<Type> types = const [
    AdminRatedCaptainsDtoOutputCaptainsInner,
    _$AdminRatedCaptainsDtoOutputCaptainsInner,
  ];

  @override
  final String wireName = r'AdminRatedCaptainsDtoOutputCaptainsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRatedCaptainsDtoOutputCaptainsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'average';
    yield object.average == null
        ? null
        : serializers.serialize(
            object.average,
            specifiedType: const FullType.nullable(num),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRatedCaptainsDtoOutputCaptainsInner object, {
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
    required AdminRatedCaptainsDtoOutputCaptainsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
          break;
        case r'average':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.average = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRatedCaptainsDtoOutputCaptainsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRatedCaptainsDtoOutputCaptainsInnerBuilder();
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
