//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_desk_captains_dto_output_captains_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_desk_captains_dto_output.g.dart';

/// AdminDeskCaptainsDtoOutput
///
/// Properties:
/// * [captains]
@BuiltValue()
abstract class AdminDeskCaptainsDtoOutput
    implements
        Built<AdminDeskCaptainsDtoOutput, AdminDeskCaptainsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'captains')
  BuiltList<AdminDeskCaptainsDtoOutputCaptainsInner> get captains;

  AdminDeskCaptainsDtoOutput._();

  factory AdminDeskCaptainsDtoOutput([
    void updates(AdminDeskCaptainsDtoOutputBuilder b),
  ]) = _$AdminDeskCaptainsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeskCaptainsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeskCaptainsDtoOutput> get serializer =>
      _$AdminDeskCaptainsDtoOutputSerializer();
}

class _$AdminDeskCaptainsDtoOutputSerializer
    implements PrimitiveSerializer<AdminDeskCaptainsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDeskCaptainsDtoOutput,
    _$AdminDeskCaptainsDtoOutput,
  ];

  @override
  final String wireName = r'AdminDeskCaptainsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeskCaptainsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captains';
    yield serializers.serialize(
      object.captains,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDeskCaptainsDtoOutputCaptainsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeskCaptainsDtoOutput object, {
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
    required AdminDeskCaptainsDtoOutputBuilder result,
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
                      FullType(AdminDeskCaptainsDtoOutputCaptainsInner),
                    ]),
                  )
                  as BuiltList<AdminDeskCaptainsDtoOutputCaptainsInner>;
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
  AdminDeskCaptainsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeskCaptainsDtoOutputBuilder();
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
