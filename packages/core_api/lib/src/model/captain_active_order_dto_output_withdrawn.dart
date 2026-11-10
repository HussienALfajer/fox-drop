//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_withdrawn.g.dart';

/// The latest order operations took from the captain within 12 hours that the captain has not acknowledged (POST …/acknowledge-withdrawal); the app plays the cancellation sound when one appears.
///
/// Properties:
/// * [orderId]
/// * [number] - Shown as #10423 (AP §4.8).
/// * [reason] - {السبب} of «سُحب منك الطلب: {السبب}»: the reason as operations chose it.
/// * [cash] - returned «استرجع المبلغ من المطعم»; not_returned «لا تسترجع المبلغ، يُخصم من المطعم في التسوية»; not_paid or null: no cash line.
/// * [at]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputWithdrawn
    implements
        Built<
          CaptainActiveOrderDtoOutputWithdrawn,
          CaptainActiveOrderDtoOutputWithdrawnBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// {السبب} of «سُحب منك الطلب: {السبب}»: the reason as operations chose it.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// returned «استرجع المبلغ من المطعم»; not_returned «لا تسترجع المبلغ، يُخصم من المطعم في التسوية»; not_paid or null: no cash line.
  @BuiltValueField(wireName: r'cash')
  CaptainActiveOrderDtoOutputWithdrawnCashEnum? get cash;
  // enum cashEnum {  returned,  not_returned,  not_paid,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainActiveOrderDtoOutputWithdrawn._();

  factory CaptainActiveOrderDtoOutputWithdrawn([
    void updates(CaptainActiveOrderDtoOutputWithdrawnBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputWithdrawn;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputWithdrawnBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputWithdrawn> get serializer =>
      _$CaptainActiveOrderDtoOutputWithdrawnSerializer();
}

class _$CaptainActiveOrderDtoOutputWithdrawnSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputWithdrawn> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputWithdrawn,
    _$CaptainActiveOrderDtoOutputWithdrawn,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputWithdrawn';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputWithdrawn object, {
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
              CaptainActiveOrderDtoOutputWithdrawnCashEnum,
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
    CaptainActiveOrderDtoOutputWithdrawn object, {
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
    required CaptainActiveOrderDtoOutputWithdrawnBuilder result,
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
                      CaptainActiveOrderDtoOutputWithdrawnCashEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputWithdrawnCashEnum?;
          if (valueDes == null) continue;
          result.cash = valueDes;
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
  CaptainActiveOrderDtoOutputWithdrawn deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputWithdrawnBuilder();
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
class CaptainActiveOrderDtoOutputWithdrawnCashEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'returned')
  static const CaptainActiveOrderDtoOutputWithdrawnCashEnum returned =
      _$captainActiveOrderDtoOutputWithdrawnCashEnum_returned;
  @BuiltValueEnumConst(wireName: r'not_returned')
  static const CaptainActiveOrderDtoOutputWithdrawnCashEnum notReturned =
      _$captainActiveOrderDtoOutputWithdrawnCashEnum_notReturned;
  @BuiltValueEnumConst(wireName: r'not_paid')
  static const CaptainActiveOrderDtoOutputWithdrawnCashEnum notPaid =
      _$captainActiveOrderDtoOutputWithdrawnCashEnum_notPaid;

  static Serializer<CaptainActiveOrderDtoOutputWithdrawnCashEnum>
  get serializer => _$captainActiveOrderDtoOutputWithdrawnCashEnumSerializer;

  const CaptainActiveOrderDtoOutputWithdrawnCashEnum._(String name)
    : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputWithdrawnCashEnum> get values =>
      _$captainActiveOrderDtoOutputWithdrawnCashEnumValues;
  static CaptainActiveOrderDtoOutputWithdrawnCashEnum valueOf(String name) =>
      _$captainActiveOrderDtoOutputWithdrawnCashEnumValueOf(name);
}
