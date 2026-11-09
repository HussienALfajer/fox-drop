//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_status_dto_output_busy_mode.dart';
import 'package:core_api/src/model/merchant_status_dto_output_holiday.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_status_dto_output.g.dart';

/// MerchantStatusDtoOutput
///
/// Properties:
/// * [state] - The operating state now (RA §7.1).
/// * [pauseSource] - Who paused it while paused: the restaurant’s own buttons work only for «restaurant» (RA §7.2).
/// * [stateUntil] - When a holiday close or a pause ends.
/// * [closesAt] - Inside an opening period, when it ends: «يغلق اليوم 11:30 م» (RA §7.2).
/// * [opensAt] - Closed by the schedule, when it next opens.
/// * [busyMode]
/// * [activeOrders] - Orders in placed, accepted or ready, counted only against a maximum (RA §7.4).
/// * [maxActiveOrders]
/// * [holiday]
/// * [pauseChoicesMin] - «إيقاف 15 د», «30 د», «60 د» (RA §7.2).
/// * [busyExtraOptionsMin] - merchant.busy_extra_options_min.
/// * [busyReminderMin] - merchant.busy_mode_reminder_min (RA §7.3).
@BuiltValue()
abstract class MerchantStatusDtoOutput
    implements Built<MerchantStatusDtoOutput, MerchantStatusDtoOutputBuilder> {
  /// The operating state now (RA §7.1).
  @BuiltValueField(wireName: r'state')
  MerchantStatusDtoOutputStateEnum get state;
  // enum stateEnum {  draft,  suspended,  terminated,  holiday,  closed,  paused,  busy,  open,  };

  /// Who paused it while paused: the restaurant’s own buttons work only for «restaurant» (RA §7.2).
  @BuiltValueField(wireName: r'pauseSource')
  MerchantStatusDtoOutputPauseSourceEnum? get pauseSource;
  // enum pauseSourceEnum {  restaurant,  ops,  auto,  };

  /// When a holiday close or a pause ends.
  @BuiltValueField(wireName: r'stateUntil')
  DateTime? get stateUntil;

  /// Inside an opening period, when it ends: «يغلق اليوم 11:30 م» (RA §7.2).
  @BuiltValueField(wireName: r'closesAt')
  DateTime? get closesAt;

  /// Closed by the schedule, when it next opens.
  @BuiltValueField(wireName: r'opensAt')
  DateTime? get opensAt;

  @BuiltValueField(wireName: r'busyMode')
  MerchantStatusDtoOutputBusyMode? get busyMode;

  /// Orders in placed, accepted or ready, counted only against a maximum (RA §7.4).
  @BuiltValueField(wireName: r'activeOrders')
  int? get activeOrders;

  @BuiltValueField(wireName: r'maxActiveOrders')
  int? get maxActiveOrders;

  @BuiltValueField(wireName: r'holiday')
  MerchantStatusDtoOutputHoliday? get holiday;

  /// «إيقاف 15 د», «30 د», «60 د» (RA §7.2).
  @BuiltValueField(wireName: r'pauseChoicesMin')
  BuiltList<int> get pauseChoicesMin;

  /// merchant.busy_extra_options_min.
  @BuiltValueField(wireName: r'busyExtraOptionsMin')
  BuiltList<int> get busyExtraOptionsMin;

  /// merchant.busy_mode_reminder_min (RA §7.3).
  @BuiltValueField(wireName: r'busyReminderMin')
  int get busyReminderMin;

  MerchantStatusDtoOutput._();

  factory MerchantStatusDtoOutput([
    void updates(MerchantStatusDtoOutputBuilder b),
  ]) = _$MerchantStatusDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantStatusDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStatusDtoOutput> get serializer =>
      _$MerchantStatusDtoOutputSerializer();
}

