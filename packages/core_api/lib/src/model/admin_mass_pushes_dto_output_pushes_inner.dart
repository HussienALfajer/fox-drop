//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_mass_pushes_dto_output_pushes_inner.g.dart';

/// AdminMassPushesDtoOutputPushesInner
///
/// Properties:
/// * [id]
/// * [title]
/// * [body]
/// * [audience] - `all` every registered customer; `zone` those with a saved address in zoneId; `inactive` those whose latest delivered order in the city is older than inactiveDays; `never_ordered` registered with no delivered order in the city.
/// * [zoneId]
/// * [inactiveDays] - 1 to 365.
/// * [zoneName]
/// * [target] - `home` the home screen; `restaurant` its page (restaurantId); `code` «أكوادي» on that code (codeId).
/// * [restaurantId]
/// * [restaurantName]
/// * [codeId]
/// * [code]
/// * [scheduled] - False for «الآن»: sendAt is the confirmation.
/// * [sendAt]
/// * [status]
/// * [recipients] - The audience confirmed.
/// * [sent] - Accepted by FCM for a device.
/// * [delivered] - Acknowledged by the app on arrival.
/// * [sentBy] - The admin's name.
/// * [createdAt]
/// * [cancelledBy]
/// * [cancelledAt]
@BuiltValue()
abstract class AdminMassPushesDtoOutputPushesInner
    implements
        Built<
          AdminMassPushesDtoOutputPushesInner,
          AdminMassPushesDtoOutputPushesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'body')
  String get body;

  /// `all` every registered customer; `zone` those with a saved address in zoneId; `inactive` those whose latest delivered order in the city is older than inactiveDays; `never_ordered` registered with no delivered order in the city.
  @BuiltValueField(wireName: r'audience')
  AdminMassPushesDtoOutputPushesInnerAudienceEnum get audience;
  // enum audienceEnum {  all,  zone,  inactive,  never_ordered,  };

  @BuiltValueField(wireName: r'zoneId')
  String? get zoneId;

  /// 1 to 365.
  @BuiltValueField(wireName: r'inactiveDays')
  int? get inactiveDays;

  @BuiltValueField(wireName: r'zoneName')
  String? get zoneName;

  /// `home` the home screen; `restaurant` its page (restaurantId); `code` «أكوادي» on that code (codeId).
  @BuiltValueField(wireName: r'target')
  AdminMassPushesDtoOutputPushesInnerTargetEnum get target;
  // enum targetEnum {  home,  restaurant,  code,  };

  @BuiltValueField(wireName: r'restaurantId')
  String? get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String? get restaurantName;

  @BuiltValueField(wireName: r'codeId')
  String? get codeId;

  @BuiltValueField(wireName: r'code')
  String? get code;

  /// False for «الآن»: sendAt is the confirmation.
  @BuiltValueField(wireName: r'scheduled')
  bool get scheduled;

  @BuiltValueField(wireName: r'sendAt')
  DateTime get sendAt;

  @BuiltValueField(wireName: r'status')
  AdminMassPushesDtoOutputPushesInnerStatusEnum get status;
  // enum statusEnum {  scheduled,  sent,  cancelled,  };

  /// The audience confirmed.
  @BuiltValueField(wireName: r'recipients')
  int get recipients;

  /// Accepted by FCM for a device.
  @BuiltValueField(wireName: r'sent')
  int get sent;

  /// Acknowledged by the app on arrival.
  @BuiltValueField(wireName: r'delivered')
  int get delivered;

  /// The admin's name.
  @BuiltValueField(wireName: r'sentBy')
  String get sentBy;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'cancelledBy')
  String? get cancelledBy;

  @BuiltValueField(wireName: r'cancelledAt')
  DateTime? get cancelledAt;

  AdminMassPushesDtoOutputPushesInner._();

  factory AdminMassPushesDtoOutputPushesInner([
    void updates(AdminMassPushesDtoOutputPushesInnerBuilder b),
  ]) = _$AdminMassPushesDtoOutputPushesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMassPushesDtoOutputPushesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMassPushesDtoOutputPushesInner> get serializer =>
      _$AdminMassPushesDtoOutputPushesInnerSerializer();
}

