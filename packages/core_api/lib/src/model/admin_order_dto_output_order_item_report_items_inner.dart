//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_item_report_items_inner.g.dart';

/// AdminOrderDtoOutputOrderItemReportItemsInner
///
/// Properties:
/// * [itemId]
/// * [name]
/// * [until] - «حتى الغد» or «حتى أعيده».
@BuiltValue()
abstract class AdminOrderDtoOutputOrderItemReportItemsInner
    implements
        Built<
          AdminOrderDtoOutputOrderItemReportItemsInner,
          AdminOrderDtoOutputOrderItemReportItemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// «حتى الغد» or «حتى أعيده».
  @BuiltValueField(wireName: r'until')
  AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum get until;
  // enum untilEnum {  tomorrow,  turned_back_on,  };

  AdminOrderDtoOutputOrderItemReportItemsInner._();

  factory AdminOrderDtoOutputOrderItemReportItemsInner([
    void updates(AdminOrderDtoOutputOrderItemReportItemsInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderItemReportItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderItemReportItemsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderItemReportItemsInner>
  get serializer => _$AdminOrderDtoOutputOrderItemReportItemsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderItemReportItemsInnerSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderItemReportItemsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderItemReportItemsInner,
    _$AdminOrderDtoOutputOrderItemReportItemsInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderItemReportItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderItemReportItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderItemReportItemsInner object, {
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
    required AdminOrderDtoOutputOrderItemReportItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum;
          result.until = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderItemReportItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderItemReportItemsInnerBuilder();
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

/// «حتى الغد» or «حتى أعيده».
class AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'tomorrow')
  static const AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum tomorrow =
      _$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnum_tomorrow;
  @BuiltValueEnumConst(wireName: r'turned_back_on')
  static const AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum
  turnedBackOn =
      _$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnum_turnedBackOn;

  static Serializer<AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnumSerializer;

  const AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum>
  get values => _$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnumValues;
  static AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnumValueOf(name);
}
