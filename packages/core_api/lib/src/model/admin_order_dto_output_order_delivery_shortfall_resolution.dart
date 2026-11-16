//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_delivery_shortfall_resolution.g.dart';

/// «حلّ النقص» (AP §8.6, slice 2.20b); null while the shortfall is open.
///
/// Properties:
/// * [responsible]
/// * [note] - Operations' required note.
/// * [at]
/// * [by] - The admin who resolved it.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderDeliveryShortfallResolution
    implements
        Built<
          AdminOrderDtoOutputOrderDeliveryShortfallResolution,
          AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder
        > {
  @BuiltValueField(wireName: r'responsible')
  AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
  get responsible;
  // enum responsibleEnum {  captain,  customer,  platform,  };

  /// Operations' required note.
  @BuiltValueField(wireName: r'note')
  String get note;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The admin who resolved it.
  @BuiltValueField(wireName: r'by')
  String get by;

  AdminOrderDtoOutputOrderDeliveryShortfallResolution._();

  factory AdminOrderDtoOutputOrderDeliveryShortfallResolution([
    void updates(AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder b),
  ]) = _$AdminOrderDtoOutputOrderDeliveryShortfallResolution;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderDeliveryShortfallResolution>
  get serializer =>
      _$AdminOrderDtoOutputOrderDeliveryShortfallResolutionSerializer();
}

class _$AdminOrderDtoOutputOrderDeliveryShortfallResolutionSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderDeliveryShortfallResolution
        > {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderDeliveryShortfallResolution,
    _$AdminOrderDtoOutputOrderDeliveryShortfallResolution,
  ];

  @override
  final String wireName =
      r'AdminOrderDtoOutputOrderDeliveryShortfallResolution';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryShortfallResolution object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum,
      ),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'by';
    yield serializers.serialize(
      object.by,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryShortfallResolution object, {
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
    required AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum;
          result.responsible = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'by':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.by = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderDeliveryShortfallResolution deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder();
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

class AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
  captain =
      _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
  customer =
      _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
  platform =
      _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_platform;

  static Serializer<
    AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
  >
  get serializer =>
      _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnumSerializer;

  const AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
  >
  get values =>
      _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnumValues;
  static AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
  valueOf(String name) =>
      _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnumValueOf(
        name,
      );
}
