//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_checklist_dto_output_images_waiver.dart';
import 'package:core_api/src/model/admin_checklist_dto_output_images.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_checklist_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_checklist_dto_output.g.dart';

/// AdminChecklistDtoOutput
///
/// Properties:
/// * [accountStatus]
/// * [items] - AP §9.6.3 step 8, in order.
/// * [canStartTest] - «تشغيل الوضع التجريبي»: every item but the test order is met.
/// * [canActivate] - «تفعيل وإظهار للزبائن»: every item is met.
/// * [images]
/// * [imagesWaiver]
@BuiltValue()
abstract class AdminChecklistDtoOutput
    implements Built<AdminChecklistDtoOutput, AdminChecklistDtoOutputBuilder> {
  @BuiltValueField(wireName: r'accountStatus')
  AdminChecklistDtoOutputAccountStatusEnum get accountStatus;
  // enum accountStatusEnum {  draft,  test,  active,  suspended,  terminated,  };

  /// AP §9.6.3 step 8, in order.
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminChecklistDtoOutputItemsInner> get items;

  /// «تشغيل الوضع التجريبي»: every item but the test order is met.
  @BuiltValueField(wireName: r'canStartTest')
  bool get canStartTest;

  /// «تفعيل وإظهار للزبائن»: every item is met.
  @BuiltValueField(wireName: r'canActivate')
  bool get canActivate;

  @BuiltValueField(wireName: r'images')
  AdminChecklistDtoOutputImages get images;

  @BuiltValueField(wireName: r'imagesWaiver')
  AdminChecklistDtoOutputImagesWaiver? get imagesWaiver;

  AdminChecklistDtoOutput._();

  factory AdminChecklistDtoOutput([
    void updates(AdminChecklistDtoOutputBuilder b),
  ]) = _$AdminChecklistDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChecklistDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChecklistDtoOutput> get serializer =>
      _$AdminChecklistDtoOutputSerializer();
}

class _$AdminChecklistDtoOutputSerializer
    implements PrimitiveSerializer<AdminChecklistDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminChecklistDtoOutput,
    _$AdminChecklistDtoOutput,
  ];

  @override
  final String wireName = r'AdminChecklistDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChecklistDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accountStatus';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(AdminChecklistDtoOutputAccountStatusEnum),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminChecklistDtoOutputItemsInner),
      ]),
    );
    yield r'canStartTest';
    yield serializers.serialize(
      object.canStartTest,
      specifiedType: const FullType(bool),
    );
    yield r'canActivate';
    yield serializers.serialize(
      object.canActivate,
      specifiedType: const FullType(bool),
    );
    yield r'images';
    yield serializers.serialize(
      object.images,
      specifiedType: const FullType(AdminChecklistDtoOutputImages),
    );
    yield r'imagesWaiver';
    yield object.imagesWaiver == null
        ? null
        : serializers.serialize(
            object.imagesWaiver,
            specifiedType: const FullType.nullable(
              AdminChecklistDtoOutputImagesWaiver,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChecklistDtoOutput object, {
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
    required AdminChecklistDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminChecklistDtoOutputAccountStatusEnum,
                    ),
                  )
                  as AdminChecklistDtoOutputAccountStatusEnum;
          result.accountStatus = valueDes;
          break;
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminChecklistDtoOutputItemsInner),
                    ]),
                  )
                  as BuiltList<AdminChecklistDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'canStartTest':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.canStartTest = valueDes;
          break;
        case r'canActivate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.canActivate = valueDes;
          break;
        case r'images':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminChecklistDtoOutputImages,
                    ),
                  )
                  as AdminChecklistDtoOutputImages;
          result.images.replace(valueDes);
          break;
        case r'imagesWaiver':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminChecklistDtoOutputImagesWaiver,
                    ),
                  )
                  as AdminChecklistDtoOutputImagesWaiver?;
          if (valueDes == null) continue;
          result.imagesWaiver.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChecklistDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChecklistDtoOutputBuilder();
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

class AdminChecklistDtoOutputAccountStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminChecklistDtoOutputAccountStatusEnum draft =
      _$adminChecklistDtoOutputAccountStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'test')
  static const AdminChecklistDtoOutputAccountStatusEnum test =
      _$adminChecklistDtoOutputAccountStatusEnum_test;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminChecklistDtoOutputAccountStatusEnum active =
      _$adminChecklistDtoOutputAccountStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminChecklistDtoOutputAccountStatusEnum suspended =
      _$adminChecklistDtoOutputAccountStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminChecklistDtoOutputAccountStatusEnum terminated =
      _$adminChecklistDtoOutputAccountStatusEnum_terminated;

  static Serializer<AdminChecklistDtoOutputAccountStatusEnum> get serializer =>
      _$adminChecklistDtoOutputAccountStatusEnumSerializer;

  const AdminChecklistDtoOutputAccountStatusEnum._(String name) : super(name);

  static BuiltSet<AdminChecklistDtoOutputAccountStatusEnum> get values =>
      _$adminChecklistDtoOutputAccountStatusEnumValues;
  static AdminChecklistDtoOutputAccountStatusEnum valueOf(String name) =>
      _$adminChecklistDtoOutputAccountStatusEnumValueOf(name);
}
