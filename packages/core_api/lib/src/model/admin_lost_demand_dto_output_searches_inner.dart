//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_lost_demand_dto_output_searches_inner.g.dart';

/// AdminLostDemandDtoOutputSearchesInner
///
/// Properties:
/// * [query] - As it was typed last.
/// * [count] - Searches typed alike that found nothing.
/// * [lastAt]
@BuiltValue()
abstract class AdminLostDemandDtoOutputSearchesInner
    implements
        Built<
          AdminLostDemandDtoOutputSearchesInner,
          AdminLostDemandDtoOutputSearchesInnerBuilder
        > {
  /// As it was typed last.
  @BuiltValueField(wireName: r'query')
  String get query;

  /// Searches typed alike that found nothing.
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'lastAt')
  DateTime get lastAt;

  AdminLostDemandDtoOutputSearchesInner._();

  factory AdminLostDemandDtoOutputSearchesInner([
    void updates(AdminLostDemandDtoOutputSearchesInnerBuilder b),
  ]) = _$AdminLostDemandDtoOutputSearchesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLostDemandDtoOutputSearchesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLostDemandDtoOutputSearchesInner> get serializer =>
      _$AdminLostDemandDtoOutputSearchesInnerSerializer();
}

class _$AdminLostDemandDtoOutputSearchesInnerSerializer
    implements PrimitiveSerializer<AdminLostDemandDtoOutputSearchesInner> {
  @override
  final Iterable<Type> types = const [
    AdminLostDemandDtoOutputSearchesInner,
    _$AdminLostDemandDtoOutputSearchesInner,
  ];

  @override
  final String wireName = r'AdminLostDemandDtoOutputSearchesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLostDemandDtoOutputSearchesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'query';
    yield serializers.serialize(
      object.query,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'lastAt';
    yield serializers.serialize(
      object.lastAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLostDemandDtoOutputSearchesInner object, {
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
    required AdminLostDemandDtoOutputSearchesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'query':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.query = valueDes;
          break;
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
          break;
        case r'lastAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.lastAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminLostDemandDtoOutputSearchesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLostDemandDtoOutputSearchesInnerBuilder();
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