class _$MerchantStatusDtoOutputSerializer
    implements PrimitiveSerializer<MerchantStatusDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantStatusDtoOutput,
    _$MerchantStatusDtoOutput,
  ];

  @override
  final String wireName = r'MerchantStatusDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStatusDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(MerchantStatusDtoOutputStateEnum),
    );
    yield r'pauseSource';
    yield object.pauseSource == null
        ? null
        : serializers.serialize(
            object.pauseSource,
            specifiedType: const FullType.nullable(
              MerchantStatusDtoOutputPauseSourceEnum,
            ),
          );
    yield r'stateUntil';
    yield object.stateUntil == null
        ? null
        : serializers.serialize(
            object.stateUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'closesAt';
    yield object.closesAt == null
        ? null
        : serializers.serialize(
            object.closesAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'opensAt';
    yield object.opensAt == null
        ? null
        : serializers.serialize(
            object.opensAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'busyMode';
    yield object.busyMode == null
        ? null
        : serializers.serialize(
            object.busyMode,
            specifiedType: const FullType.nullable(
              MerchantStatusDtoOutputBusyMode,
            ),
          );
    yield r'activeOrders';
    yield object.activeOrders == null
        ? null
        : serializers.serialize(
            object.activeOrders,
            specifiedType: const FullType.nullable(int),
          );
    yield r'maxActiveOrders';
    yield object.maxActiveOrders == null
        ? null
        : serializers.serialize(
            object.maxActiveOrders,
            specifiedType: const FullType.nullable(int),
          );
    yield r'holiday';
    yield object.holiday == null
        ? null
        : serializers.serialize(
            object.holiday,
            specifiedType: const FullType.nullable(
              MerchantStatusDtoOutputHoliday,
            ),
          );
    yield r'pauseChoicesMin';
    yield serializers.serialize(
      object.pauseChoicesMin,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'busyExtraOptionsMin';
    yield serializers.serialize(
      object.busyExtraOptionsMin,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'busyReminderMin';
    yield serializers.serialize(
      object.busyReminderMin,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatusDtoOutput object, {
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
    required MerchantStatusDtoOutputBuilder result,
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
                      MerchantStatusDtoOutputStateEnum,
                    ),
                  )
                  as MerchantStatusDtoOutputStateEnum;
          result.state = valueDes;
          break;
        case r'pauseSource':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantStatusDtoOutputPauseSourceEnum,
                    ),
                  )
                  as MerchantStatusDtoOutputPauseSourceEnum?;
          if (valueDes == null) continue;
          result.pauseSource = valueDes;
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
        case r'closesAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.closesAt = valueDes;
          break;
        case r'opensAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        case r'busyMode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantStatusDtoOutputBusyMode,
                    ),
                  )
                  as MerchantStatusDtoOutputBusyMode?;
          if (valueDes == null) continue;
          result.busyMode.replace(valueDes);
          break;
        case r'activeOrders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.activeOrders = valueDes;
          break;
        case r'maxActiveOrders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.maxActiveOrders = valueDes;
          break;
        case r'holiday':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantStatusDtoOutputHoliday,
                    ),
                  )
                  as MerchantStatusDtoOutputHoliday?;
          if (valueDes == null) continue;
          result.holiday.replace(valueDes);
          break;
        case r'pauseChoicesMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [FullType(int)]),
                  )
                  as BuiltList<int>;
          result.pauseChoicesMin.replace(valueDes);
          break;
        case r'busyExtraOptionsMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [FullType(int)]),
                  )
                  as BuiltList<int>;
          result.busyExtraOptionsMin.replace(valueDes);
          break;
        case r'busyReminderMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.busyReminderMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStatusDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantStatusDtoOutputBuilder();
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

/// The operating state now (RA §7.1).
class MerchantStatusDtoOutputStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const MerchantStatusDtoOutputStateEnum draft =
      _$merchantStatusDtoOutputStateEnum_draft;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const MerchantStatusDtoOutputStateEnum suspended =
      _$merchantStatusDtoOutputStateEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const MerchantStatusDtoOutputStateEnum terminated =
      _$merchantStatusDtoOutputStateEnum_terminated;
  @BuiltValueEnumConst(wireName: r'holiday')
  static const MerchantStatusDtoOutputStateEnum holiday =
      _$merchantStatusDtoOutputStateEnum_holiday;
  @BuiltValueEnumConst(wireName: r'closed')
  static const MerchantStatusDtoOutputStateEnum closed =
      _$merchantStatusDtoOutputStateEnum_closed;
  @BuiltValueEnumConst(wireName: r'paused')
  static const MerchantStatusDtoOutputStateEnum paused =
      _$merchantStatusDtoOutputStateEnum_paused;
  @BuiltValueEnumConst(wireName: r'busy')
  static const MerchantStatusDtoOutputStateEnum busy =
      _$merchantStatusDtoOutputStateEnum_busy;
  @BuiltValueEnumConst(wireName: r'open')
  static const MerchantStatusDtoOutputStateEnum open =
      _$merchantStatusDtoOutputStateEnum_open;

  static Serializer<MerchantStatusDtoOutputStateEnum> get serializer =>
      _$merchantStatusDtoOutputStateEnumSerializer;

  const MerchantStatusDtoOutputStateEnum._(String name) : super(name);

  static BuiltSet<MerchantStatusDtoOutputStateEnum> get values =>
      _$merchantStatusDtoOutputStateEnumValues;
  static MerchantStatusDtoOutputStateEnum valueOf(String name) =>
      _$merchantStatusDtoOutputStateEnumValueOf(name);
}

/// Who paused it while paused: the restaurant’s own buttons work only for «restaurant» (RA §7.2).
class MerchantStatusDtoOutputPauseSourceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const MerchantStatusDtoOutputPauseSourceEnum restaurant =
      _$merchantStatusDtoOutputPauseSourceEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'ops')
  static const MerchantStatusDtoOutputPauseSourceEnum ops =
      _$merchantStatusDtoOutputPauseSourceEnum_ops;
  @BuiltValueEnumConst(wireName: r'auto')
  static const MerchantStatusDtoOutputPauseSourceEnum auto =
      _$merchantStatusDtoOutputPauseSourceEnum_auto;

  static Serializer<MerchantStatusDtoOutputPauseSourceEnum> get serializer =>
      _$merchantStatusDtoOutputPauseSourceEnumSerializer;

  const MerchantStatusDtoOutputPauseSourceEnum._(String name) : super(name);

  static BuiltSet<MerchantStatusDtoOutputPauseSourceEnum> get values =>
      _$merchantStatusDtoOutputPauseSourceEnumValues;
  static MerchantStatusDtoOutputPauseSourceEnum valueOf(String name) =>
      _$merchantStatusDtoOutputPauseSourceEnumValueOf(name);
}
