//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_applications_dto_output_applications_inner.g.dart';

/// AdminCaptainApplicationsDtoOutputApplicationsInner
///
/// Properties:
/// * [id]
/// * [fullName]
/// * [vehicle]
/// * [zoneId]
/// * [stage]
/// * [submittedAt]
/// * [updatedAt]
@BuiltValue()
abstract class AdminCaptainApplicationsDtoOutputApplicationsInner
    implements
        Built<
          AdminCaptainApplicationsDtoOutputApplicationsInner,
          AdminCaptainApplicationsDtoOutputApplicationsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'vehicle')
  AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  @BuiltValueField(wireName: r'zoneId')
  String get zoneId;

  @BuiltValueField(wireName: r'stage')
  AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum get stage;
  // enum stageEnum {  draft,  new,  under_review,  interview,  awaiting_kit,  active,  waitlist,  rejected,  };

  @BuiltValueField(wireName: r'submittedAt')
  DateTime get submittedAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  AdminCaptainApplicationsDtoOutputApplicationsInner._();

  factory AdminCaptainApplicationsDtoOutputApplicationsInner([
    void updates(AdminCaptainApplicationsDtoOutputApplicationsInnerBuilder b),
  ]) = _$AdminCaptainApplicationsDtoOutputApplicationsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationsDtoOutputApplicationsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationsDtoOutputApplicationsInner>
  get serializer =>
      _$AdminCaptainApplicationsDtoOutputApplicationsInnerSerializer();
}

class _$AdminCaptainApplicationsDtoOutputApplicationsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainApplicationsDtoOutputApplicationsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationsDtoOutputApplicationsInner,
    _$AdminCaptainApplicationsDtoOutputApplicationsInner,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationsDtoOutputApplicationsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationsDtoOutputApplicationsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(
        AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum,
      ),
    );
    yield r'zoneId';
    yield serializers.serialize(
      object.zoneId,
      specifiedType: const FullType(String),
    );
    yield r'stage';
    yield serializers.serialize(
      object.stage,
      specifiedType: const FullType(
        AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum,
      ),
    );
    yield r'submittedAt';
    yield serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationsDtoOutputApplicationsInner object, {
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
    required AdminCaptainApplicationsDtoOutputApplicationsInnerBuilder result,
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
        case r'fullName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fullName = valueDes;
          break;
        case r'vehicle':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum,
                    ),
                  )
                  as AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum;
          result.vehicle = valueDes;
          break;
        case r'zoneId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.zoneId = valueDes;
          break;
        case r'stage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum,
                    ),
                  )
                  as AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum;
          result.stage = valueDes;
          break;
        case r'submittedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.submittedAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationsDtoOutputApplicationsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationsDtoOutputApplicationsInnerBuilder();
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

class AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'walking')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum
  walking =
      _$adminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum
  bicycle =
      _$adminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum
  motorbike =
      _$adminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum
  car = _$adminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum_car;

  static Serializer<
    AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum
  >
  get serializer =>
      _$adminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnumSerializer;

  const AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum>
  get values =>
      _$adminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnumValues;
  static AdminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationsDtoOutputApplicationsInnerVehicleEnumValueOf(
    name,
  );
}

class AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum
  draft = _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnum_draft;
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum
  new_ = _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnum_new_;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum
  underReview =
      _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnum_underReview;
  @BuiltValueEnumConst(wireName: r'interview')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum
  interview =
      _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnum_interview;
  @BuiltValueEnumConst(wireName: r'awaiting_kit')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum
  awaitingKit =
      _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnum_awaitingKit;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum
  active = _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnum_active;
  @BuiltValueEnumConst(wireName: r'waitlist')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum
  waitlist =
      _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnum_waitlist;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum
  rejected =
      _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnum_rejected;

  static Serializer<AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum>
  get serializer =>
      _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnumSerializer;

  const AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum>
  get values =>
      _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnumValues;
  static AdminCaptainApplicationsDtoOutputApplicationsInnerStageEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationsDtoOutputApplicationsInnerStageEnumValueOf(
    name,
  );
}
