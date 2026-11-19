//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_violations_dto_output_types_regular_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_violations_dto_output_types.g.dart';

/// AdminCaptainViolationsDtoOutputTypes
///
/// Properties:
/// * [regular]
/// * [severe]
@BuiltValue()
abstract class AdminCaptainViolationsDtoOutputTypes
    implements
        Built<
          AdminCaptainViolationsDtoOutputTypes,
          AdminCaptainViolationsDtoOutputTypesBuilder
        > {
  @BuiltValueField(wireName: r'regular')
  BuiltList<AdminCaptainViolationsDtoOutputTypesRegularInner> get regular;

  @BuiltValueField(wireName: r'severe')
  BuiltList<AdminCaptainViolationsDtoOutputTypesRegularInner> get severe;

  AdminCaptainViolationsDtoOutputTypes._();

  factory AdminCaptainViolationsDtoOutputTypes([
    void updates(AdminCaptainViolationsDtoOutputTypesBuilder b),
  ]) = _$AdminCaptainViolationsDtoOutputTypes;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainViolationsDtoOutputTypesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainViolationsDtoOutputTypes> get serializer =>
      _$AdminCaptainViolationsDtoOutputTypesSerializer();
}

class _$AdminCaptainViolationsDtoOutputTypesSerializer
    implements PrimitiveSerializer<AdminCaptainViolationsDtoOutputTypes> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainViolationsDtoOutputTypes,
    _$AdminCaptainViolationsDtoOutputTypes,
  ];

  @override
  final String wireName = r'AdminCaptainViolationsDtoOutputTypes';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputTypes object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'regular';
    yield serializers.serialize(
      object.regular,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainViolationsDtoOutputTypesRegularInner),
      ]),
    );
    yield r'severe';
    yield serializers.serialize(
      object.severe,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainViolationsDtoOutputTypesRegularInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputTypes object, {
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
    required AdminCaptainViolationsDtoOutputTypesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'regular':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCaptainViolationsDtoOutputTypesRegularInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainViolationsDtoOutputTypesRegularInner
                  >;
          result.regular.replace(valueDes);
          break;
        case r'severe':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCaptainViolationsDtoOutputTypesRegularInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainViolationsDtoOutputTypesRegularInner
                  >;
          result.severe.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainViolationsDtoOutputTypes deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainViolationsDtoOutputTypesBuilder();
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
