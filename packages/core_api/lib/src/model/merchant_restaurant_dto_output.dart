//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_restaurant_dto_output.g.dart';

/// MerchantRestaurantDtoOutput
///
/// Properties:
/// * [id]
/// * [nameAr]
/// * [nameEn]
/// * [accountStatus]
/// * [suspensionReason] - «حساب مطعمك معلّق: {السبب}…» while suspended (RA §5.5).
/// * [state] - The operating state now (RA §7.1).
/// * [stateUntil] - When a holiday close or a pause ends.
@BuiltValue()
abstract class MerchantRestaurantDtoOutput
    implements
        Built<MerchantRestaurantDtoOutput, MerchantRestaurantDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'nameEn')
  String? get nameEn;

  @BuiltValueField(wireName: r'accountStatus')
  MerchantRestaurantDtoOutputAccountStatusEnum get accountStatus;
  // enum accountStatusEnum {  draft,  test,  active,  suspended,  terminated,  };

  /// «حساب مطعمك معلّق: {السبب}…» while suspended (RA §5.5).
  @BuiltValueField(wireName: r'suspensionReason')
  String? get suspensionReason;

  /// The operating state now (RA §7.1).
  @BuiltValueField(wireName: r'state')
  MerchantRestaurantDtoOutputStateEnum get state;
  // enum stateEnum {  draft,  suspended,  terminated,  holiday,  closed,  paused,  busy,  open,  };

  /// When a holiday close or a pause ends.
  @BuiltValueField(wireName: r'stateUntil')
  DateTime? get stateUntil;

  MerchantRestaurantDtoOutput._();

  factory MerchantRestaurantDtoOutput([
    void updates(MerchantRestaurantDtoOutputBuilder b),
  ]) = _$MerchantRestaurantDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantRestaurantDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantRestaurantDtoOutput> get serializer =>
      _$MerchantRestaurantDtoOutputSerializer();
}

class _$MerchantRestaurantDtoOutputSerializer
    implements PrimitiveSerializer<MerchantRestaurantDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantRestaurantDtoOutput,
    _$MerchantRestaurantDtoOutput,
  ];

  @override
  final String wireName = r'MerchantRestaurantDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantRestaurantDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
    yield r'nameEn';
    yield object.nameEn == null
        ? null
        : serializers.serialize(
            object.nameEn,
            specifiedType: const FullType.nullable(String),
          );
    yield r'accountStatus';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(
        MerchantRestaurantDtoOutputAccountStatusEnum,
      ),
    );
    yield r'suspensionReason';
    yield object.suspensionReason == null
        ? null
        : serializers.serialize(
            object.suspensionReason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(MerchantRestaurantDtoOutputStateEnum),
    );
    yield r'stateUntil';
    yield object.stateUntil == null
        ? null
        : serializers.serialize(
            object.stateUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantRestaurantDtoOutput object, {
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
    required MerchantRestaurantDtoOutputBuilder result,
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
        case r'nameAr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nameAr = valueDes;
          break;
        case r'nameEn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.nameEn = valueDes;
          break;
        case r'accountStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantRestaurantDtoOutputAccountStatusEnum,
                    ),
                  )
                  as MerchantRestaurantDtoOutputAccountStatusEnum;
          result.accountStatus = valueDes;
          break;
        case r'suspensionReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.suspensionReason = valueDes;
          break;
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantRestaurantDtoOutputStateEnum,
                    ),
                  )
                  as MerchantRestaurantDtoOutputStateEnum;
          result.state = valueDes;
          break;
        case r'stateUntil':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.stateUntil = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantRestaurantDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantRestaurantDtoOutputBuilder();
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

class MerchantRestaurantDtoOutputAccountStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const MerchantRestaurantDtoOutputAccountStatusEnum draft =
      _$merchantRestaurantDtoOutputAccountStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'test')
  static const MerchantRestaurantDtoOutputAccountStatusEnum test =
      _$merchantRestaurantDtoOutputAccountStatusEnum_test;
  @BuiltValueEnumConst(wireName: r'active')
  static const MerchantRestaurantDtoOutputAccountStatusEnum active =
      _$merchantRestaurantDtoOutputAccountStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const MerchantRestaurantDtoOutputAccountStatusEnum suspended =
      _$merchantRestaurantDtoOutputAccountStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const MerchantRestaurantDtoOutputAccountStatusEnum terminated =
      _$merchantRestaurantDtoOutputAccountStatusEnum_terminated;

  static Serializer<MerchantRestaurantDtoOutputAccountStatusEnum>
  get serializer => _$merchantRestaurantDtoOutputAccountStatusEnumSerializer;

  const MerchantRestaurantDtoOutputAccountStatusEnum._(String name)
    : super(name);

  static BuiltSet<MerchantRestaurantDtoOutputAccountStatusEnum> get values =>
      _$merchantRestaurantDtoOutputAccountStatusEnumValues;
  static MerchantRestaurantDtoOutputAccountStatusEnum valueOf(String name) =>
      _$merchantRestaurantDtoOutputAccountStatusEnumValueOf(name);
}

/// The operating state now (RA §7.1).
class MerchantRestaurantDtoOutputStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const MerchantRestaurantDtoOutputStateEnum draft =
      _$merchantRestaurantDtoOutputStateEnum_draft;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const MerchantRestaurantDtoOutputStateEnum suspended =
      _$merchantRestaurantDtoOutputStateEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const MerchantRestaurantDtoOutputStateEnum terminated =
      _$merchantRestaurantDtoOutputStateEnum_terminated;
  @BuiltValueEnumConst(wireName: r'holiday')
  static const MerchantRestaurantDtoOutputStateEnum holiday =
      _$merchantRestaurantDtoOutputStateEnum_holiday;
  @BuiltValueEnumConst(wireName: r'closed')
  static const MerchantRestaurantDtoOutputStateEnum closed =
      _$merchantRestaurantDtoOutputStateEnum_closed;
  @BuiltValueEnumConst(wireName: r'paused')
  static const MerchantRestaurantDtoOutputStateEnum paused =
      _$merchantRestaurantDtoOutputStateEnum_paused;
  @BuiltValueEnumConst(wireName: r'busy')
  static const MerchantRestaurantDtoOutputStateEnum busy =
      _$merchantRestaurantDtoOutputStateEnum_busy;
  @BuiltValueEnumConst(wireName: r'open')
  static const MerchantRestaurantDtoOutputStateEnum open =
      _$merchantRestaurantDtoOutputStateEnum_open;

  static Serializer<MerchantRestaurantDtoOutputStateEnum> get serializer =>
      _$merchantRestaurantDtoOutputStateEnumSerializer;

  const MerchantRestaurantDtoOutputStateEnum._(String name) : super(name);

  static BuiltSet<MerchantRestaurantDtoOutputStateEnum> get values =>
      _$merchantRestaurantDtoOutputStateEnumValues;
  static MerchantRestaurantDtoOutputStateEnum valueOf(String name) =>
      _$merchantRestaurantDtoOutputStateEnumValueOf(name);
}
