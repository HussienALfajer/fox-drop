//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_edit_dto_keep_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_edit_dto_add_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_edit_dto.g.dart';

/// AdminEditDto
///
/// Properties:
/// * [keep] - The current lines kept, each with its quantity; a line left out is removed. A raised quantity keeps the unit price and counts as items added.
/// * [add] - Lines added from the restaurant's current menu at current prices, available only (400 invalid_edit). A line whose options change is left out of keep and added again.
/// * [deliveryFee] - A new delivery fee in minor units, or null to keep it (the threshold is not checked again).
/// * [extraPrepMin] - Required exactly when items are added to a ready order: it goes back to accepted with this many minutes from now, and the promised time moves by them (400 invalid_edit otherwise).
/// * [responsible] - After the pickup (picked_up, arrived) only, and required then (400 invalid_edit otherwise; the preview answers without it): who bears the removed items and the lower fee (AP §9.3.3, docs/domain/09), «المطعم», «الكابتن» or «المنصة»; never the customer. After the pickup an edit only removes lines or lowers quantities and lowers the fee.
/// * [version] - The order's version the dialog showed; another is 409 order_state_changed, so the edit is the one previewed.
/// * [reason] - Required (AP §9.3.2): the internal note, never shown to the apps.
@BuiltValue()
abstract class AdminEditDto
    implements Built<AdminEditDto, AdminEditDtoBuilder> {
  /// The current lines kept, each with its quantity; a line left out is removed. A raised quantity keeps the unit price and counts as items added.
  @BuiltValueField(wireName: r'keep')
  BuiltList<AdminEditDtoKeepInner> get keep;

  /// Lines added from the restaurant's current menu at current prices, available only (400 invalid_edit). A line whose options change is left out of keep and added again.
  @BuiltValueField(wireName: r'add')
  BuiltList<AdminEditDtoAddInner> get add;

  /// A new delivery fee in minor units, or null to keep it (the threshold is not checked again).
  @BuiltValueField(wireName: r'deliveryFee')
  String? get deliveryFee;

  /// Required exactly when items are added to a ready order: it goes back to accepted with this many minutes from now, and the promised time moves by them (400 invalid_edit otherwise).
  @BuiltValueField(wireName: r'extraPrepMin')
  int? get extraPrepMin;

  /// After the pickup (picked_up, arrived) only, and required then (400 invalid_edit otherwise; the preview answers without it): who bears the removed items and the lower fee (AP §9.3.3, docs/domain/09), «المطعم», «الكابتن» or «المنصة»; never the customer. After the pickup an edit only removes lines or lowers quantities and lowers the fee.
  @BuiltValueField(wireName: r'responsible')
  AdminEditDtoResponsibleEnum? get responsible;
  // enum responsibleEnum {  restaurant,  captain,  platform,  };

  /// The order's version the dialog showed; another is 409 order_state_changed, so the edit is the one previewed.
  @BuiltValueField(wireName: r'version')
  int get version;

  /// Required (AP §9.3.2): the internal note, never shown to the apps.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminEditDto._();

  factory AdminEditDto([void updates(AdminEditDtoBuilder b)]) = _$AdminEditDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEditDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEditDto> get serializer => _$AdminEditDtoSerializer();
}

class _$AdminEditDtoSerializer implements PrimitiveSerializer<AdminEditDto> {
  @override
  final Iterable<Type> types = const [AdminEditDto, _$AdminEditDto];

  @override
  final String wireName = r'AdminEditDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEditDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'keep';
    yield serializers.serialize(
      object.keep,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminEditDtoKeepInner),
      ]),
    );
    yield r'add';
    yield serializers.serialize(
      object.add,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminEditDtoAddInner),
      ]),
    );
    yield r'deliveryFee';
    yield object.deliveryFee == null
        ? null
        : serializers.serialize(
            object.deliveryFee,
            specifiedType: const FullType.nullable(String),
          );
    yield r'extraPrepMin';
    yield object.extraPrepMin == null
        ? null
        : serializers.serialize(
            object.extraPrepMin,
            specifiedType: const FullType.nullable(int),
          );
    if (object.responsible != null) {
      yield r'responsible';
      yield serializers.serialize(
        object.responsible,
        specifiedType: const FullType.nullable(AdminEditDtoResponsibleEnum),
      );
    }
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEditDto object, {
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
    required AdminEditDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'keep':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminEditDtoKeepInner),
                    ]),
                  )
                  as BuiltList<AdminEditDtoKeepInner>;
          result.keep.replace(valueDes);
          break;
        case r'add':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminEditDtoAddInner),
                    ]),
                  )
                  as BuiltList<AdminEditDtoAddInner>;
          result.add.replace(valueDes);
          break;
        case r'deliveryFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.deliveryFee = valueDes;
          break;
        case r'extraPrepMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.extraPrepMin = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminEditDtoResponsibleEnum,
                    ),
                  )
                  as AdminEditDtoResponsibleEnum?;
          if (valueDes == null) continue;
          result.responsible = valueDes;
          break;
        case r'version':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.version = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
  AdminEditDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEditDtoBuilder();
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

/// After the pickup (picked_up, arrived) only, and required then (400 invalid_edit otherwise; the preview answers without it): who bears the removed items and the lower fee (AP §9.3.3, docs/domain/09), «المطعم», «الكابتن» or «المنصة»; never the customer. After the pickup an edit only removes lines or lowers quantities and lowers the fee.
class AdminEditDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminEditDtoResponsibleEnum restaurant =
      _$adminEditDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminEditDtoResponsibleEnum captain =
      _$adminEditDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminEditDtoResponsibleEnum platform =
      _$adminEditDtoResponsibleEnum_platform;

  static Serializer<AdminEditDtoResponsibleEnum> get serializer =>
      _$adminEditDtoResponsibleEnumSerializer;

  const AdminEditDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminEditDtoResponsibleEnum> get values =>
      _$adminEditDtoResponsibleEnumValues;
  static AdminEditDtoResponsibleEnum valueOf(String name) =>
      _$adminEditDtoResponsibleEnumValueOf(name);
}
