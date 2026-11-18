//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_lost_demand_dto_output_suggestions_inner.g.dart';

/// AdminLostDemandDtoOutputSuggestionsInner
///
/// Properties:
/// * [id]
/// * [restaurantName]
/// * [note]
/// * [query] - The search the form followed.
/// * [at]
@BuiltValue()
abstract class AdminLostDemandDtoOutputSuggestionsInner
    implements
        Built<
          AdminLostDemandDtoOutputSuggestionsInner,
          AdminLostDemandDtoOutputSuggestionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  @BuiltValueField(wireName: r'note')
  String? get note;

  /// The search the form followed.
  @BuiltValueField(wireName: r'query')
  String? get query;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  AdminLostDemandDtoOutputSuggestionsInner._();

  factory AdminLostDemandDtoOutputSuggestionsInner([
    void updates(AdminLostDemandDtoOutputSuggestionsInnerBuilder b),
  ]) = _$AdminLostDemandDtoOutputSuggestionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLostDemandDtoOutputSuggestionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLostDemandDtoOutputSuggestionsInner> get serializer =>
      _$AdminLostDemandDtoOutputSuggestionsInnerSerializer();
}

class _$AdminLostDemandDtoOutputSuggestionsInnerSerializer
    implements PrimitiveSerializer<AdminLostDemandDtoOutputSuggestionsInner> {
  @override
  final Iterable<Type> types = const [
    AdminLostDemandDtoOutputSuggestionsInner,
    _$AdminLostDemandDtoOutputSuggestionsInner,
  ];

  @override
  final String wireName = r'AdminLostDemandDtoOutputSuggestionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLostDemandDtoOutputSuggestionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'query';
    yield object.query == null
        ? null
        : serializers.serialize(
            object.query,
            specifiedType: const FullType.nullable(String),
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
    AdminLostDemandDtoOutputSuggestionsInner object, {
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
    required AdminLostDemandDtoOutputSuggestionsInnerBuilder result,
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
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'query':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.query = valueDes;
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
  AdminLostDemandDtoOutputSuggestionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLostDemandDtoOutputSuggestionsInnerBuilder();
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
