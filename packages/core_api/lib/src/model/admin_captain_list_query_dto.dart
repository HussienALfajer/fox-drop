//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_list_query_dto.g.dart';

/// AdminCaptainListQueryDto
///
/// Properties:
/// * [cityId]
/// * [status] - Only this listed status; null for every one.
/// * [q] - A part of the name, or the sign-in number (E.164, 00…, 09…, 05…).
@BuiltValue()
abstract class AdminCaptainListQueryDto
    implements
        Built<AdminCaptainListQueryDto, AdminCaptainListQueryDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Only this listed status; null for every one.
  @BuiltValueField(wireName: r'status')
  AdminCaptainListQueryDtoStatusEnum? get status;
  // enum statusEnum {  online,  busy,  offline,  suspended,  cash_blocked,  terminated,  };

  /// A part of the name, or the sign-in number (E.164, 00…, 09…, 05…).
  @BuiltValueField(wireName: r'q')
  String? get q;

  AdminCaptainListQueryDto._();

  factory AdminCaptainListQueryDto([
    void updates(AdminCaptainListQueryDtoBuilder b),
  ]) = _$AdminCaptainListQueryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainListQueryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainListQueryDto> get serializer =>
      _$AdminCaptainListQueryDtoSerializer();
}

class _$AdminCaptainListQueryDtoSerializer
    implements PrimitiveSerializer<AdminCaptainListQueryDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainListQueryDto,
    _$AdminCaptainListQueryDto,
  ];

  @override
  final String wireName = r'AdminCaptainListQueryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainListQueryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield object.status == null
        ? null
        : serializers.serialize(
            object.status,
            specifiedType: const FullType.nullable(
              AdminCaptainListQueryDtoStatusEnum,
            ),
          );
    yield r'q';
    yield object.q == null
        ? null
        : serializers.serialize(
            object.q,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainListQueryDto object, {
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
    required AdminCaptainListQueryDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainListQueryDtoStatusEnum,
                    ),
                  )
                  as AdminCaptainListQueryDtoStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'q':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.q = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainListQueryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainListQueryDtoBuilder();
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

/// Only this listed status; null for every one.
class AdminCaptainListQueryDtoStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'online')
  static const AdminCaptainListQueryDtoStatusEnum online =
      _$adminCaptainListQueryDtoStatusEnum_online;
  @BuiltValueEnumConst(wireName: r'busy')
  static const AdminCaptainListQueryDtoStatusEnum busy =
      _$adminCaptainListQueryDtoStatusEnum_busy;
  @BuiltValueEnumConst(wireName: r'offline')
  static const AdminCaptainListQueryDtoStatusEnum offline =
      _$adminCaptainListQueryDtoStatusEnum_offline;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminCaptainListQueryDtoStatusEnum suspended =
      _$adminCaptainListQueryDtoStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'cash_blocked')
  static const AdminCaptainListQueryDtoStatusEnum cashBlocked =
      _$adminCaptainListQueryDtoStatusEnum_cashBlocked;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminCaptainListQueryDtoStatusEnum terminated =
      _$adminCaptainListQueryDtoStatusEnum_terminated;

  static Serializer<AdminCaptainListQueryDtoStatusEnum> get serializer =>
      _$adminCaptainListQueryDtoStatusEnumSerializer;

  const AdminCaptainListQueryDtoStatusEnum._(String name) : super(name);

  static BuiltSet<AdminCaptainListQueryDtoStatusEnum> get values =>
      _$adminCaptainListQueryDtoStatusEnumValues;
  static AdminCaptainListQueryDtoStatusEnum valueOf(String name) =>
      _$adminCaptainListQueryDtoStatusEnumValueOf(name);
}
