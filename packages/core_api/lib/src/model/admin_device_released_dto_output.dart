//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_device_released_dto_output.g.dart';

/// AdminDeviceReleasedDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class AdminDeviceReleasedDtoOutput
    implements
        Built<
          AdminDeviceReleasedDtoOutput,
          AdminDeviceReleasedDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'status')
  AdminDeviceReleasedDtoOutputStatusEnum get status;
  // enum statusEnum {  released,  };

  AdminDeviceReleasedDtoOutput._();

  factory AdminDeviceReleasedDtoOutput([
    void updates(AdminDeviceReleasedDtoOutputBuilder b),
  ]) = _$AdminDeviceReleasedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeviceReleasedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeviceReleasedDtoOutput> get serializer =>
      _$AdminDeviceReleasedDtoOutputSerializer();
}

class _$AdminDeviceReleasedDtoOutputSerializer
    implements PrimitiveSerializer<AdminDeviceReleasedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDeviceReleasedDtoOutput,
    _$AdminDeviceReleasedDtoOutput,
  ];

  @override
  final String wireName = r'AdminDeviceReleasedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeviceReleasedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminDeviceReleasedDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeviceReleasedDtoOutput object, {
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
    required AdminDeviceReleasedDtoOutputBuilder result,
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
                      AdminDeviceReleasedDtoOutputStatusEnum,
                    ),
                  )
                  as AdminDeviceReleasedDtoOutputStatusEnum;
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
  AdminDeviceReleasedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeviceReleasedDtoOutputBuilder();
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

class AdminDeviceReleasedDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'released')
  static const AdminDeviceReleasedDtoOutputStatusEnum released =
      _$adminDeviceReleasedDtoOutputStatusEnum_released;

  static Serializer<AdminDeviceReleasedDtoOutputStatusEnum> get serializer =>
      _$adminDeviceReleasedDtoOutputStatusEnumSerializer;

  const AdminDeviceReleasedDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<AdminDeviceReleasedDtoOutputStatusEnum> get values =>
      _$adminDeviceReleasedDtoOutputStatusEnumValues;
  static AdminDeviceReleasedDtoOutputStatusEnum valueOf(String name) =>
      _$adminDeviceReleasedDtoOutputStatusEnumValueOf(name);
}
