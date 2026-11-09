//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_pickup_dispute.g.dart';

/// «خلاف على دفعة الاستلام» after the pickup (RA §8.10 item 8), always urgent.
///
/// Properties:
/// * [at]
/// * [accountId] - The restaurant user.
/// * [device]
/// * [receivedLines] - What the restaurant says it received.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderPickupDispute
    implements
        Built<
          AdminOrderDtoOutputOrderPickupDispute,
          AdminOrderDtoOutputOrderPickupDisputeBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The restaurant user.
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  @BuiltValueField(wireName: r'device')
  String get device;

  /// What the restaurant says it received.
  @BuiltValueField(wireName: r'receivedLines')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get receivedLines;

  AdminOrderDtoOutputOrderPickupDispute._();

  factory AdminOrderDtoOutputOrderPickupDispute([
    void updates(AdminOrderDtoOutputOrderPickupDisputeBuilder b),
  ]) = _$AdminOrderDtoOutputOrderPickupDispute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderPickupDisputeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderPickupDispute> get serializer =>
      _$AdminOrderDtoOutputOrderPickupDisputeSerializer();
}

class _$AdminOrderDtoOutputOrderPickupDisputeSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderPickupDispute> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderPickupDispute,
    _$AdminOrderDtoOutputOrderPickupDispute,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderPickupDispute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickupDispute object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(String),
    );
    yield r'device';
    yield serializers.serialize(
      object.device,
      specifiedType: const FullType(String),
    );
    yield r'receivedLines';
    yield serializers.serialize(
      object.receivedLines,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickupDispute object, {
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
    required AdminOrderDtoOutputOrderPickupDisputeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'accountId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.accountId = valueDes;
          break;
        case r'device':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.device = valueDes;
          break;
        case r'receivedLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
                    ]),
                  )
                  as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.receivedLines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderPickupDispute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderPickupDisputeBuilder();
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
