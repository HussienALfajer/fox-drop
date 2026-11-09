//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/sender_pool_dto_output_numbers_inner_today.dart';
import 'package:core_api/src/model/sender_pool_dto_output_numbers_inner_warmup.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sender_pool_dto_output_numbers_inner.g.dart';

/// SenderPoolDtoOutputNumbersInner
///
/// Properties:
/// * [id] 
/// * [phone] - The sending number, E.164.
/// * [status] 
/// * [connected] - Whether its WhatsApp session is open now.
/// * [pairedAt] 
/// * [stoppedAt] - When WhatsApp disconnected or banned it.
/// * [throttledUntil] 
/// * [warmup] 
/// * [dailyCap] - Sends it may attempt today, failed ones included.
/// * [today] 
@BuiltValue()
abstract class SenderPoolDtoOutputNumbersInner implements Built<SenderPoolDtoOutputNumbersInner, SenderPoolDtoOutputNumbersInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// The sending number, E.164.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'status')
  SenderPoolDtoOutputNumbersInnerStatusEnum get status;
  // enum statusEnum {  warming,  active,  standby,  throttled,  disconnected,  banned,  };

  /// Whether its WhatsApp session is open now.
  @BuiltValueField(wireName: r'connected')
  bool get connected;

  @BuiltValueField(wireName: r'pairedAt')
  DateTime get pairedAt;

  /// When WhatsApp disconnected or banned it.
  @BuiltValueField(wireName: r'stoppedAt')
  DateTime? get stoppedAt;

  @BuiltValueField(wireName: r'throttledUntil')
  DateTime? get throttledUntil;

  @BuiltValueField(wireName: r'warmup')
  SenderPoolDtoOutputNumbersInnerWarmup? get warmup;

  /// Sends it may attempt today, failed ones included.
  @BuiltValueField(wireName: r'dailyCap')
  int get dailyCap;

  @BuiltValueField(wireName: r'today')
  SenderPoolDtoOutputNumbersInnerToday get today;

  SenderPoolDtoOutputNumbersInner._();

  factory SenderPoolDtoOutputNumbersInner([void updates(SenderPoolDtoOutputNumbersInnerBuilder b)]) = _$SenderPoolDtoOutputNumbersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SenderPoolDtoOutputNumbersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SenderPoolDtoOutputNumbersInner> get serializer => _$SenderPoolDtoOutputNumbersInnerSerializer();
}

class _$SenderPoolDtoOutputNumbersInnerSerializer implements PrimitiveSerializer<SenderPoolDtoOutputNumbersInner> {
  @override
  final Iterable<Type> types = const [SenderPoolDtoOutputNumbersInner, _$SenderPoolDtoOutputNumbersInner];

  @override
  final String wireName = r'SenderPoolDtoOutputNumbersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SenderPoolDtoOutputNumbersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SenderPoolDtoOutputNumbersInnerStatusEnum),
    );
    yield r'connected';
    yield serializers.serialize(
      object.connected,
      specifiedType: const FullType(bool),
    );
    yield r'pairedAt';
    yield serializers.serialize(
      object.pairedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'stoppedAt';
    yield object.stoppedAt == null ? null : serializers.serialize(
      object.stoppedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'throttledUntil';
    yield object.throttledUntil == null ? null : serializers.serialize(
      object.throttledUntil,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'warmup';
    yield object.warmup == null ? null : serializers.serialize(
      object.warmup,
      specifiedType: const FullType.nullable(SenderPoolDtoOutputNumbersInnerWarmup),
    );
    yield r'dailyCap';
    yield serializers.serialize(
      object.dailyCap,
      specifiedType: const FullType(int),
    );
    yield r'today';
    yield serializers.serialize(
      object.today,
      specifiedType: const FullType(SenderPoolDtoOutputNumbersInnerToday),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputNumbersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SenderPoolDtoOutputNumbersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SenderPoolDtoOutputNumbersInnerStatusEnum),
          ) as SenderPoolDtoOutputNumbersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'connected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.connected = valueDes;
          break;
        case r'pairedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.pairedAt = valueDes;
          break;
        case r'stoppedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.stoppedAt = valueDes;
          break;
        case r'throttledUntil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.throttledUntil = valueDes;
          break;
        case r'warmup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SenderPoolDtoOutputNumbersInnerWarmup),
          ) as SenderPoolDtoOutputNumbersInnerWarmup?;
          if (valueDes == null) continue;
          result.warmup.replace(valueDes);
          break;
        case r'dailyCap':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dailyCap = valueDes;
          break;
        case r'today':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SenderPoolDtoOutputNumbersInnerToday),
          ) as SenderPoolDtoOutputNumbersInnerToday;
          result.today.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SenderPoolDtoOutputNumbersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SenderPoolDtoOutputNumbersInnerBuilder();
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


class SenderPoolDtoOutputNumbersInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'warming')
  static const SenderPoolDtoOutputNumbersInnerStatusEnum warming = _$senderPoolDtoOutputNumbersInnerStatusEnum_warming;
  @BuiltValueEnumConst(wireName: r'active')
  static const SenderPoolDtoOutputNumbersInnerStatusEnum active = _$senderPoolDtoOutputNumbersInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'standby')
  static const SenderPoolDtoOutputNumbersInnerStatusEnum standby = _$senderPoolDtoOutputNumbersInnerStatusEnum_standby;
  @BuiltValueEnumConst(wireName: r'throttled')
  static const SenderPoolDtoOutputNumbersInnerStatusEnum throttled = _$senderPoolDtoOutputNumbersInnerStatusEnum_throttled;
  @BuiltValueEnumConst(wireName: r'disconnected')
  static const SenderPoolDtoOutputNumbersInnerStatusEnum disconnected = _$senderPoolDtoOutputNumbersInnerStatusEnum_disconnected;
  @BuiltValueEnumConst(wireName: r'banned')
  static const SenderPoolDtoOutputNumbersInnerStatusEnum banned = _$senderPoolDtoOutputNumbersInnerStatusEnum_banned;

  static Serializer<SenderPoolDtoOutputNumbersInnerStatusEnum> get serializer => _$senderPoolDtoOutputNumbersInnerStatusEnumSerializer;

  const SenderPoolDtoOutputNumbersInnerStatusEnum._(String name): super(name);

  static BuiltSet<SenderPoolDtoOutputNumbersInnerStatusEnum> get values => _$senderPoolDtoOutputNumbersInnerStatusEnumValues;
  static SenderPoolDtoOutputNumbersInnerStatusEnum valueOf(String name) => _$senderPoolDtoOutputNumbersInnerStatusEnumValueOf(name);
}

