//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_change_request_row_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_requests_dto_output.g.dart';

/// AdminChangeRequestsDtoOutput
///
/// Properties:
/// * [requests] - Oldest first (AP §9.6.7).
@BuiltValue()
abstract class AdminChangeRequestsDtoOutput
    implements
        Built<
          AdminChangeRequestsDtoOutput,
          AdminChangeRequestsDtoOutputBuilder
        > {
  /// Oldest first (AP §9.6.7).
  @BuiltValueField(wireName: r'requests')
  BuiltList<AdminChangeRequestRowOutput> get requests;

  AdminChangeRequestsDtoOutput._();

  factory AdminChangeRequestsDtoOutput([
    void updates(AdminChangeRequestsDtoOutputBuilder b),
  ]) = _$AdminChangeRequestsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeRequestsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeRequestsDtoOutput> get serializer =>
      _$AdminChangeRequestsDtoOutputSerializer();
}

class _$AdminChangeRequestsDtoOutputSerializer
    implements PrimitiveSerializer<AdminChangeRequestsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminChangeRequestsDtoOutput,
    _$AdminChangeRequestsDtoOutput,
  ];

  @override
  final String wireName = r'AdminChangeRequestsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeRequestsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'requests';
    yield serializers.serialize(
      object.requests,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminChangeRequestRowOutput),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeRequestsDtoOutput object, {
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
    required AdminChangeRequestsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'requests':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminChangeRequestRowOutput),
                    ]),
                  )
                  as BuiltList<AdminChangeRequestRowOutput>;
          result.requests.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChangeRequestsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeRequestsDtoOutputBuilder();
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