class _$AdminMassPushesDtoOutputPushesInnerSerializer
    implements PrimitiveSerializer<AdminMassPushesDtoOutputPushesInner> {
  @override
  final Iterable<Type> types = const [
    AdminMassPushesDtoOutputPushesInner,
    _$AdminMassPushesDtoOutputPushesInner,
  ];

  @override
  final String wireName = r'AdminMassPushesDtoOutputPushesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMassPushesDtoOutputPushesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(
        AdminMassPushesDtoOutputPushesInnerAudienceEnum,
      ),
    );
    yield r'zoneId';
    yield object.zoneId == null
        ? null
        : serializers.serialize(
            object.zoneId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'inactiveDays';
    yield object.inactiveDays == null
        ? null
        : serializers.serialize(
            object.inactiveDays,
            specifiedType: const FullType.nullable(int),
          );
    yield r'zoneName';
    yield object.zoneName == null
        ? null
        : serializers.serialize(
            object.zoneName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'target';
    yield serializers.serialize(
      object.target,
      specifiedType: const FullType(
        AdminMassPushesDtoOutputPushesInnerTargetEnum,
      ),
    );
    yield r'restaurantId';
    yield object.restaurantId == null
        ? null
        : serializers.serialize(
            object.restaurantId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'restaurantName';
    yield object.restaurantName == null
        ? null
        : serializers.serialize(
            object.restaurantName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'codeId';
    yield object.codeId == null
        ? null
        : serializers.serialize(
            object.codeId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'code';
    yield object.code == null
        ? null
        : serializers.serialize(
            object.code,
            specifiedType: const FullType.nullable(String),
          );
    yield r'scheduled';
    yield serializers.serialize(
      object.scheduled,
      specifiedType: const FullType(bool),
    );
    yield r'sendAt';
    yield serializers.serialize(
      object.sendAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminMassPushesDtoOutputPushesInnerStatusEnum,
      ),
    );
    yield r'recipients';
    yield serializers.serialize(
      object.recipients,
      specifiedType: const FullType(int),
    );
    yield r'sent';
    yield serializers.serialize(
      object.sent,
      specifiedType: const FullType(int),
    );
    yield r'delivered';
    yield serializers.serialize(
      object.delivered,
      specifiedType: const FullType(int),
    );
    yield r'sentBy';
    yield serializers.serialize(
      object.sentBy,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'cancelledBy';
    yield object.cancelledBy == null
        ? null
        : serializers.serialize(
            object.cancelledBy,
            specifiedType: const FullType.nullable(String),
          );
    yield r'cancelledAt';
    yield object.cancelledAt == null
        ? null
        : serializers.serialize(
            object.cancelledAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMassPushesDtoOutputPushesInner object, {
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
    required AdminMassPushesDtoOutputPushesInnerBuilder result,
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
        case r'title':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.title = valueDes;
          break;
        case r'body':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.body = valueDes;
          break;
        case r'audience':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminMassPushesDtoOutputPushesInnerAudienceEnum,
                    ),
                  )
                  as AdminMassPushesDtoOutputPushesInnerAudienceEnum;
          result.audience = valueDes;
          break;
        case r'zoneId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.zoneId = valueDes;
          break;
        case r'inactiveDays':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.inactiveDays = valueDes;
          break;
        case r'zoneName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.zoneName = valueDes;
          break;
        case r'target':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminMassPushesDtoOutputPushesInnerTargetEnum,
                    ),
                  )
                  as AdminMassPushesDtoOutputPushesInnerTargetEnum;
          result.target = valueDes;
          break;
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.restaurantId = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.restaurantName = valueDes;
          break;
        case r'codeId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.codeId = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        case r'scheduled':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.scheduled = valueDes;
          break;
        case r'sendAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.sendAt = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminMassPushesDtoOutputPushesInnerStatusEnum,
                    ),
                  )
                  as AdminMassPushesDtoOutputPushesInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'recipients':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.recipients = valueDes;
          break;
        case r'sent':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.sent = valueDes;
          break;
        case r'delivered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.delivered = valueDes;
          break;
        case r'sentBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.sentBy = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'cancelledBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cancelledBy = valueDes;
          break;
        case r'cancelledAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.cancelledAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMassPushesDtoOutputPushesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMassPushesDtoOutputPushesInnerBuilder();
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

/// `all` every registered customer; `zone` those with a saved address in zoneId; `inactive` those whose latest delivered order in the city is older than inactiveDays; `never_ordered` registered with no delivered order in the city.
class AdminMassPushesDtoOutputPushesInnerAudienceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'all')
  static const AdminMassPushesDtoOutputPushesInnerAudienceEnum all =
      _$adminMassPushesDtoOutputPushesInnerAudienceEnum_all;
  @BuiltValueEnumConst(wireName: r'zone')
  static const AdminMassPushesDtoOutputPushesInnerAudienceEnum zone =
      _$adminMassPushesDtoOutputPushesInnerAudienceEnum_zone;
  @BuiltValueEnumConst(wireName: r'inactive')
  static const AdminMassPushesDtoOutputPushesInnerAudienceEnum inactive =
      _$adminMassPushesDtoOutputPushesInnerAudienceEnum_inactive;
  @BuiltValueEnumConst(wireName: r'never_ordered')
  static const AdminMassPushesDtoOutputPushesInnerAudienceEnum neverOrdered =
      _$adminMassPushesDtoOutputPushesInnerAudienceEnum_neverOrdered;

  static Serializer<AdminMassPushesDtoOutputPushesInnerAudienceEnum>
  get serializer => _$adminMassPushesDtoOutputPushesInnerAudienceEnumSerializer;

  const AdminMassPushesDtoOutputPushesInnerAudienceEnum._(String name)
    : super(name);

  static BuiltSet<AdminMassPushesDtoOutputPushesInnerAudienceEnum> get values =>
      _$adminMassPushesDtoOutputPushesInnerAudienceEnumValues;
  static AdminMassPushesDtoOutputPushesInnerAudienceEnum valueOf(String name) =>
      _$adminMassPushesDtoOutputPushesInnerAudienceEnumValueOf(name);
}

