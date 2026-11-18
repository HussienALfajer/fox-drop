//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_checklist_dto_output_items_inner.g.dart';

/// AdminChecklistDtoOutputItemsInner
///
/// Properties:
/// * [code]
/// * [state] - `waived`: the image rule under OWN's waiver; `not_available`: the device check, «غير متاح بعد» until 2.42, never blocking.
@BuiltValue()
abstract class AdminChecklistDtoOutputItemsInner
    implements
        Built<
          AdminChecklistDtoOutputItemsInner,
          AdminChecklistDtoOutputItemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  AdminChecklistDtoOutputItemsInnerCodeEnum get code;
  // enum codeEnum {  record,  commission,  contract,  hours,  menu,  menu_images,  owner_account,  device_check,  test_order,  };

  /// `waived`: the image rule under OWN's waiver; `not_available`: the device check, «غير متاح بعد» until 2.42, never blocking.
  @BuiltValueField(wireName: r'state')
  AdminChecklistDtoOutputItemsInnerStateEnum get state;
  // enum stateEnum {  met,  missing,  waived,  not_available,  };

  AdminChecklistDtoOutputItemsInner._();

  factory AdminChecklistDtoOutputItemsInner([
    void updates(AdminChecklistDtoOutputItemsInnerBuilder b),
  ]) = _$AdminChecklistDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChecklistDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChecklistDtoOutputItemsInner> get serializer =>
      _$AdminChecklistDtoOutputItemsInnerSerializer();
}

class _$AdminChecklistDtoOutputItemsInnerSerializer
    implements PrimitiveSerializer<AdminChecklistDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [
    AdminChecklistDtoOutputItemsInner,
    _$AdminChecklistDtoOutputItemsInner,
  ];

  @override
  final String wireName = r'AdminChecklistDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChecklistDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(AdminChecklistDtoOutputItemsInnerCodeEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(AdminChecklistDtoOutputItemsInnerStateEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChecklistDtoOutputItemsInner object, {
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
    required AdminChecklistDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminChecklistDtoOutputItemsInnerCodeEnum,
                    ),
                  )
                  as AdminChecklistDtoOutputItemsInnerCodeEnum;
          result.code = valueDes;
          break;
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminChecklistDtoOutputItemsInnerStateEnum,
                    ),
                  )
                  as AdminChecklistDtoOutputItemsInnerStateEnum;
          result.state = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChecklistDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChecklistDtoOutputItemsInnerBuilder();
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

class AdminChecklistDtoOutputItemsInnerCodeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'record')
  static const AdminChecklistDtoOutputItemsInnerCodeEnum record =
      _$adminChecklistDtoOutputItemsInnerCodeEnum_record;
  @BuiltValueEnumConst(wireName: r'commission')
  static const AdminChecklistDtoOutputItemsInnerCodeEnum commission =
      _$adminChecklistDtoOutputItemsInnerCodeEnum_commission;
  @BuiltValueEnumConst(wireName: r'contract')
  static const AdminChecklistDtoOutputItemsInnerCodeEnum contract =
      _$adminChecklistDtoOutputItemsInnerCodeEnum_contract;
  @BuiltValueEnumConst(wireName: r'hours')
  static const AdminChecklistDtoOutputItemsInnerCodeEnum hours =
      _$adminChecklistDtoOutputItemsInnerCodeEnum_hours;
  @BuiltValueEnumConst(wireName: r'menu')
  static const AdminChecklistDtoOutputItemsInnerCodeEnum menu =
      _$adminChecklistDtoOutputItemsInnerCodeEnum_menu;
  @BuiltValueEnumConst(wireName: r'menu_images')
  static const AdminChecklistDtoOutputItemsInnerCodeEnum menuImages =
      _$adminChecklistDtoOutputItemsInnerCodeEnum_menuImages;
  @BuiltValueEnumConst(wireName: r'owner_account')
  static const AdminChecklistDtoOutputItemsInnerCodeEnum ownerAccount =
      _$adminChecklistDtoOutputItemsInnerCodeEnum_ownerAccount;
  @BuiltValueEnumConst(wireName: r'device_check')
  static const AdminChecklistDtoOutputItemsInnerCodeEnum deviceCheck =
      _$adminChecklistDtoOutputItemsInnerCodeEnum_deviceCheck;
  @BuiltValueEnumConst(wireName: r'test_order')
  static const AdminChecklistDtoOutputItemsInnerCodeEnum testOrder =
      _$adminChecklistDtoOutputItemsInnerCodeEnum_testOrder;

  static Serializer<AdminChecklistDtoOutputItemsInnerCodeEnum> get serializer =>
      _$adminChecklistDtoOutputItemsInnerCodeEnumSerializer;

  const AdminChecklistDtoOutputItemsInnerCodeEnum._(String name) : super(name);

  static BuiltSet<AdminChecklistDtoOutputItemsInnerCodeEnum> get values =>
      _$adminChecklistDtoOutputItemsInnerCodeEnumValues;
  static AdminChecklistDtoOutputItemsInnerCodeEnum valueOf(String name) =>
      _$adminChecklistDtoOutputItemsInnerCodeEnumValueOf(name);
}

/// `waived`: the image rule under OWN's waiver; `not_available`: the device check, «غير متاح بعد» until 2.42, never blocking.
class AdminChecklistDtoOutputItemsInnerStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'met')
  static const AdminChecklistDtoOutputItemsInnerStateEnum met =
      _$adminChecklistDtoOutputItemsInnerStateEnum_met;
  @BuiltValueEnumConst(wireName: r'missing')
  static const AdminChecklistDtoOutputItemsInnerStateEnum missing =
      _$adminChecklistDtoOutputItemsInnerStateEnum_missing;
  @BuiltValueEnumConst(wireName: r'waived')
  static const AdminChecklistDtoOutputItemsInnerStateEnum waived =
      _$adminChecklistDtoOutputItemsInnerStateEnum_waived;
  @BuiltValueEnumConst(wireName: r'not_available')
  static const AdminChecklistDtoOutputItemsInnerStateEnum notAvailable =
      _$adminChecklistDtoOutputItemsInnerStateEnum_notAvailable;

  static Serializer<AdminChecklistDtoOutputItemsInnerStateEnum>
  get serializer => _$adminChecklistDtoOutputItemsInnerStateEnumSerializer;

  const AdminChecklistDtoOutputItemsInnerStateEnum._(String name) : super(name);

  static BuiltSet<AdminChecklistDtoOutputItemsInnerStateEnum> get values =>
      _$adminChecklistDtoOutputItemsInnerStateEnumValues;
  static AdminChecklistDtoOutputItemsInnerStateEnum valueOf(String name) =>
      _$adminChecklistDtoOutputItemsInnerStateEnumValueOf(name);
}
