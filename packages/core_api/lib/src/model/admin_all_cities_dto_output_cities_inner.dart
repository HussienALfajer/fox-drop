//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_all_cities_dto_output_cities_inner.g.dart';

/// AdminAllCitiesDtoOutputCitiesInner
///
/// Properties:
/// * [id]
/// * [code] - Two or three capital letters, such as AZ (AP §4.8).
/// * [name]
/// * [timeZone] - An IANA time zone, such as Asia/Damascus.
/// * [status]
@BuiltValue()
abstract class AdminAllCitiesDtoOutputCitiesInner
    implements
        Built<
          AdminAllCitiesDtoOutputCitiesInner,
          AdminAllCitiesDtoOutputCitiesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Two or three capital letters, such as AZ (AP §4.8).
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// An IANA time zone, such as Asia/Damascus.
  @BuiltValueField(wireName: r'timeZone')
  String get timeZone;

  @BuiltValueField(wireName: r'status')
  AdminAllCitiesDtoOutputCitiesInnerStatusEnum get status;
  // enum statusEnum {  active,  inactive,  };

  AdminAllCitiesDtoOutputCitiesInner._();

  factory AdminAllCitiesDtoOutputCitiesInner([
    void updates(AdminAllCitiesDtoOutputCitiesInnerBuilder b),
  ]) = _$AdminAllCitiesDtoOutputCitiesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAllCitiesDtoOutputCitiesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAllCitiesDtoOutputCitiesInner> get serializer =>
      _$AdminAllCitiesDtoOutputCitiesInnerSerializer();
}

class _$AdminAllCitiesDtoOutputCitiesInnerSerializer
    implements PrimitiveSerializer<AdminAllCitiesDtoOutputCitiesInner> {
  @override
  final Iterable<Type> types = const [
    AdminAllCitiesDtoOutputCitiesInner,
    _$AdminAllCitiesDtoOutputCitiesInner,
  ];

  @override
  final String wireName = r'AdminAllCitiesDtoOutputCitiesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAllCitiesDtoOutputCitiesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'timeZone';
    yield serializers.serialize(
      object.timeZone,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminAllCitiesDtoOutputCitiesInnerStatusEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAllCitiesDtoOutputCitiesInner object, {
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
    required AdminAllCitiesDtoOutputCitiesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'timeZone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.timeZone = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminAllCitiesDtoOutputCitiesInnerStatusEnum,
                    ),
                  )
                  as AdminAllCitiesDtoOutputCitiesInnerStatusEnum;
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
  AdminAllCitiesDtoOutputCitiesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAllCitiesDtoOutputCitiesInnerBuilder();
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

class AdminAllCitiesDtoOutputCitiesInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminAllCitiesDtoOutputCitiesInnerStatusEnum active =
      _$adminAllCitiesDtoOutputCitiesInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'inactive')
  static const AdminAllCitiesDtoOutputCitiesInnerStatusEnum inactive =
      _$adminAllCitiesDtoOutputCitiesInnerStatusEnum_inactive;

  static Serializer<AdminAllCitiesDtoOutputCitiesInnerStatusEnum>
  get serializer => _$adminAllCitiesDtoOutputCitiesInnerStatusEnumSerializer;

  const AdminAllCitiesDtoOutputCitiesInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminAllCitiesDtoOutputCitiesInnerStatusEnum> get values =>
      _$adminAllCitiesDtoOutputCitiesInnerStatusEnumValues;
  static AdminAllCitiesDtoOutputCitiesInnerStatusEnum valueOf(String name) =>
      _$adminAllCitiesDtoOutputCitiesInnerStatusEnumValueOf(name);
}
