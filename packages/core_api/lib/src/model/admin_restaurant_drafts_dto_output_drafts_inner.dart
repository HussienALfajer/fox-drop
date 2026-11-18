//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_drafts_dto_output_drafts_inner_steps.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_drafts_dto_output_drafts_inner.g.dart';

/// AdminRestaurantDraftsDtoOutputDraftsInner
///
/// Properties:
/// * [id]
/// * [nameAr]
/// * [accountStatus] - A draft, or a restaurant in test mode waiting for its activation (step 8).
/// * [steps]
/// * [createdAt]
/// * [updatedAt]
@BuiltValue()
abstract class AdminRestaurantDraftsDtoOutputDraftsInner
    implements
        Built<
          AdminRestaurantDraftsDtoOutputDraftsInner,
          AdminRestaurantDraftsDtoOutputDraftsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  /// A draft, or a restaurant in test mode waiting for its activation (step 8).
  @BuiltValueField(wireName: r'accountStatus')
  AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum get accountStatus;
  // enum accountStatusEnum {  draft,  test,  };

  @BuiltValueField(wireName: r'steps')
  AdminRestaurantDraftsDtoOutputDraftsInnerSteps get steps;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  AdminRestaurantDraftsDtoOutputDraftsInner._();

  factory AdminRestaurantDraftsDtoOutputDraftsInner([
    void updates(AdminRestaurantDraftsDtoOutputDraftsInnerBuilder b),
  ]) = _$AdminRestaurantDraftsDtoOutputDraftsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDraftsDtoOutputDraftsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftsDtoOutputDraftsInner> get serializer =>
      _$AdminRestaurantDraftsDtoOutputDraftsInnerSerializer();
}

class _$AdminRestaurantDraftsDtoOutputDraftsInnerSerializer
    implements PrimitiveSerializer<AdminRestaurantDraftsDtoOutputDraftsInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftsDtoOutputDraftsInner,
    _$AdminRestaurantDraftsDtoOutputDraftsInner,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftsDtoOutputDraftsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftsDtoOutputDraftsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
    yield r'accountStatus';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(
        AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum,
      ),
    );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(
        AdminRestaurantDraftsDtoOutputDraftsInnerSteps,
      ),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
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
    AdminRestaurantDraftsDtoOutputDraftsInner object, {
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
    required AdminRestaurantDraftsDtoOutputDraftsInnerBuilder result,
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
        case r'nameAr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nameAr = valueDes;
          break;
        case r'accountStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum,
                    ),
                  )
                  as AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum;
          result.accountStatus = valueDes;
          break;
        case r'steps':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantDraftsDtoOutputDraftsInnerSteps,
                    ),
                  )
                  as AdminRestaurantDraftsDtoOutputDraftsInnerSteps;
          result.steps.replace(valueDes);
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
  AdminRestaurantDraftsDtoOutputDraftsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftsDtoOutputDraftsInnerBuilder();
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

/// A draft, or a restaurant in test mode waiting for its activation (step 8).
class AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum
  draft = _$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'test')
  static const AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum test =
      _$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum_test;

  static Serializer<AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum>
  get serializer =>
      _$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnumSerializer;

  const AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum>
  get values =>
      _$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnumValues;
  static AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum valueOf(
    String name,
  ) =>
      _$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnumValueOf(name);
}
