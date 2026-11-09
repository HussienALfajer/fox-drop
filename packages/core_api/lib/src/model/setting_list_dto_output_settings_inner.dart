//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'setting_list_dto_output_settings_inner.g.dart';

/// SettingListDtoOutputSettingsInner
///
/// Properties:
/// * [key] 
/// * [template] - The Appendix A key, such as currency.<code>.rounding_unit.
/// * [parameter] 
/// * [group] 
/// * [type] 
/// * [unit] 
/// * [scope] 
/// * [cityId] 
/// * [editRoles] 
/// * [reasonRequired] 
/// * [beforeLaunch] - No default: the owner enters the value before launch.
/// * [default_] 
/// * [value] - The value in effect: the stored one, or the default.
/// * [isDefault] 
@BuiltValue()
abstract class SettingListDtoOutputSettingsInner implements Built<SettingListDtoOutputSettingsInner, SettingListDtoOutputSettingsInnerBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  /// The Appendix A key, such as currency.<code>.rounding_unit.
  @BuiltValueField(wireName: r'template')
  String get template;

  @BuiltValueField(wireName: r'parameter')
  String? get parameter;

  @BuiltValueField(wireName: r'group')
  SettingListDtoOutputSettingsInnerGroupEnum get group;
  // enum groupEnum {  timers_limits,  dispatch,  customers,  captains,  restaurants,  support,  finance,  security,  apps,  };

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'unit')
  String? get unit;

  @BuiltValueField(wireName: r'scope')
  SettingListDtoOutputSettingsInnerScopeEnum get scope;
  // enum scopeEnum {  global,  city,  };

  @BuiltValueField(wireName: r'cityId')
  String? get cityId;

  @BuiltValueField(wireName: r'editRoles')
  BuiltList<SettingListDtoOutputSettingsInnerEditRolesEnum> get editRoles;
  // enum editRolesEnum {  OWN,  OPS,  SUP,  FIN,  DATA,  };

  @BuiltValueField(wireName: r'reasonRequired')
  bool get reasonRequired;

  /// No default: the owner enters the value before launch.
  @BuiltValueField(wireName: r'beforeLaunch')
  bool get beforeLaunch;

  @BuiltValueField(wireName: r'default')
  JsonObject? get default_;

  /// The value in effect: the stored one, or the default.
  @BuiltValueField(wireName: r'value')
  JsonObject? get value;

  @BuiltValueField(wireName: r'isDefault')
  bool get isDefault;

  SettingListDtoOutputSettingsInner._();

  factory SettingListDtoOutputSettingsInner([void updates(SettingListDtoOutputSettingsInnerBuilder b)]) = _$SettingListDtoOutputSettingsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingListDtoOutputSettingsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingListDtoOutputSettingsInner> get serializer => _$SettingListDtoOutputSettingsInnerSerializer();
}

class _$SettingListDtoOutputSettingsInnerSerializer implements PrimitiveSerializer<SettingListDtoOutputSettingsInner> {
  @override
  final Iterable<Type> types = const [SettingListDtoOutputSettingsInner, _$SettingListDtoOutputSettingsInner];

