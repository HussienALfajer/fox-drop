//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_duplicates_inner.g.dart';

/// AdminCaptainApplicationDtoOutputDuplicatesInner
///
/// Properties:
/// * [field]
/// * [applicationId]
/// * [captainId]
/// * [fullName]
/// * [stage]
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputDuplicatesInner
    implements
        Built<
          AdminCaptainApplicationDtoOutputDuplicatesInner,
          AdminCaptainApplicationDtoOutputDuplicatesInnerBuilder
        > {
  @BuiltValueField(wireName: r'field')
  AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum get field;
  // enum fieldEnum {  id_number,  phone,  plate,  };

  @BuiltValueField(wireName: r'applicationId')
  String? get applicationId;

  @BuiltValueField(wireName: r'captainId')
  String? get captainId;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'stage')
  AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum? get stage;
  // enum stageEnum {  draft,  new,  under_review,  interview,  awaiting_kit,  active,  waitlist,  rejected,  };

  AdminCaptainApplicationDtoOutputDuplicatesInner._();

  factory AdminCaptainApplicationDtoOutputDuplicatesInner([
    void updates(AdminCaptainApplicationDtoOutputDuplicatesInnerBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputDuplicatesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationDtoOutputDuplicatesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputDuplicatesInner>
  get serializer =>
      _$AdminCaptainApplicationDtoOutputDuplicatesInnerSerializer();
}

class _$AdminCaptainApplicationDtoOutputDuplicatesInnerSerializer
    implements
        PrimitiveSerializer<AdminCaptainApplicationDtoOutputDuplicatesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputDuplicatesInner,
    _$AdminCaptainApplicationDtoOutputDuplicatesInner,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputDuplicatesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputDuplicatesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'field';
    yield serializers.serialize(
      object.field,
      specifiedType: const FullType(
        AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum,
      ),
    );
    yield r'applicationId';
    yield object.applicationId == null
        ? null
        : serializers.serialize(
            object.applicationId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'captainId';
    yield object.captainId == null
        ? null
        : serializers.serialize(
            object.captainId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'stage';
    yield object.stage == null
        ? null
        : serializers.serialize(
            object.stage,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputDuplicatesInner object, {
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
    required AdminCaptainApplicationDtoOutputDuplicatesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'field':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum;
          result.field = valueDes;
          break;
        case r'applicationId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.applicationId = valueDes;
          break;
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.captainId = valueDes;
          break;
        case r'fullName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fullName = valueDes;
          break;
        case r'stage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum?;
          if (valueDes == null) continue;
          result.stage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputDuplicatesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputDuplicatesInnerBuilder();
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

class AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'id_number')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum
  idNumber =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum_idNumber;
  @BuiltValueEnumConst(wireName: r'phone')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum phone =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum_phone;
  @BuiltValueEnumConst(wireName: r'plate')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum plate =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum_plate;

  static Serializer<AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputDuplicatesInnerFieldEnumSerializer;

  const AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum>
  get values =>
      _$adminCaptainApplicationDtoOutputDuplicatesInnerFieldEnumValues;
  static AdminCaptainApplicationDtoOutputDuplicatesInnerFieldEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputDuplicatesInnerFieldEnumValueOf(name);
}

class AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum draft =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnum_draft;
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum new_ =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnum_new_;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum
  underReview =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnum_underReview;
  @BuiltValueEnumConst(wireName: r'interview')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum
  interview =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnum_interview;
  @BuiltValueEnumConst(wireName: r'awaiting_kit')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum
  awaitingKit =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnum_awaitingKit;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum active =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnum_active;
  @BuiltValueEnumConst(wireName: r'waitlist')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum
  waitlist =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnum_waitlist;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum
  rejected =
      _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnum_rejected;

  static Serializer<AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnumSerializer;

  const AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum>
  get values =>
      _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnumValues;
  static AdminCaptainApplicationDtoOutputDuplicatesInnerStageEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputDuplicatesInnerStageEnumValueOf(name);
}
