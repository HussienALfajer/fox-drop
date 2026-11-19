//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_applications_dto_output_applications_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_applications_dto_output.g.dart';

/// AdminCaptainApplicationsDtoOutput
///
/// Properties:
/// * [counts] - The applications of each stage; a stage without any is left out.
/// * [applications]
@BuiltValue()
abstract class AdminCaptainApplicationsDtoOutput
    implements
        Built<
          AdminCaptainApplicationsDtoOutput,
          AdminCaptainApplicationsDtoOutputBuilder
        > {
  /// The applications of each stage; a stage without any is left out.
  @BuiltValueField(wireName: r'counts')
  BuiltMap<String, int> get counts;

  @BuiltValueField(wireName: r'applications')
  BuiltList<AdminCaptainApplicationsDtoOutputApplicationsInner>
  get applications;

  AdminCaptainApplicationsDtoOutput._();

  factory AdminCaptainApplicationsDtoOutput([
    void updates(AdminCaptainApplicationsDtoOutputBuilder b),
  ]) = _$AdminCaptainApplicationsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationsDtoOutput> get serializer =>
      _$AdminCaptainApplicationsDtoOutputSerializer();
}

class _$AdminCaptainApplicationsDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationsDtoOutput,
    _$AdminCaptainApplicationsDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'counts';
    yield serializers.serialize(
      object.counts,
      specifiedType: const FullType(BuiltMap, [
        FullType(String),
        FullType(int),
      ]),
    );
    yield r'applications';
    yield serializers.serialize(
      object.applications,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainApplicationsDtoOutputApplicationsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationsDtoOutput object, {
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
    required AdminCaptainApplicationsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'counts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltMap, [
                      FullType(String),
                      FullType(int),
                    ]),
                  )
                  as BuiltMap<String, int>;
          result.counts.replace(valueDes);
          break;
        case r'applications':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCaptainApplicationsDtoOutputApplicationsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainApplicationsDtoOutputApplicationsInner
                  >;
          result.applications.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationsDtoOutputBuilder();
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
