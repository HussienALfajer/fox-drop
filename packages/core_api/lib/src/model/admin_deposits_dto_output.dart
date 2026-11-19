//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_deposits_dto_output_applications_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_deposits_dto_output.g.dart';

/// AdminDepositsDtoOutput
///
/// Properties:
/// * [applications]
@BuiltValue()
abstract class AdminDepositsDtoOutput
    implements Built<AdminDepositsDtoOutput, AdminDepositsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'applications')
  BuiltList<AdminDepositsDtoOutputApplicationsInner> get applications;

  AdminDepositsDtoOutput._();

  factory AdminDepositsDtoOutput([
    void updates(AdminDepositsDtoOutputBuilder b),
  ]) = _$AdminDepositsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDepositsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDepositsDtoOutput> get serializer =>
      _$AdminDepositsDtoOutputSerializer();
}

class _$AdminDepositsDtoOutputSerializer
    implements PrimitiveSerializer<AdminDepositsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDepositsDtoOutput,
    _$AdminDepositsDtoOutput,
  ];

  @override
  final String wireName = r'AdminDepositsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDepositsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'applications';
    yield serializers.serialize(
      object.applications,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDepositsDtoOutputApplicationsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDepositsDtoOutput object, {
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
    required AdminDepositsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'applications':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDepositsDtoOutputApplicationsInner),
                    ]),
                  )
                  as BuiltList<AdminDepositsDtoOutputApplicationsInner>;
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
  AdminDepositsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDepositsDtoOutputBuilder();
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
