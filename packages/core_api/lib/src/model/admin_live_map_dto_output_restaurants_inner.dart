//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_addresses_inner_location.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_live_map_dto_output_restaurants_inner.g.dart';

/// AdminLiveMapDtoOutputRestaurantsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [location]
/// * [state] - AP §9.4: open and busy green, paused amber, the others grey.
@BuiltValue()
abstract class AdminLiveMapDtoOutputRestaurantsInner
    implements
        Built<
          AdminLiveMapDtoOutputRestaurantsInner,
          AdminLiveMapDtoOutputRestaurantsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'location')
  AdminCustomerDtoOutputAddressesInnerLocation get location;

  /// AP §9.4: open and busy green, paused amber, the others grey.
  @BuiltValueField(wireName: r'state')
  AdminLiveMapDtoOutputRestaurantsInnerStateEnum get state;
  // enum stateEnum {  open,  busy,  paused,  closed,  holiday,  suspended,  };

  AdminLiveMapDtoOutputRestaurantsInner._();

  factory AdminLiveMapDtoOutputRestaurantsInner([
    void updates(AdminLiveMapDtoOutputRestaurantsInnerBuilder b),
  ]) = _$AdminLiveMapDtoOutputRestaurantsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLiveMapDtoOutputRestaurantsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLiveMapDtoOutputRestaurantsInner> get serializer =>
      _$AdminLiveMapDtoOutputRestaurantsInnerSerializer();
}

class _$AdminLiveMapDtoOutputRestaurantsInnerSerializer
    implements PrimitiveSerializer<AdminLiveMapDtoOutputRestaurantsInner> {
  @override
  final Iterable<Type> types = const [
    AdminLiveMapDtoOutputRestaurantsInner,
    _$AdminLiveMapDtoOutputRestaurantsInner,
  ];

  @override
  final String wireName = r'AdminLiveMapDtoOutputRestaurantsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLiveMapDtoOutputRestaurantsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(
        AdminCustomerDtoOutputAddressesInnerLocation,
      ),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        AdminLiveMapDtoOutputRestaurantsInnerStateEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLiveMapDtoOutputRestaurantsInner object, {
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
    required AdminLiveMapDtoOutputRestaurantsInnerBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCustomerDtoOutputAddressesInnerLocation,
                    ),
                  )
                  as AdminCustomerDtoOutputAddressesInnerLocation;
          result.location.replace(valueDes);
          break;
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminLiveMapDtoOutputRestaurantsInnerStateEnum,
                    ),
                  )
                  as AdminLiveMapDtoOutputRestaurantsInnerStateEnum;
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
  AdminLiveMapDtoOutputRestaurantsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLiveMapDtoOutputRestaurantsInnerBuilder();
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

/// AP §9.4: open and busy green, paused amber, the others grey.
class AdminLiveMapDtoOutputRestaurantsInnerStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const AdminLiveMapDtoOutputRestaurantsInnerStateEnum open =
      _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_open;
  @BuiltValueEnumConst(wireName: r'busy')
  static const AdminLiveMapDtoOutputRestaurantsInnerStateEnum busy =
      _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_busy;
  @BuiltValueEnumConst(wireName: r'paused')
  static const AdminLiveMapDtoOutputRestaurantsInnerStateEnum paused =
      _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_paused;
  @BuiltValueEnumConst(wireName: r'closed')
  static const AdminLiveMapDtoOutputRestaurantsInnerStateEnum closed =
      _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_closed;
  @BuiltValueEnumConst(wireName: r'holiday')
  static const AdminLiveMapDtoOutputRestaurantsInnerStateEnum holiday =
      _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_holiday;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminLiveMapDtoOutputRestaurantsInnerStateEnum suspended =
      _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_suspended;

  static Serializer<AdminLiveMapDtoOutputRestaurantsInnerStateEnum>
  get serializer => _$adminLiveMapDtoOutputRestaurantsInnerStateEnumSerializer;

  const AdminLiveMapDtoOutputRestaurantsInnerStateEnum._(String name)
    : super(name);

  static BuiltSet<AdminLiveMapDtoOutputRestaurantsInnerStateEnum> get values =>
      _$adminLiveMapDtoOutputRestaurantsInnerStateEnumValues;
  static AdminLiveMapDtoOutputRestaurantsInnerStateEnum valueOf(String name) =>
      _$adminLiveMapDtoOutputRestaurantsInnerStateEnumValueOf(name);
}
