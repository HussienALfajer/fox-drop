//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_open_drawer_session_dto_floats_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_open_drawer_session_dto.g.dart';

/// AdminOpenDrawerSessionDto
///
/// Properties:
/// * [cityId]
/// * [kind] - A field session (a restaurant visit) opens with a zero float.
/// * [floats]
@BuiltValue()
abstract class AdminOpenDrawerSessionDto
    implements
        Built<AdminOpenDrawerSessionDto, AdminOpenDrawerSessionDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// A field session (a restaurant visit) opens with a zero float.
  @BuiltValueField(wireName: r'kind')
  AdminOpenDrawerSessionDtoKindEnum? get kind;
  // enum kindEnum {  office,  field,  };

  @BuiltValueField(wireName: r'floats')
  BuiltList<AdminOpenDrawerSessionDtoFloatsInner> get floats;

  AdminOpenDrawerSessionDto._();

  factory AdminOpenDrawerSessionDto([
    void updates(AdminOpenDrawerSessionDtoBuilder b),
  ]) = _$AdminOpenDrawerSessionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOpenDrawerSessionDtoBuilder b) =>
      b..kind = AdminOpenDrawerSessionDtoKindEnum.valueOf('office');

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOpenDrawerSessionDto> get serializer =>
      _$AdminOpenDrawerSessionDtoSerializer();
}

class _$AdminOpenDrawerSessionDtoSerializer
    implements PrimitiveSerializer<AdminOpenDrawerSessionDto> {
  @override
  final Iterable<Type> types = const [
    AdminOpenDrawerSessionDto,
    _$AdminOpenDrawerSessionDto,
  ];

  @override
  final String wireName = r'AdminOpenDrawerSessionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOpenDrawerSessionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    if (object.kind != null) {
      yield r'kind';
      yield serializers.serialize(
        object.kind,
        specifiedType: const FullType(AdminOpenDrawerSessionDtoKindEnum),
      );
    }
    yield r'floats';
    yield serializers.serialize(
      object.floats,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOpenDrawerSessionDtoFloatsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOpenDrawerSessionDto object, {
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
    required AdminOpenDrawerSessionDtoBuilder result,
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
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOpenDrawerSessionDtoKindEnum,
                    ),
                  )
                  as AdminOpenDrawerSessionDtoKindEnum?;
          if (valueDes == null) continue;
          result.kind = valueDes;
          break;
        case r'floats':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOpenDrawerSessionDtoFloatsInner),
                    ]),
                  )
                  as BuiltList<AdminOpenDrawerSessionDtoFloatsInner>;
          result.floats.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOpenDrawerSessionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOpenDrawerSessionDtoBuilder();
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

/// A field session (a restaurant visit) opens with a zero float.
class AdminOpenDrawerSessionDtoKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'office')
  static const AdminOpenDrawerSessionDtoKindEnum office =
      _$adminOpenDrawerSessionDtoKindEnum_office;
  @BuiltValueEnumConst(wireName: r'field')
  static const AdminOpenDrawerSessionDtoKindEnum field =
      _$adminOpenDrawerSessionDtoKindEnum_field;

  static Serializer<AdminOpenDrawerSessionDtoKindEnum> get serializer =>
      _$adminOpenDrawerSessionDtoKindEnumSerializer;

  const AdminOpenDrawerSessionDtoKindEnum._(String name) : super(name);

  static BuiltSet<AdminOpenDrawerSessionDtoKindEnum> get values =>
      _$adminOpenDrawerSessionDtoKindEnumValues;
  static AdminOpenDrawerSessionDtoKindEnum valueOf(String name) =>
      _$adminOpenDrawerSessionDtoKindEnumValueOf(name);
}
