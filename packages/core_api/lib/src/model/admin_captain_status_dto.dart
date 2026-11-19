//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_status_dto.g.dart';

/// AdminCaptainStatusDto
///
/// Properties:
/// * [status] - «إيقاف» or the reactivation; the termination is the offboarding’s.
/// * [until] - A suspension’s end, null for until further notice; null to reactivate.
/// * [reason] - A suspension’s is shown to the captain (AP §9.7.5).
@BuiltValue()
abstract class AdminCaptainStatusDto
    implements Built<AdminCaptainStatusDto, AdminCaptainStatusDtoBuilder> {
  /// «إيقاف» or the reactivation; the termination is the offboarding’s.
  @BuiltValueField(wireName: r'status')
  AdminCaptainStatusDtoStatusEnum get status;
  // enum statusEnum {  suspended,  active,  };

  /// A suspension’s end, null for until further notice; null to reactivate.
  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  /// A suspension’s is shown to the captain (AP §9.7.5).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminCaptainStatusDto._();

  factory AdminCaptainStatusDto([
    void updates(AdminCaptainStatusDtoBuilder b),
  ]) = _$AdminCaptainStatusDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainStatusDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainStatusDto> get serializer =>
      _$AdminCaptainStatusDtoSerializer();
}

class _$AdminCaptainStatusDtoSerializer
    implements PrimitiveSerializer<AdminCaptainStatusDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainStatusDto,
    _$AdminCaptainStatusDto,
  ];

  @override
  final String wireName = r'AdminCaptainStatusDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainStatusDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminCaptainStatusDtoStatusEnum),
    );
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainStatusDto object, {
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
    required AdminCaptainStatusDtoBuilder result,
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
                      AdminCaptainStatusDtoStatusEnum,
                    ),
                  )
                  as AdminCaptainStatusDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainStatusDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainStatusDtoBuilder();
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

/// «إيقاف» or the reactivation; the termination is the offboarding’s.
class AdminCaptainStatusDtoStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminCaptainStatusDtoStatusEnum suspended =
      _$adminCaptainStatusDtoStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCaptainStatusDtoStatusEnum active =
      _$adminCaptainStatusDtoStatusEnum_active;

  static Serializer<AdminCaptainStatusDtoStatusEnum> get serializer =>
      _$adminCaptainStatusDtoStatusEnumSerializer;

  const AdminCaptainStatusDtoStatusEnum._(String name) : super(name);

  static BuiltSet<AdminCaptainStatusDtoStatusEnum> get values =>
      _$adminCaptainStatusDtoStatusEnumValues;
  static AdminCaptainStatusDtoStatusEnum valueOf(String name) =>
      _$adminCaptainStatusDtoStatusEnumValueOf(name);
}
