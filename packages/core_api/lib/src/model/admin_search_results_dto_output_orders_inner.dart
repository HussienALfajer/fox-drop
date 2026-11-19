//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_search_results_dto_output_orders_inner.g.dart';

/// AdminSearchResultsDtoOutputOrdersInner
///
/// Properties:
/// * [id]
/// * [number]
/// * [status]
@BuiltValue()
abstract class AdminSearchResultsDtoOutputOrdersInner
    implements
        Built<
          AdminSearchResultsDtoOutputOrdersInner,
          AdminSearchResultsDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'status')
  AdminSearchResultsDtoOutputOrdersInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  AdminSearchResultsDtoOutputOrdersInner._();

  factory AdminSearchResultsDtoOutputOrdersInner([
    void updates(AdminSearchResultsDtoOutputOrdersInnerBuilder b),
  ]) = _$AdminSearchResultsDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSearchResultsDtoOutputOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSearchResultsDtoOutputOrdersInner> get serializer =>
      _$AdminSearchResultsDtoOutputOrdersInnerSerializer();
}

class _$AdminSearchResultsDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<AdminSearchResultsDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    AdminSearchResultsDtoOutputOrdersInner,
    _$AdminSearchResultsDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'AdminSearchResultsDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSearchResultsDtoOutputOrdersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminSearchResultsDtoOutputOrdersInnerStatusEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSearchResultsDtoOutputOrdersInner object, {
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
    required AdminSearchResultsDtoOutputOrdersInnerBuilder result,
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
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSearchResultsDtoOutputOrdersInnerStatusEnum,
                    ),
                  )
                  as AdminSearchResultsDtoOutputOrdersInnerStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSearchResultsDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSearchResultsDtoOutputOrdersInnerBuilder();
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

class AdminSearchResultsDtoOutputOrdersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminSearchResultsDtoOutputOrdersInnerStatusEnum placed =
      _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminSearchResultsDtoOutputOrdersInnerStatusEnum accepted =
      _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminSearchResultsDtoOutputOrdersInnerStatusEnum ready =
      _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminSearchResultsDtoOutputOrdersInnerStatusEnum pickedUp =
      _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminSearchResultsDtoOutputOrdersInnerStatusEnum arrived =
      _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminSearchResultsDtoOutputOrdersInnerStatusEnum delivered =
      _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminSearchResultsDtoOutputOrdersInnerStatusEnum rejected =
      _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminSearchResultsDtoOutputOrdersInnerStatusEnum cancelled =
      _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminSearchResultsDtoOutputOrdersInnerStatusEnum failed =
      _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_failed;

  static Serializer<AdminSearchResultsDtoOutputOrdersInnerStatusEnum>
  get serializer =>
      _$adminSearchResultsDtoOutputOrdersInnerStatusEnumSerializer;

  const AdminSearchResultsDtoOutputOrdersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminSearchResultsDtoOutputOrdersInnerStatusEnum>
  get values => _$adminSearchResultsDtoOutputOrdersInnerStatusEnumValues;
  static AdminSearchResultsDtoOutputOrdersInnerStatusEnum valueOf(
    String name,
  ) => _$adminSearchResultsDtoOutputOrdersInnerStatusEnumValueOf(name);
}
