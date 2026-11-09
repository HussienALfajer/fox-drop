//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_notification_text_dto_output.g.dart';

/// AdminNotificationTextDtoOutput
///
/// Properties:
/// * [key] - The template, such as customer.accepted.
/// * [audience] 
/// * [row] - The spec row it comes from, such as «CU §14 #1».
/// * [variables] - The placeholders it takes, without braces.
/// * [level] - The app's sound level; not editable.
/// * [priority] - Not editable.
/// * [text] - The default text.
/// * [current] - The text in use: the admin's edit, else the default.
@BuiltValue()
abstract class AdminNotificationTextDtoOutput implements Built<AdminNotificationTextDtoOutput, AdminNotificationTextDtoOutputBuilder> {
  /// The template, such as customer.accepted.
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'audience')
  AdminNotificationTextDtoOutputAudienceEnum get audience;
  // enum audienceEnum {  customer,  merchant,  captain,  };

  /// The spec row it comes from, such as «CU §14 #1».
  @BuiltValueField(wireName: r'row')
  String get row;

  /// The placeholders it takes, without braces.
  @BuiltValueField(wireName: r'variables')
  BuiltList<String> get variables;

  /// The app's sound level; not editable.
  @BuiltValueField(wireName: r'level')
  AdminNotificationTextDtoOutputLevelEnum get level;
  // enum levelEnum {  default,  ring,  chime,  offer,  cancellation,  silent,  };

  /// Not editable.
  @BuiltValueField(wireName: r'priority')
  AdminNotificationTextDtoOutputPriorityEnum get priority;
  // enum priorityEnum {  high,  normal,  };

  /// The default text.
  @BuiltValueField(wireName: r'text')
  String get text;

  /// The text in use: the admin's edit, else the default.
  @BuiltValueField(wireName: r'current')
  String get current;

  AdminNotificationTextDtoOutput._();

  factory AdminNotificationTextDtoOutput([void updates(AdminNotificationTextDtoOutputBuilder b)]) = _$AdminNotificationTextDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminNotificationTextDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNotificationTextDtoOutput> get serializer => _$AdminNotificationTextDtoOutputSerializer();
}

class _$AdminNotificationTextDtoOutputSerializer implements PrimitiveSerializer<AdminNotificationTextDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminNotificationTextDtoOutput, _$AdminNotificationTextDtoOutput];

  @override
  final String wireName = r'AdminNotificationTextDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNotificationTextDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(AdminNotificationTextDtoOutputAudienceEnum),
    );
    yield r'row';
    yield serializers.serialize(
      object.row,
      specifiedType: const FullType(String),
    );
    yield r'variables';
    yield serializers.serialize(
      object.variables,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'level';
    yield serializers.serialize(
      object.level,
      specifiedType: const FullType(AdminNotificationTextDtoOutputLevelEnum),
    );
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(AdminNotificationTextDtoOutputPriorityEnum),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'current';
    yield serializers.serialize(
      object.current,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminNotificationTextDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminNotificationTextDtoOutputBuilder result,
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
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminNotificationTextDtoOutputAudienceEnum),
          ) as AdminNotificationTextDtoOutputAudienceEnum;
          result.audience = valueDes;
          break;
        case r'row':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.row = valueDes;
          break;
        case r'variables':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.variables.replace(valueDes);
          break;
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminNotificationTextDtoOutputLevelEnum),
          ) as AdminNotificationTextDtoOutputLevelEnum;
          result.level = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminNotificationTextDtoOutputPriorityEnum),
          ) as AdminNotificationTextDtoOutputPriorityEnum;
          result.priority = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.current = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminNotificationTextDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNotificationTextDtoOutputBuilder();
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


class AdminNotificationTextDtoOutputAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminNotificationTextDtoOutputAudienceEnum customer = _$adminNotificationTextDtoOutputAudienceEnum_customer;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminNotificationTextDtoOutputAudienceEnum merchant = _$adminNotificationTextDtoOutputAudienceEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminNotificationTextDtoOutputAudienceEnum captain = _$adminNotificationTextDtoOutputAudienceEnum_captain;

  static Serializer<AdminNotificationTextDtoOutputAudienceEnum> get serializer => _$adminNotificationTextDtoOutputAudienceEnumSerializer;

  const AdminNotificationTextDtoOutputAudienceEnum._(String name): super(name);

  static BuiltSet<AdminNotificationTextDtoOutputAudienceEnum> get values => _$adminNotificationTextDtoOutputAudienceEnumValues;
  static AdminNotificationTextDtoOutputAudienceEnum valueOf(String name) => _$adminNotificationTextDtoOutputAudienceEnumValueOf(name);
}

/// The app's sound level; not editable.
class AdminNotificationTextDtoOutputLevelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'default')
  static const AdminNotificationTextDtoOutputLevelEnum default_ = _$adminNotificationTextDtoOutputLevelEnum_default_;
  @BuiltValueEnumConst(wireName: r'ring')
  static const AdminNotificationTextDtoOutputLevelEnum ring = _$adminNotificationTextDtoOutputLevelEnum_ring;
  @BuiltValueEnumConst(wireName: r'chime')
  static const AdminNotificationTextDtoOutputLevelEnum chime = _$adminNotificationTextDtoOutputLevelEnum_chime;
  @BuiltValueEnumConst(wireName: r'offer')
  static const AdminNotificationTextDtoOutputLevelEnum offer = _$adminNotificationTextDtoOutputLevelEnum_offer;
  @BuiltValueEnumConst(wireName: r'cancellation')
  static const AdminNotificationTextDtoOutputLevelEnum cancellation = _$adminNotificationTextDtoOutputLevelEnum_cancellation;
  @BuiltValueEnumConst(wireName: r'silent')
  static const AdminNotificationTextDtoOutputLevelEnum silent = _$adminNotificationTextDtoOutputLevelEnum_silent;

  static Serializer<AdminNotificationTextDtoOutputLevelEnum> get serializer => _$adminNotificationTextDtoOutputLevelEnumSerializer;

  const AdminNotificationTextDtoOutputLevelEnum._(String name): super(name);

  static BuiltSet<AdminNotificationTextDtoOutputLevelEnum> get values => _$adminNotificationTextDtoOutputLevelEnumValues;
  static AdminNotificationTextDtoOutputLevelEnum valueOf(String name) => _$adminNotificationTextDtoOutputLevelEnumValueOf(name);
}

/// Not editable.
class AdminNotificationTextDtoOutputPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'high')
  static const AdminNotificationTextDtoOutputPriorityEnum high = _$adminNotificationTextDtoOutputPriorityEnum_high;
  @BuiltValueEnumConst(wireName: r'normal')
  static const AdminNotificationTextDtoOutputPriorityEnum normal = _$adminNotificationTextDtoOutputPriorityEnum_normal;

  static Serializer<AdminNotificationTextDtoOutputPriorityEnum> get serializer => _$adminNotificationTextDtoOutputPriorityEnumSerializer;

  const AdminNotificationTextDtoOutputPriorityEnum._(String name): super(name);

  static BuiltSet<AdminNotificationTextDtoOutputPriorityEnum> get values => _$adminNotificationTextDtoOutputPriorityEnumValues;
  static AdminNotificationTextDtoOutputPriorityEnum valueOf(String name) => _$adminNotificationTextDtoOutputPriorityEnumValueOf(name);
}

