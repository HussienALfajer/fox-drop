//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_cancelled.g.dart';

/// The latest order operations cancelled within 12 hours that the captain has not acknowledged (POST …/acknowledge-cancellation); the app plays the cancellation sound when one appears.
///
/// Properties:
/// * [orderId]
/// * [number] - Shown as #10423 (AP §4.8).
/// * [reason] - {السبب} of «أُلغيت المهمة: {السبب}»: the reason as operations chose it.
/// * [cash] - returned «استرجع المبلغ من المطعم»; not_returned «لا تسترجع المبلغ، يُخصم من المطعم في التسوية»; not_paid or null: no cash line.
/// * [compensation]
/// * [at]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputCancelled
    implements
        Built<
          CaptainActiveOrderDtoOutputCancelled,
          CaptainActiveOrderDtoOutputCancelledBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// {السبب} of «أُلغيت المهمة: {السبب}»: the reason as operations chose it.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// returned «استرجع المبلغ من المطعم»; not_returned «لا تسترجع المبلغ، يُخصم من المطعم في التسوية»; not_paid or null: no cash line.
  @BuiltValueField(wireName: r'cash')
  CaptainActiveOrderDtoOutputCancelledCashEnum? get cash;
  // enum cashEnum {  returned,  not_returned,  not_paid,  };

  @BuiltValueField(wireName: r'compensation')
  CaptainWentOfflineDtoOutputHandIn? get compensation;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainActiveOrderDtoOutputCancelled._();

  factory CaptainActiveOrderDtoOutputCancelled([
    void updates(CaptainActiveOrderDtoOutputCancelledBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputCancelled;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputCancelledBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputCancelled> get serializer =>
      _$CaptainActiveOrderDtoOutputCancelledSerializer();
}

class _$CaptainActiveOrderDtoOutputCancelledSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputCancelled> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputCancelled,
    _$CaptainActiveOrderDtoOutputCancelled,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputCancelled';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputCancelled object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'cash';
    yield object.cash == null
        ? null
        : serializers.serialize(
            object.cash,
            specifiedType: const FullType.nullable(
              CaptainActiveOrderDtoOutputCancelledCashEnum,
            ),
          );
    yield r'compensation';
    yield object.compensation == null
        ? null
        : serializers.serialize(
            object.compensation,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputCancelled object, {
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
    required CaptainActiveOrderDtoOutputCancelledBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
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
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'cash':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainActiveOrderDtoOutputCancelledCashEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputCancelledCashEnum?;
          if (valueDes == null) continue;
          result.cash = valueDes;
          break;
        case r'compensation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.compensation.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputCancelled deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputCancelledBuilder();
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

/// returned «استرجع المبلغ من المطعم»; not_returned «لا تسترجع المبلغ، يُخصم من المطعم في التسوية»; not_paid or null: no cash line.
class CaptainActiveOrderDtoOutputCancelledCashEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'returned')
  static const CaptainActiveOrderDtoOutputCancelledCashEnum returned =
      _$captainActiveOrderDtoOutputCancelledCashEnum_returned;
  @BuiltValueEnumConst(wireName: r'not_returned')
  static const CaptainActiveOrderDtoOutputCancelledCashEnum notReturned =
      _$captainActiveOrderDtoOutputCancelledCashEnum_notReturned;
  @BuiltValueEnumConst(wireName: r'not_paid')
  static const CaptainActiveOrderDtoOutputCancelledCashEnum notPaid =
      _$captainActiveOrderDtoOutputCancelledCashEnum_notPaid;

  static Serializer<CaptainActiveOrderDtoOutputCancelledCashEnum>
  get serializer => _$captainActiveOrderDtoOutputCancelledCashEnumSerializer;

  const CaptainActiveOrderDtoOutputCancelledCashEnum._(String name)
    : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputCancelledCashEnum> get values =>
      _$captainActiveOrderDtoOutputCancelledCashEnumValues;
  static CaptainActiveOrderDtoOutputCancelledCashEnum valueOf(String name) =>
      _$captainActiveOrderDtoOutputCancelledCashEnumValueOf(name);
}
