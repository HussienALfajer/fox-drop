//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_availability_dto_output.g.dart';

/// AdminCaptainAvailabilityDtoOutput
///
/// Properties:
/// * [state]
/// * [lastOrderBy] - In last_order: who set it (CA §7.3, §7.6, K18).
@BuiltValue()
abstract class AdminCaptainAvailabilityDtoOutput
    implements
        Built<
          AdminCaptainAvailabilityDtoOutput,
          AdminCaptainAvailabilityDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'state')
  AdminCaptainAvailabilityDtoOutputStateEnum get state;
  // enum stateEnum {  offline,  online_available,  busy,  last_order,  not_receiving_offers,  suspended,  };

  /// In last_order: who set it (CA §7.3, §7.6, K18).
  @BuiltValueField(wireName: r'lastOrderBy')
  AdminCaptainAvailabilityDtoOutputLastOrderByEnum? get lastOrderBy;
  // enum lastOrderByEnum {  captain,  forced,  suspended,  terminated,  };

  AdminCaptainAvailabilityDtoOutput._();

  factory AdminCaptainAvailabilityDtoOutput([
    void updates(AdminCaptainAvailabilityDtoOutputBuilder b),
  ]) = _$AdminCaptainAvailabilityDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainAvailabilityDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainAvailabilityDtoOutput> get serializer =>
      _$AdminCaptainAvailabilityDtoOutputSerializer();
}

class _$AdminCaptainAvailabilityDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainAvailabilityDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainAvailabilityDtoOutput,
    _$AdminCaptainAvailabilityDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainAvailabilityDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainAvailabilityDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(AdminCaptainAvailabilityDtoOutputStateEnum),
    );
    yield r'lastOrderBy';
    yield object.lastOrderBy == null
        ? null
        : serializers.serialize(
            object.lastOrderBy,
            specifiedType: const FullType.nullable(
              AdminCaptainAvailabilityDtoOutputLastOrderByEnum,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainAvailabilityDtoOutput object, {
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
    required AdminCaptainAvailabilityDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainAvailabilityDtoOutputStateEnum,
                    ),
                  )
                  as AdminCaptainAvailabilityDtoOutputStateEnum;
          result.state = valueDes;
          break;
        case r'lastOrderBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainAvailabilityDtoOutputLastOrderByEnum,
                    ),
                  )
                  as AdminCaptainAvailabilityDtoOutputLastOrderByEnum?;
          if (valueDes == null) continue;
          result.lastOrderBy = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainAvailabilityDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainAvailabilityDtoOutputBuilder();
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

class AdminCaptainAvailabilityDtoOutputStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'offline')
  static const AdminCaptainAvailabilityDtoOutputStateEnum offline =
      _$adminCaptainAvailabilityDtoOutputStateEnum_offline;
  @BuiltValueEnumConst(wireName: r'online_available')
  static const AdminCaptainAvailabilityDtoOutputStateEnum onlineAvailable =
      _$adminCaptainAvailabilityDtoOutputStateEnum_onlineAvailable;
  @BuiltValueEnumConst(wireName: r'busy')
  static const AdminCaptainAvailabilityDtoOutputStateEnum busy =
      _$adminCaptainAvailabilityDtoOutputStateEnum_busy;
  @BuiltValueEnumConst(wireName: r'last_order')
  static const AdminCaptainAvailabilityDtoOutputStateEnum lastOrder =
      _$adminCaptainAvailabilityDtoOutputStateEnum_lastOrder;
  @BuiltValueEnumConst(wireName: r'not_receiving_offers')
  static const AdminCaptainAvailabilityDtoOutputStateEnum notReceivingOffers =
      _$adminCaptainAvailabilityDtoOutputStateEnum_notReceivingOffers;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminCaptainAvailabilityDtoOutputStateEnum suspended =
      _$adminCaptainAvailabilityDtoOutputStateEnum_suspended;

  static Serializer<AdminCaptainAvailabilityDtoOutputStateEnum>
  get serializer => _$adminCaptainAvailabilityDtoOutputStateEnumSerializer;

  const AdminCaptainAvailabilityDtoOutputStateEnum._(String name) : super(name);

  static BuiltSet<AdminCaptainAvailabilityDtoOutputStateEnum> get values =>
      _$adminCaptainAvailabilityDtoOutputStateEnumValues;
  static AdminCaptainAvailabilityDtoOutputStateEnum valueOf(String name) =>
      _$adminCaptainAvailabilityDtoOutputStateEnumValueOf(name);
}

/// In last_order: who set it (CA §7.3, §7.6, K18).
class AdminCaptainAvailabilityDtoOutputLastOrderByEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminCaptainAvailabilityDtoOutputLastOrderByEnum captain =
      _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_captain;
  @BuiltValueEnumConst(wireName: r'forced')
  static const AdminCaptainAvailabilityDtoOutputLastOrderByEnum forced =
      _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_forced;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminCaptainAvailabilityDtoOutputLastOrderByEnum suspended =
      _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminCaptainAvailabilityDtoOutputLastOrderByEnum terminated =
      _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_terminated;

  static Serializer<AdminCaptainAvailabilityDtoOutputLastOrderByEnum>
  get serializer =>
      _$adminCaptainAvailabilityDtoOutputLastOrderByEnumSerializer;

  const AdminCaptainAvailabilityDtoOutputLastOrderByEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainAvailabilityDtoOutputLastOrderByEnum>
  get values => _$adminCaptainAvailabilityDtoOutputLastOrderByEnumValues;
  static AdminCaptainAvailabilityDtoOutputLastOrderByEnum valueOf(
    String name,
  ) => _$adminCaptainAvailabilityDtoOutputLastOrderByEnumValueOf(name);
}
