//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_rated_captains_dto_output_captains_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_rated_captains_dto_output.g.dart';

/// AdminRatedCaptainsDtoOutput
///
/// Properties:
/// * [captains] - The city’s captains, the best rated first and the unrated last.
@BuiltValue()
abstract class AdminRatedCaptainsDtoOutput
    implements
        Built<AdminRatedCaptainsDtoOutput, AdminRatedCaptainsDtoOutputBuilder> {
  /// The city’s captains, the best rated first and the unrated last.
  @BuiltValueField(wireName: r'captains')
  BuiltList<AdminRatedCaptainsDtoOutputCaptainsInner> get captains;

  AdminRatedCaptainsDtoOutput._();

  factory AdminRatedCaptainsDtoOutput([
    void updates(AdminRatedCaptainsDtoOutputBuilder b),
  ]) = _$AdminRatedCaptainsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRatedCaptainsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRatedCaptainsDtoOutput> get serializer =>
      _$AdminRatedCaptainsDtoOutputSerializer();
}

class _$AdminRatedCaptainsDtoOutputSerializer
    implements PrimitiveSerializer<AdminRatedCaptainsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRatedCaptainsDtoOutput,
    _$AdminRatedCaptainsDtoOutput,
  ];

  @override
  final String wireName = r'AdminRatedCaptainsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRatedCaptainsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captains';
    yield serializers.serialize(
      object.captains,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRatedCaptainsDtoOutputCaptainsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRatedCaptainsDtoOutput object, {
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
    required AdminRatedCaptainsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captains':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminRatedCaptainsDtoOutputCaptainsInner),
                    ]),
                  )
                  as BuiltList<AdminRatedCaptainsDtoOutputCaptainsInner>;
          result.captains.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRatedCaptainsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRatedCaptainsDtoOutputBuilder();
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
