//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_lost_demand_dto_output_suggestions_inner.dart';
import 'package:core_api/src/model/admin_lost_demand_dto_output_searches_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_lost_demand_dto_output.g.dart';

/// AdminLostDemandDtoOutput
///
/// Properties:
/// * [since] - 30 days back.
/// * [searches] - «بحث بلا نتائج»: the 100 missed most, most first.
/// * [suggestions] - «مطاعم مقترحة»: the 100 latest.
@BuiltValue()
abstract class AdminLostDemandDtoOutput
    implements
        Built<AdminLostDemandDtoOutput, AdminLostDemandDtoOutputBuilder> {
  /// 30 days back.
  @BuiltValueField(wireName: r'since')
  DateTime get since;

  /// «بحث بلا نتائج»: the 100 missed most, most first.
  @BuiltValueField(wireName: r'searches')
  BuiltList<AdminLostDemandDtoOutputSearchesInner> get searches;

  /// «مطاعم مقترحة»: the 100 latest.
  @BuiltValueField(wireName: r'suggestions')
  BuiltList<AdminLostDemandDtoOutputSuggestionsInner> get suggestions;

  AdminLostDemandDtoOutput._();

  factory AdminLostDemandDtoOutput([
    void updates(AdminLostDemandDtoOutputBuilder b),
  ]) = _$AdminLostDemandDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLostDemandDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLostDemandDtoOutput> get serializer =>
      _$AdminLostDemandDtoOutputSerializer();
}

class _$AdminLostDemandDtoOutputSerializer
    implements PrimitiveSerializer<AdminLostDemandDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminLostDemandDtoOutput,
    _$AdminLostDemandDtoOutput,
  ];

  @override
  final String wireName = r'AdminLostDemandDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLostDemandDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'since';
    yield serializers.serialize(
      object.since,
      specifiedType: const FullType(DateTime),
    );
    yield r'searches';
    yield serializers.serialize(
      object.searches,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminLostDemandDtoOutputSearchesInner),
      ]),
    );
    yield r'suggestions';
    yield serializers.serialize(
      object.suggestions,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminLostDemandDtoOutputSuggestionsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLostDemandDtoOutput object, {
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
    required AdminLostDemandDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'since':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.since = valueDes;
          break;
        case r'searches':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminLostDemandDtoOutputSearchesInner),
                    ]),
                  )
                  as BuiltList<AdminLostDemandDtoOutputSearchesInner>;
          result.searches.replace(valueDes);
          break;
        case r'suggestions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminLostDemandDtoOutputSuggestionsInner),
                    ]),
                  )
                  as BuiltList<AdminLostDemandDtoOutputSuggestionsInner>;
          result.suggestions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminLostDemandDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLostDemandDtoOutputBuilder();
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
