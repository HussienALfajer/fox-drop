//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'setting_entry_dto_output.g.dart';

/// SettingEntryDtoOutput
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
abstract class SettingEntryDtoOutput
    implements Built<SettingEntryDtoOutput, SettingEntryDtoOutputBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  /// The Appendix A key, such as currency.<code>.rounding_unit.
  @BuiltValueField(wireName: r'template')
  String get template;

  @BuiltValueField(wireName: r'parameter')
  BuiltList<String> get parameter;

  @BuiltValueField(wireName: r'group')
  SettingEntryDtoOutputGroupEnum get group;
  // enum groupEnum {  timers_limits,  dispatch,  customers,  captains,  restaurants,  support,  finance,  security,  apps,  };

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'unit')
  BuiltList<String> get unit;

  @BuiltValueField(wireName: r'scope')
  SettingEntryDtoOutputScopeEnum get scope;
  // enum scopeEnum {  global,  city,  };

  @BuiltValueField(wireName: r'cityId')
  String? get cityId;

  @BuiltValueField(wireName: r'editRoles')
  BuiltList<SettingEntryDtoOutputEditRolesEnum> get editRoles;
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

  SettingEntryDtoOutput._();

  factory SettingEntryDtoOutput([
    void updates(SettingEntryDtoOutputBuilder b),
  ]) = _$SettingEntryDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingEntryDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingEntryDtoOutput> get serializer =>
      _$SettingEntryDtoOutputSerializer();
}

class _$SettingEntryDtoOutputSerializer
    implements PrimitiveSerializer<SettingEntryDtoOutput> {
  @override
  final Iterable<Type> types = const [
    SettingEntryDtoOutput,
    _$SettingEntryDtoOutput,
  ];

  @override
  final String wireName = r'SettingEntryDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingEntryDtoOutput object, {
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
    yield serializers.serialize(
      object.parameter,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'group';
    yield serializers.serialize(
      object.group,
      specifiedType: const FullType(SettingEntryDtoOutputGroupEnum),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(SettingEntryDtoOutputScopeEnum),
    );
    yield r'cityId';
    yield object.cityId == null
        ? null
        : serializers.serialize(
            object.cityId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'editRoles';
    yield serializers.serialize(
      object.editRoles,
      specifiedType: const FullType(BuiltList, [
        FullType(SettingEntryDtoOutputEditRolesEnum),
      ]),
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
    yield object.default_ == null
        ? null
        : serializers.serialize(
            object.default_,
            specifiedType: const FullType.nullable(JsonObject),
          );
    yield r'value';
    yield object.value == null
        ? null
        : serializers.serialize(
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
    SettingEntryDtoOutput object, {
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
    required SettingEntryDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.key = valueDes;
          break;
        case r'template':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.template = valueDes;
          break;
        case r'parameter':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.parameter.replace(valueDes);
          break;
        case r'group':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      SettingEntryDtoOutputGroupEnum,
                    ),
                  )
                  as SettingEntryDtoOutputGroupEnum;
          result.group = valueDes;
          break;
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.type = valueDes;
          break;
        case r'unit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.unit.replace(valueDes);
          break;
        case r'scope':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      SettingEntryDtoOutputScopeEnum,
                    ),
                  )
                  as SettingEntryDtoOutputScopeEnum;
          result.scope = valueDes;
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cityId = valueDes;
          break;
        case r'editRoles':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(SettingEntryDtoOutputEditRolesEnum),
                    ]),
                  )
                  as BuiltList<SettingEntryDtoOutputEditRolesEnum>;
          result.editRoles.replace(valueDes);
          break;
        case r'reasonRequired':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.reasonRequired = valueDes;
          break;
        case r'beforeLaunch':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.beforeLaunch = valueDes;
          break;
        case r'default':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(JsonObject),
                  )
                  as JsonObject?;
          if (valueDes == null) continue;
          result.default_ = valueDes;
          break;
        case r'value':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(JsonObject),
                  )
                  as JsonObject?;
          if (valueDes == null) continue;
          result.value = valueDes;
          break;
        case r'isDefault':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
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
  SettingEntryDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingEntryDtoOutputBuilder();
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

class SettingEntryDtoOutputGroupEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'timers_limits')
  static const SettingEntryDtoOutputGroupEnum timersLimits =
      _$settingEntryDtoOutputGroupEnum_timersLimits;
  @BuiltValueEnumConst(wireName: r'dispatch')
  static const SettingEntryDtoOutputGroupEnum dispatch =
      _$settingEntryDtoOutputGroupEnum_dispatch;
  @BuiltValueEnumConst(wireName: r'customers')
  static const SettingEntryDtoOutputGroupEnum customers =
      _$settingEntryDtoOutputGroupEnum_customers;
  @BuiltValueEnumConst(wireName: r'captains')
  static const SettingEntryDtoOutputGroupEnum captains =
      _$settingEntryDtoOutputGroupEnum_captains;
  @BuiltValueEnumConst(wireName: r'restaurants')
  static const SettingEntryDtoOutputGroupEnum restaurants =
      _$settingEntryDtoOutputGroupEnum_restaurants;
  @BuiltValueEnumConst(wireName: r'support')
  static const SettingEntryDtoOutputGroupEnum support =
      _$settingEntryDtoOutputGroupEnum_support;
  @BuiltValueEnumConst(wireName: r'finance')
  static const SettingEntryDtoOutputGroupEnum finance =
      _$settingEntryDtoOutputGroupEnum_finance;
  @BuiltValueEnumConst(wireName: r'security')
  static const SettingEntryDtoOutputGroupEnum security =
      _$settingEntryDtoOutputGroupEnum_security;
  @BuiltValueEnumConst(wireName: r'apps')
  static const SettingEntryDtoOutputGroupEnum apps =
      _$settingEntryDtoOutputGroupEnum_apps;

  static Serializer<SettingEntryDtoOutputGroupEnum> get serializer =>
      _$settingEntryDtoOutputGroupEnumSerializer;

  const SettingEntryDtoOutputGroupEnum._(String name) : super(name);

  static BuiltSet<SettingEntryDtoOutputGroupEnum> get values =>
      _$settingEntryDtoOutputGroupEnumValues;
  static SettingEntryDtoOutputGroupEnum valueOf(String name) =>
      _$settingEntryDtoOutputGroupEnumValueOf(name);
}

class SettingEntryDtoOutputScopeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'global')
  static const SettingEntryDtoOutputScopeEnum global =
      _$settingEntryDtoOutputScopeEnum_global;
  @BuiltValueEnumConst(wireName: r'city')
  static const SettingEntryDtoOutputScopeEnum city =
      _$settingEntryDtoOutputScopeEnum_city;

  static Serializer<SettingEntryDtoOutputScopeEnum> get serializer =>
      _$settingEntryDtoOutputScopeEnumSerializer;

  const SettingEntryDtoOutputScopeEnum._(String name) : super(name);

  static BuiltSet<SettingEntryDtoOutputScopeEnum> get values =>
      _$settingEntryDtoOutputScopeEnumValues;
  static SettingEntryDtoOutputScopeEnum valueOf(String name) =>
      _$settingEntryDtoOutputScopeEnumValueOf(name);
}

class SettingEntryDtoOutputEditRolesEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'OWN')
  static const SettingEntryDtoOutputEditRolesEnum OWN =
      _$settingEntryDtoOutputEditRolesEnum_OWN;
  @BuiltValueEnumConst(wireName: r'OPS')
  static const SettingEntryDtoOutputEditRolesEnum OPS =
      _$settingEntryDtoOutputEditRolesEnum_OPS;
  @BuiltValueEnumConst(wireName: r'SUP')
  static const SettingEntryDtoOutputEditRolesEnum SUP =
      _$settingEntryDtoOutputEditRolesEnum_SUP;
  @BuiltValueEnumConst(wireName: r'FIN')
  static const SettingEntryDtoOutputEditRolesEnum FIN =
      _$settingEntryDtoOutputEditRolesEnum_FIN;
  @BuiltValueEnumConst(wireName: r'DATA')
  static const SettingEntryDtoOutputEditRolesEnum DATA =
      _$settingEntryDtoOutputEditRolesEnum_DATA;

  static Serializer<SettingEntryDtoOutputEditRolesEnum> get serializer =>
      _$settingEntryDtoOutputEditRolesEnumSerializer;

  const SettingEntryDtoOutputEditRolesEnum._(String name) : super(name);

  static BuiltSet<SettingEntryDtoOutputEditRolesEnum> get values =>
      _$settingEntryDtoOutputEditRolesEnumValues;
  static SettingEntryDtoOutputEditRolesEnum valueOf(String name) =>
      _$settingEntryDtoOutputEditRolesEnumValueOf(name);
}
