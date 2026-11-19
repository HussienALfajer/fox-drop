//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_list_dto_output_captains_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_list_dto_output.g.dart';

/// AdminCaptainListDtoOutput
///
/// Properties:
/// * [captains] - By name.
@BuiltValue()
abstract class AdminCaptainListDtoOutput
    implements
        Built<AdminCaptainListDtoOutput, AdminCaptainListDtoOutputBuilder> {
  /// By name.
  @BuiltValueField(wireName: r'captains')
  BuiltList<AdminCaptainListDtoOutputCaptainsInner> get captains;

  AdminCaptainListDtoOutput._();

  factory AdminCaptainListDtoOutput([
    void updates(AdminCaptainListDtoOutputBuilder b),
  ]) = _$AdminCaptainListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainListDtoOutput> get serializer =>
      _$AdminCaptainListDtoOutputSerializer();
}

class _$AdminCaptainListDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainListDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainListDtoOutput,
    _$AdminCaptainListDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captains';
    yield serializers.serialize(
      object.captains,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainListDtoOutputCaptainsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainListDtoOutput object, {
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
    required AdminCaptainListDtoOutputBuilder result,
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
                      FullType(AdminCaptainListDtoOutputCaptainsInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainListDtoOutputCaptainsInner>;
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
  AdminCaptainListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainListDtoOutputBuilder();
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
