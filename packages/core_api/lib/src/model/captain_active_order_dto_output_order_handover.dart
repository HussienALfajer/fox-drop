//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_handover_captain.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_handover.g.dart';

/// «تسليم لكابتن آخر» (CA §9.10.1, slice 2.12b): the open handover of the order, or null. While giving, the steps wait; while receiving, «لا تدفع شيئاً».
///
/// Properties:
/// * [role] - giving: «سيستلم الكابتن {الاسم} الطلب منك. انتظره في موقعك.»; receiving: step 1 leads to the other captain, «استلمت الطلب من الكابتن {الاسم}» within radii.customerMetres of them.
/// * [assigned] - The second captain has it; false while it is still offered to them.
/// * [captain]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderHandover
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderHandover,
          CaptainActiveOrderDtoOutputOrderHandoverBuilder
        > {
  /// giving: «سيستلم الكابتن {الاسم} الطلب منك. انتظره في موقعك.»; receiving: step 1 leads to the other captain, «استلمت الطلب من الكابتن {الاسم}» within radii.customerMetres of them.
  @BuiltValueField(wireName: r'role')
  CaptainActiveOrderDtoOutputOrderHandoverRoleEnum get role;
  // enum roleEnum {  giving,  receiving,  };

  /// The second captain has it; false while it is still offered to them.
  @BuiltValueField(wireName: r'assigned')
  bool get assigned;

  @BuiltValueField(wireName: r'captain')
  CaptainActiveOrderDtoOutputOrderHandoverCaptain get captain;

  CaptainActiveOrderDtoOutputOrderHandover._();

  factory CaptainActiveOrderDtoOutputOrderHandover([
    void updates(CaptainActiveOrderDtoOutputOrderHandoverBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderHandover;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderHandoverBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderHandover> get serializer =>
      _$CaptainActiveOrderDtoOutputOrderHandoverSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderHandoverSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderHandover> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderHandover,
    _$CaptainActiveOrderDtoOutputOrderHandover,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderHandover';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderHandover object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderHandoverRoleEnum,
      ),
    );
    yield r'assigned';
    yield serializers.serialize(
      object.assigned,
      specifiedType: const FullType(bool),
    );
    yield r'captain';
    yield serializers.serialize(
      object.captain,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderHandoverCaptain,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderHandover object, {
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
    required CaptainActiveOrderDtoOutputOrderHandoverBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderHandoverRoleEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderHandoverRoleEnum;
          result.role = valueDes;
          break;
        case r'assigned':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.assigned = valueDes;
          break;
        case r'captain':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderHandoverCaptain,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderHandoverCaptain;
          result.captain.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderHandover deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderHandoverBuilder();
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

/// giving: «سيستلم الكابتن {الاسم} الطلب منك. انتظره في موقعك.»; receiving: step 1 leads to the other captain, «استلمت الطلب من الكابتن {الاسم}» within radii.customerMetres of them.
class CaptainActiveOrderDtoOutputOrderHandoverRoleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'giving')
  static const CaptainActiveOrderDtoOutputOrderHandoverRoleEnum giving =
      _$captainActiveOrderDtoOutputOrderHandoverRoleEnum_giving;
  @BuiltValueEnumConst(wireName: r'receiving')
  static const CaptainActiveOrderDtoOutputOrderHandoverRoleEnum receiving =
      _$captainActiveOrderDtoOutputOrderHandoverRoleEnum_receiving;

  static Serializer<CaptainActiveOrderDtoOutputOrderHandoverRoleEnum>
  get serializer =>
      _$captainActiveOrderDtoOutputOrderHandoverRoleEnumSerializer;

  const CaptainActiveOrderDtoOutputOrderHandoverRoleEnum._(String name)
    : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputOrderHandoverRoleEnum>
  get values => _$captainActiveOrderDtoOutputOrderHandoverRoleEnumValues;
  static CaptainActiveOrderDtoOutputOrderHandoverRoleEnum valueOf(
    String name,
  ) => _$captainActiveOrderDtoOutputOrderHandoverRoleEnumValueOf(name);
}