/// `home` the home screen; `restaurant` its page (restaurantId); `code` «أكوادي» on that code (codeId).
class AdminMassPushesDtoOutputPushesInnerTargetEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'home')
  static const AdminMassPushesDtoOutputPushesInnerTargetEnum home =
      _$adminMassPushesDtoOutputPushesInnerTargetEnum_home;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminMassPushesDtoOutputPushesInnerTargetEnum restaurant =
      _$adminMassPushesDtoOutputPushesInnerTargetEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'code')
  static const AdminMassPushesDtoOutputPushesInnerTargetEnum code =
      _$adminMassPushesDtoOutputPushesInnerTargetEnum_code;

  static Serializer<AdminMassPushesDtoOutputPushesInnerTargetEnum>
  get serializer => _$adminMassPushesDtoOutputPushesInnerTargetEnumSerializer;

  const AdminMassPushesDtoOutputPushesInnerTargetEnum._(String name)
    : super(name);

  static BuiltSet<AdminMassPushesDtoOutputPushesInnerTargetEnum> get values =>
      _$adminMassPushesDtoOutputPushesInnerTargetEnumValues;
  static AdminMassPushesDtoOutputPushesInnerTargetEnum valueOf(String name) =>
      _$adminMassPushesDtoOutputPushesInnerTargetEnumValueOf(name);
}

class AdminMassPushesDtoOutputPushesInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'scheduled')
  static const AdminMassPushesDtoOutputPushesInnerStatusEnum scheduled =
      _$adminMassPushesDtoOutputPushesInnerStatusEnum_scheduled;
  @BuiltValueEnumConst(wireName: r'sent')
  static const AdminMassPushesDtoOutputPushesInnerStatusEnum sent =
      _$adminMassPushesDtoOutputPushesInnerStatusEnum_sent;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminMassPushesDtoOutputPushesInnerStatusEnum cancelled =
      _$adminMassPushesDtoOutputPushesInnerStatusEnum_cancelled;

  static Serializer<AdminMassPushesDtoOutputPushesInnerStatusEnum>
  get serializer => _$adminMassPushesDtoOutputPushesInnerStatusEnumSerializer;

  const AdminMassPushesDtoOutputPushesInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminMassPushesDtoOutputPushesInnerStatusEnum> get values =>
      _$adminMassPushesDtoOutputPushesInnerStatusEnumValues;
  static AdminMassPushesDtoOutputPushesInnerStatusEnum valueOf(String name) =>
      _$adminMassPushesDtoOutputPushesInnerStatusEnumValueOf(name);
}
