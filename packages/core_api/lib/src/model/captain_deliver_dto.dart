//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_record_delivery_dto_amount_due.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_arrive_dto_location.dart';
import 'package:core_api/src/model/captain_deliver_dto_away.dart';
import 'package:core_api/src/model/admin_record_delivery_dto_received_inner.dart';
import 'package:core_api/src/model/admin_record_delivery_dto_shortfall.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_deliver_dto.g.dart';

/// CaptainDeliverDto
///
/// Properties:
/// * [received] - What the customer paid, one line per currency.
/// * [change] - The change given back, one line per currency; a tip is recorded as given (K14).
/// * [amountDue] 
/// * [shortfall] 
/// * [location] 
/// * [away] 
@BuiltValue()
abstract class CaptainDeliverDto implements Built<CaptainDeliverDto, CaptainDeliverDtoBuilder> {
  /// What the customer paid, one line per currency.
  @BuiltValueField(wireName: r'received')
  BuiltList<AdminRecordDeliveryDtoReceivedInner> get received;

  /// The change given back, one line per currency; a tip is recorded as given (K14).
  @BuiltValueField(wireName: r'change')
  BuiltList<AdminRecordDeliveryDtoReceivedInner> get change;

  @BuiltValueField(wireName: r'amountDue')
  AdminRecordDeliveryDtoAmountDue get amountDue;

  @BuiltValueField(wireName: r'shortfall')
  AdminRecordDeliveryDtoShortfall? get shortfall;

  @BuiltValueField(wireName: r'location')
  CaptainArriveDtoLocation get location;

  @BuiltValueField(wireName: r'away')
  CaptainDeliverDtoAway? get away;

  CaptainDeliverDto._();

  factory CaptainDeliverDto([void updates(CaptainDeliverDtoBuilder b)]) = _$CaptainDeliverDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainDeliverDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDeliverDto> get serializer => _$CaptainDeliverDtoSerializer();
}

class _$CaptainDeliverDtoSerializer implements PrimitiveSerializer<CaptainDeliverDto> {
  @override
  final Iterable<Type> types = const [CaptainDeliverDto, _$CaptainDeliverDto];

  @override
  final String wireName = r'CaptainDeliverDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDeliverDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(BuiltList, [FullType(AdminRecordDeliveryDtoReceivedInner)]),
    );
    yield r'change';
    yield serializers.serialize(
      object.change,
      specifiedType: const FullType(BuiltList, [FullType(AdminRecordDeliveryDtoReceivedInner)]),
    );
    yield r'amountDue';
    yield serializers.serialize(
      object.amountDue,
      specifiedType: const FullType(AdminRecordDeliveryDtoAmountDue),
    );
    yield r'shortfall';
    yield object.shortfall == null ? null : serializers.serialize(
      object.shortfall,
      specifiedType: const FullType.nullable(AdminRecordDeliveryDtoShortfall),
    );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(CaptainArriveDtoLocation),
    );
    yield r'away';
    yield object.away == null ? null : serializers.serialize(
      object.away,
      specifiedType: const FullType.nullable(CaptainDeliverDtoAway),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDeliverDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainDeliverDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'received':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminRecordDeliveryDtoReceivedInner)]),
          ) as BuiltList<AdminRecordDeliveryDtoReceivedInner>;
          result.received.replace(valueDes);
          break;
        case r'change':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminRecordDeliveryDtoReceivedInner)]),
          ) as BuiltList<AdminRecordDeliveryDtoReceivedInner>;
          result.change.replace(valueDes);
          break;
        case r'amountDue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRecordDeliveryDtoAmountDue),
          ) as AdminRecordDeliveryDtoAmountDue;
          result.amountDue.replace(valueDes);
          break;
        case r'shortfall':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminRecordDeliveryDtoShortfall),
          ) as AdminRecordDeliveryDtoShortfall?;
          if (valueDes == null) continue;
          result.shortfall.replace(valueDes);
          break;
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainArriveDtoLocation),
          ) as CaptainArriveDtoLocation;
          result.location.replace(valueDes);
          break;
        case r'away':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CaptainDeliverDtoAway),
          ) as CaptainDeliverDtoAway?;
          if (valueDes == null) continue;
          result.away.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDeliverDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDeliverDtoBuilder();
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


