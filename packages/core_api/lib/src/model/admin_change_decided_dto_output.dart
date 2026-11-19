//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_decided_dto_output.g.dart';

/// AdminChangeDecidedDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class AdminChangeDecidedDtoOutput
    implements
        Built<AdminChangeDecidedDtoOutput, AdminChangeDecidedDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  AdminChangeDecidedDtoOutputStatusEnum get status;
  // enum statusEnum {  approved,  rejected,  };

  AdminChangeDecidedDtoOutput._();

  factory AdminChangeDecidedDtoOutput([
    void updates(AdminChangeDecidedDtoOutputBuilder b),
  ]) = _$AdminChangeDecidedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeDecidedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeDecidedDtoOutput> get serializer =>
      _$AdminChangeDecidedDtoOutputSerializer();
}

class _$AdminChangeDecidedDtoOutputSerializer
    implements PrimitiveSerializer<AdminChangeDecidedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminChangeDecidedDtoOutput,
    _$AdminChangeDecidedDtoOutput,
  ];

  @override
  final String wireName = r'AdminChangeDecidedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeDecidedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminChangeDecidedDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeDecidedDtoOutput object, {
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
    required AdminChangeDecidedDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminChangeDecidedDtoOutputStatusEnum,
                    ),
                  )
                  as AdminChangeDecidedDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChangeDecidedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeDecidedDtoOutputBuilder();
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

class AdminChangeDecidedDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'approved')
  static const AdminChangeDecidedDtoOutputStatusEnum approved =
      _$adminChangeDecidedDtoOutputStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminChangeDecidedDtoOutputStatusEnum rejected =
      _$adminChangeDecidedDtoOutputStatusEnum_rejected;

  static Serializer<AdminChangeDecidedDtoOutputStatusEnum> get serializer =>
      _$adminChangeDecidedDtoOutputStatusEnumSerializer;

  const AdminChangeDecidedDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<AdminChangeDecidedDtoOutputStatusEnum> get values =>
      _$adminChangeDecidedDtoOutputStatusEnumValues;
  static AdminChangeDecidedDtoOutputStatusEnum valueOf(String name) =>
      _$adminChangeDecidedDtoOutputStatusEnumValueOf(name);
}
