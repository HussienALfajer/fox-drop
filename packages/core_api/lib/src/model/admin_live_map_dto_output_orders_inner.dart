//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_live_map_dto_output_orders_inner_to.dart';
import 'package:core_api/src/model/admin_live_map_dto_output_orders_inner_from.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_live_map_dto_output_orders_inner.g.dart';

/// AdminLiveMapDtoOutputOrdersInner
///
/// Properties:
/// * [id]
/// * [number]
/// * [status]
/// * [restaurantId]
/// * [restaurantName]
/// * [from]
/// * [to]
/// * [captainId]
/// * [assignable] - Accepted or ready, no captain and no open offer: «عيّنه لطلب» lists it.
@BuiltValue()
abstract class AdminLiveMapDtoOutputOrdersInner
    implements
        Built<
          AdminLiveMapDtoOutputOrdersInner,
          AdminLiveMapDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'status')
  AdminLiveMapDtoOutputOrdersInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  };

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  @BuiltValueField(wireName: r'from')
  AdminLiveMapDtoOutputOrdersInnerFrom get from;

  @BuiltValueField(wireName: r'to')
  AdminLiveMapDtoOutputOrdersInnerTo get to;

  @BuiltValueField(wireName: r'captainId')
  String? get captainId;

  /// Accepted or ready, no captain and no open offer: «عيّنه لطلب» lists it.
  @BuiltValueField(wireName: r'assignable')
  bool get assignable;

  AdminLiveMapDtoOutputOrdersInner._();

  factory AdminLiveMapDtoOutputOrdersInner([
    void updates(AdminLiveMapDtoOutputOrdersInnerBuilder b),
  ]) = _$AdminLiveMapDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLiveMapDtoOutputOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLiveMapDtoOutputOrdersInner> get serializer =>
      _$AdminLiveMapDtoOutputOrdersInnerSerializer();
}

class _$AdminLiveMapDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<AdminLiveMapDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    AdminLiveMapDtoOutputOrdersInner,
    _$AdminLiveMapDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'AdminLiveMapDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLiveMapDtoOutputOrdersInner object, {
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
      specifiedType: const FullType(AdminLiveMapDtoOutputOrdersInnerStatusEnum),
    );
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
      specifiedType: const FullType(String),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(AdminLiveMapDtoOutputOrdersInnerFrom),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(AdminLiveMapDtoOutputOrdersInnerTo),
    );
    yield r'captainId';
    yield object.captainId == null
        ? null
        : serializers.serialize(
            object.captainId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'assignable';
    yield serializers.serialize(
      object.assignable,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLiveMapDtoOutputOrdersInner object, {
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
    required AdminLiveMapDtoOutputOrdersInnerBuilder result,
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
                      AdminLiveMapDtoOutputOrdersInnerStatusEnum,
                    ),
                  )
                  as AdminLiveMapDtoOutputOrdersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
          break;
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminLiveMapDtoOutputOrdersInnerFrom,
                    ),
                  )
                  as AdminLiveMapDtoOutputOrdersInnerFrom;
          result.from.replace(valueDes);
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminLiveMapDtoOutputOrdersInnerTo,
                    ),
                  )
                  as AdminLiveMapDtoOutputOrdersInnerTo;
          result.to.replace(valueDes);
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
        case r'assignable':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.assignable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminLiveMapDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLiveMapDtoOutputOrdersInnerBuilder();
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

class AdminLiveMapDtoOutputOrdersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminLiveMapDtoOutputOrdersInnerStatusEnum placed =
      _$adminLiveMapDtoOutputOrdersInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminLiveMapDtoOutputOrdersInnerStatusEnum accepted =
      _$adminLiveMapDtoOutputOrdersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminLiveMapDtoOutputOrdersInnerStatusEnum ready =
      _$adminLiveMapDtoOutputOrdersInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminLiveMapDtoOutputOrdersInnerStatusEnum pickedUp =
      _$adminLiveMapDtoOutputOrdersInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminLiveMapDtoOutputOrdersInnerStatusEnum arrived =
      _$adminLiveMapDtoOutputOrdersInnerStatusEnum_arrived;

  static Serializer<AdminLiveMapDtoOutputOrdersInnerStatusEnum>
  get serializer => _$adminLiveMapDtoOutputOrdersInnerStatusEnumSerializer;

  const AdminLiveMapDtoOutputOrdersInnerStatusEnum._(String name) : super(name);

  static BuiltSet<AdminLiveMapDtoOutputOrdersInnerStatusEnum> get values =>
      _$adminLiveMapDtoOutputOrdersInnerStatusEnumValues;
  static AdminLiveMapDtoOutputOrdersInnerStatusEnum valueOf(String name) =>
      _$adminLiveMapDtoOutputOrdersInnerStatusEnumValueOf(name);
}
