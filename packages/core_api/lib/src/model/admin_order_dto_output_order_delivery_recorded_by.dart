//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_delivery_recorded_by.g.dart';

/// AdminOrderDtoOutputOrderDeliveryRecordedBy
///
/// Properties:
/// * [type]
/// * [id]
/// * [reason] - Operations' reason.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderDeliveryRecordedBy
    implements
        Built<
          AdminOrderDtoOutputOrderDeliveryRecordedBy,
          AdminOrderDtoOutputOrderDeliveryRecordedByBuilder
        > {
  @BuiltValueField(wireName: r'type')
  AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum get type;
  // enum typeEnum {  captain,  admin,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  /// Operations' reason.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminOrderDtoOutputOrderDeliveryRecordedBy._();

  factory AdminOrderDtoOutputOrderDeliveryRecordedBy([
    void updates(AdminOrderDtoOutputOrderDeliveryRecordedByBuilder b),
  ]) = _$AdminOrderDtoOutputOrderDeliveryRecordedBy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderDeliveryRecordedByBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderDeliveryRecordedBy>
  get serializer => _$AdminOrderDtoOutputOrderDeliveryRecordedBySerializer();
}

class _$AdminOrderDtoOutputOrderDeliveryRecordedBySerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderDeliveryRecordedBy> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderDeliveryRecordedBy,
    _$AdminOrderDtoOutputOrderDeliveryRecordedBy,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderDeliveryRecordedBy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryRecordedBy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum,
      ),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryRecordedBy object, {
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
    required AdminOrderDtoOutputOrderDeliveryRecordedByBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
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
  AdminOrderDtoOutputOrderDeliveryRecordedBy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderDeliveryRecordedByBuilder();
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

class AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum captain =
      _$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnum_captain;
  @BuiltValueEnumConst(wireName: r'admin')
  static const AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum admin =
      _$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnum_admin;

  static Serializer<AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnumSerializer;

  const AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum>
  get values => _$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnumValues;
  static AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnumValueOf(name);
}