  @override
  final String wireName = r'SettingListDtoOutputSettingsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingListDtoOutputSettingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'template';
    yield serializers.serialize(
      object.template,
      specifiedType: const FullType(String),
    );
    yield r'parameter';
    yield object.parameter == null ? null : serializers.serialize(
      object.parameter,
      specifiedType: const FullType.nullable(String),
    );
    yield r'group';
    yield serializers.serialize(
      object.group,
      specifiedType: const FullType(SettingListDtoOutputSettingsInnerGroupEnum),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'unit';
    yield object.unit == null ? null : serializers.serialize(
      object.unit,
      specifiedType: const FullType.nullable(String),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(SettingListDtoOutputSettingsInnerScopeEnum),
    );
    yield r'cityId';
    yield object.cityId == null ? null : serializers.serialize(
      object.cityId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'editRoles';
    yield serializers.serialize(
      object.editRoles,
      specifiedType: const FullType(BuiltList, [FullType(SettingListDtoOutputSettingsInnerEditRolesEnum)]),
    );
    yield r'reasonRequired';
    yield serializers.serialize(
      object.reasonRequired,
      specifiedType: const FullType(bool),
    );
    yield r'beforeLaunch';
    yield serializers.serialize(
      object.beforeLaunch,
      specifiedType: const FullType(bool),
    );
    yield r'default';
    yield object.default_ == null ? null : serializers.serialize(
      object.default_,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'value';
    yield object.value == null ? null : serializers.serialize(
      object.value,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'isDefault';
    yield serializers.serialize(
      object.isDefault,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingListDtoOutputSettingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettingListDtoOutputSettingsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'template':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.template = valueDes;
          break;
        case r'parameter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parameter = valueDes;
          break;
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SettingListDtoOutputSettingsInnerGroupEnum),
          ) as SettingListDtoOutputSettingsInnerGroupEnum;
          result.group = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unit = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SettingListDtoOutputSettingsInnerScopeEnum),
          ) as SettingListDtoOutputSettingsInnerScopeEnum;
          result.scope = valueDes;
          break;
        case r'cityId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cityId = valueDes;
          break;
        case r'editRoles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SettingListDtoOutputSettingsInnerEditRolesEnum)]),
          ) as BuiltList<SettingListDtoOutputSettingsInnerEditRolesEnum>;
          result.editRoles.replace(valueDes);
          break;
        case r'reasonRequired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.reasonRequired = valueDes;
          break;
        case r'beforeLaunch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.beforeLaunch = valueDes;
          break;
        case r'default':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.default_ = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.value = valueDes;
          break;
        case r'isDefault':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isDefault = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingListDtoOutputSettingsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingListDtoOutputSettingsInnerBuilder();
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


class SettingListDtoOutputSettingsInnerGroupEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'timers_limits')
  static const SettingListDtoOutputSettingsInnerGroupEnum timersLimits = _$settingListDtoOutputSettingsInnerGroupEnum_timersLimits;
  @BuiltValueEnumConst(wireName: r'dispatch')
  static const SettingListDtoOutputSettingsInnerGroupEnum dispatch = _$settingListDtoOutputSettingsInnerGroupEnum_dispatch;
  @BuiltValueEnumConst(wireName: r'customers')
  static const SettingListDtoOutputSettingsInnerGroupEnum customers = _$settingListDtoOutputSettingsInnerGroupEnum_customers;
  @BuiltValueEnumConst(wireName: r'captains')
  static const SettingListDtoOutputSettingsInnerGroupEnum captains = _$settingListDtoOutputSettingsInnerGroupEnum_captains;
  @BuiltValueEnumConst(wireName: r'restaurants')
  static const SettingListDtoOutputSettingsInnerGroupEnum restaurants = _$settingListDtoOutputSettingsInnerGroupEnum_restaurants;
  @BuiltValueEnumConst(wireName: r'support')
  static const SettingListDtoOutputSettingsInnerGroupEnum support = _$settingListDtoOutputSettingsInnerGroupEnum_support;
  @BuiltValueEnumConst(wireName: r'finance')
  static const SettingListDtoOutputSettingsInnerGroupEnum finance = _$settingListDtoOutputSettingsInnerGroupEnum_finance;
  @BuiltValueEnumConst(wireName: r'security')
  static const SettingListDtoOutputSettingsInnerGroupEnum security = _$settingListDtoOutputSettingsInnerGroupEnum_security;
  @BuiltValueEnumConst(wireName: r'apps')
  static const SettingListDtoOutputSettingsInnerGroupEnum apps = _$settingListDtoOutputSettingsInnerGroupEnum_apps;

  static Serializer<SettingListDtoOutputSettingsInnerGroupEnum> get serializer => _$settingListDtoOutputSettingsInnerGroupEnumSerializer;

  const SettingListDtoOutputSettingsInnerGroupEnum._(String name): super(name);

  static BuiltSet<SettingListDtoOutputSettingsInnerGroupEnum> get values => _$settingListDtoOutputSettingsInnerGroupEnumValues;
  static SettingListDtoOutputSettingsInnerGroupEnum valueOf(String name) => _$settingListDtoOutputSettingsInnerGroupEnumValueOf(name);
}

class SettingListDtoOutputSettingsInnerScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'global')
  static const SettingListDtoOutputSettingsInnerScopeEnum global = _$settingListDtoOutputSettingsInnerScopeEnum_global;
  @BuiltValueEnumConst(wireName: r'city')
  static const SettingListDtoOutputSettingsInnerScopeEnum city = _$settingListDtoOutputSettingsInnerScopeEnum_city;

  static Serializer<SettingListDtoOutputSettingsInnerScopeEnum> get serializer => _$settingListDtoOutputSettingsInnerScopeEnumSerializer;

  const SettingListDtoOutputSettingsInnerScopeEnum._(String name): super(name);

  static BuiltSet<SettingListDtoOutputSettingsInnerScopeEnum> get values => _$settingListDtoOutputSettingsInnerScopeEnumValues;
  static SettingListDtoOutputSettingsInnerScopeEnum valueOf(String name) => _$settingListDtoOutputSettingsInnerScopeEnumValueOf(name);
}

class SettingListDtoOutputSettingsInnerEditRolesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OWN')
  static const SettingListDtoOutputSettingsInnerEditRolesEnum OWN = _$settingListDtoOutputSettingsInnerEditRolesEnum_OWN;
  @BuiltValueEnumConst(wireName: r'OPS')
  static const SettingListDtoOutputSettingsInnerEditRolesEnum OPS = _$settingListDtoOutputSettingsInnerEditRolesEnum_OPS;
  @BuiltValueEnumConst(wireName: r'SUP')
  static const SettingListDtoOutputSettingsInnerEditRolesEnum SUP = _$settingListDtoOutputSettingsInnerEditRolesEnum_SUP;
  @BuiltValueEnumConst(wireName: r'FIN')
  static const SettingListDtoOutputSettingsInnerEditRolesEnum FIN = _$settingListDtoOutputSettingsInnerEditRolesEnum_FIN;
  @BuiltValueEnumConst(wireName: r'DATA')
  static const SettingListDtoOutputSettingsInnerEditRolesEnum DATA = _$settingListDtoOutputSettingsInnerEditRolesEnum_DATA;

  static Serializer<SettingListDtoOutputSettingsInnerEditRolesEnum> get serializer => _$settingListDtoOutputSettingsInnerEditRolesEnumSerializer;

  const SettingListDtoOutputSettingsInnerEditRolesEnum._(String name): super(name);

  static BuiltSet<SettingListDtoOutputSettingsInnerEditRolesEnum> get values => _$settingListDtoOutputSettingsInnerEditRolesEnumValues;
  static SettingListDtoOutputSettingsInnerEditRolesEnum valueOf(String name) => _$settingListDtoOutputSettingsInnerEditRolesEnumValueOf(name);
}

