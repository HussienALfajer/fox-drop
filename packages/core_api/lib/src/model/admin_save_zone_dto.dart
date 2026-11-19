//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_save_zone_dto_area_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_save_zone_dto.g.dart';

/// AdminSaveZoneDto
///
/// Properties:
/// * [name]
/// * [area]
/// * [active]
/// * [reason] - Why, for the audit log; optional.
@BuiltValue()
abstract class AdminSaveZoneDto
    implements Built<AdminSaveZoneDto, AdminSaveZoneDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'area')
  BuiltList<AdminSaveZoneDtoAreaInner> get area;

  @BuiltValueField(wireName: r'active')
  bool get active;

  /// Why, for the audit log; optional.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminSaveZoneDto._();

  factory AdminSaveZoneDto([void updates(AdminSaveZoneDtoBuilder b)]) =
      _$AdminSaveZoneDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSaveZoneDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSaveZoneDto> get serializer =>
      _$AdminSaveZoneDtoSerializer();
}

class _$AdminSaveZoneDtoSerializer
    implements PrimitiveSerializer<AdminSaveZoneDto> {
  @override
  final Iterable<Type> types = const [AdminSaveZoneDto, _$AdminSaveZoneDto];

  @override
  final String wireName = r'AdminSaveZoneDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSaveZoneDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'area';
    yield serializers.serialize(
      object.area,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSaveZoneDtoAreaInner),
      ]),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSaveZoneDto object, {
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
    required AdminSaveZoneDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'area':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSaveZoneDtoAreaInner),
                    ]),
                  )
                  as BuiltList<AdminSaveZoneDtoAreaInner>;
          result.area.replace(valueDes);
          break;
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
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
  AdminSaveZoneDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSaveZoneDtoBuilder();
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
