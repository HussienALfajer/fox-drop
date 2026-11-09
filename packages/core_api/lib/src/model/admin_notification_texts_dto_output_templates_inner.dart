//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_notification_texts_dto_output_templates_inner.g.dart';

/// AdminNotificationTextsDtoOutputTemplatesInner
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
abstract class AdminNotificationTextsDtoOutputTemplatesInner
    implements
        Built<
          AdminNotificationTextsDtoOutputTemplatesInner,
          AdminNotificationTextsDtoOutputTemplatesInnerBuilder
        > {
  /// The template, such as customer.accepted.
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'audience')
  AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum get audience;
  // enum audienceEnum {  customer,  merchant,  captain,  };

  /// The spec row it comes from, such as «CU §14 #1».
  @BuiltValueField(wireName: r'row')
  String get row;

  /// The placeholders it takes, without braces.
  @BuiltValueField(wireName: r'variables')
  BuiltList<String> get variables;

  /// The app's sound level; not editable.
  @BuiltValueField(wireName: r'level')
  AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum get level;
  // enum levelEnum {  default,  ring,  chime,  offer,  cancellation,  silent,  };

  /// Not editable.
  @BuiltValueField(wireName: r'priority')
  AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum get priority;
  // enum priorityEnum {  high,  normal,  };

  /// The default text.
  @BuiltValueField(wireName: r'text')
  String get text;

  /// The text in use: the admin's edit, else the default.
  @BuiltValueField(wireName: r'current')
  String get current;

  AdminNotificationTextsDtoOutputTemplatesInner._();

  factory AdminNotificationTextsDtoOutputTemplatesInner([
    void updates(AdminNotificationTextsDtoOutputTemplatesInnerBuilder b),
  ]) = _$AdminNotificationTextsDtoOutputTemplatesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminNotificationTextsDtoOutputTemplatesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNotificationTextsDtoOutputTemplatesInner>
  get serializer => _$AdminNotificationTextsDtoOutputTemplatesInnerSerializer();
}

class _$AdminNotificationTextsDtoOutputTemplatesInnerSerializer
    implements
        PrimitiveSerializer<AdminNotificationTextsDtoOutputTemplatesInner> {
  @override
  final Iterable<Type> types = const [
    AdminNotificationTextsDtoOutputTemplatesInner,
    _$AdminNotificationTextsDtoOutputTemplatesInner,
  ];

  @override
  final String wireName = r'AdminNotificationTextsDtoOutputTemplatesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNotificationTextsDtoOutputTemplatesInner object, {
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
      specifiedType: const FullType(
        AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum,
      ),
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
      specifiedType: const FullType(
        AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum,
      ),
    );
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(
        AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum,
      ),
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
    AdminNotificationTextsDtoOutputTemplatesInner object, {
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
    required AdminNotificationTextsDtoOutputTemplatesInnerBuilder result,
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
        case r'audience':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum,
                    ),
                  )
                  as AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum;
          result.audience = valueDes;
          break;
        case r'row':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.row = valueDes;
          break;
        case r'variables':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.variables.replace(valueDes);
          break;
        case r'level':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum,
                    ),
                  )
                  as AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum;
          result.level = valueDes;
          break;
        case r'priority':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum,
                    ),
                  )
                  as AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum;
          result.priority = valueDes;
          break;
        case r'text':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.text = valueDes;
          break;
        case r'current':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
  AdminNotificationTextsDtoOutputTemplatesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNotificationTextsDtoOutputTemplatesInnerBuilder();
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

class AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum
  customer =
      _$adminNotificationTextsDtoOutputTemplatesInnerAudienceEnum_customer;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum
  merchant =
      _$adminNotificationTextsDtoOutputTemplatesInnerAudienceEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum
  captain = _$adminNotificationTextsDtoOutputTemplatesInnerAudienceEnum_captain;

  static Serializer<AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum>
  get serializer =>
      _$adminNotificationTextsDtoOutputTemplatesInnerAudienceEnumSerializer;

  const AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum._(String name)
    : super(name);

  static BuiltSet<AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum>
  get values =>
      _$adminNotificationTextsDtoOutputTemplatesInnerAudienceEnumValues;
  static AdminNotificationTextsDtoOutputTemplatesInnerAudienceEnum valueOf(
    String name,
  ) => _$adminNotificationTextsDtoOutputTemplatesInnerAudienceEnumValueOf(name);
}

/// The app's sound level; not editable.
class AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'default')
  static const AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum default_ =
      _$adminNotificationTextsDtoOutputTemplatesInnerLevelEnum_default_;
  @BuiltValueEnumConst(wireName: r'ring')
  static const AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum ring =
      _$adminNotificationTextsDtoOutputTemplatesInnerLevelEnum_ring;
  @BuiltValueEnumConst(wireName: r'chime')
  static const AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum chime =
      _$adminNotificationTextsDtoOutputTemplatesInnerLevelEnum_chime;
  @BuiltValueEnumConst(wireName: r'offer')
  static const AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum offer =
      _$adminNotificationTextsDtoOutputTemplatesInnerLevelEnum_offer;
  @BuiltValueEnumConst(wireName: r'cancellation')
  static const AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum
  cancellation =
      _$adminNotificationTextsDtoOutputTemplatesInnerLevelEnum_cancellation;
  @BuiltValueEnumConst(wireName: r'silent')
  static const AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum silent =
      _$adminNotificationTextsDtoOutputTemplatesInnerLevelEnum_silent;

  static Serializer<AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum>
  get serializer =>
      _$adminNotificationTextsDtoOutputTemplatesInnerLevelEnumSerializer;

  const AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum._(String name)
    : super(name);

  static BuiltSet<AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum>
  get values => _$adminNotificationTextsDtoOutputTemplatesInnerLevelEnumValues;
  static AdminNotificationTextsDtoOutputTemplatesInnerLevelEnum valueOf(
    String name,
  ) => _$adminNotificationTextsDtoOutputTemplatesInnerLevelEnumValueOf(name);
}

/// Not editable.
class AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'high')
  static const AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum high =
      _$adminNotificationTextsDtoOutputTemplatesInnerPriorityEnum_high;
  @BuiltValueEnumConst(wireName: r'normal')
  static const AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum
  normal = _$adminNotificationTextsDtoOutputTemplatesInnerPriorityEnum_normal;

  static Serializer<AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum>
  get serializer =>
      _$adminNotificationTextsDtoOutputTemplatesInnerPriorityEnumSerializer;

  const AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum._(String name)
    : super(name);

  static BuiltSet<AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum>
  get values =>
      _$adminNotificationTextsDtoOutputTemplatesInnerPriorityEnumValues;
  static AdminNotificationTextsDtoOutputTemplatesInnerPriorityEnum valueOf(
    String name,
  ) => _$adminNotificationTextsDtoOutputTemplatesInnerPriorityEnumValueOf(name);
}
