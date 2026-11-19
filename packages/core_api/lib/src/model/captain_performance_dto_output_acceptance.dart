//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_performance_dto_output_acceptance_offers_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_performance_dto_output_acceptance.g.dart';

/// CaptainPerformanceDtoOutputAcceptance
///
/// Properties:
/// * [rate] - Whole percent; null without an answered offer.
/// * [accepted]
/// * [answered]
/// * [windowOffers] - captain.acceptance_window_offers
/// * [warn] - Below captain.acceptance_alert_pct: the app warns.
/// * [alertPct]
/// * [offers] - The answered offers counted, newest first.
@BuiltValue()
abstract class CaptainPerformanceDtoOutputAcceptance
    implements
        Built<
          CaptainPerformanceDtoOutputAcceptance,
          CaptainPerformanceDtoOutputAcceptanceBuilder
        > {
  /// Whole percent; null without an answered offer.
  @BuiltValueField(wireName: r'rate')
  int? get rate;

  @BuiltValueField(wireName: r'accepted')
  int get accepted;

  @BuiltValueField(wireName: r'answered')
  int get answered;

  /// captain.acceptance_window_offers
  @BuiltValueField(wireName: r'windowOffers')
  int get windowOffers;

  /// Below captain.acceptance_alert_pct: the app warns.
  @BuiltValueField(wireName: r'warn')
  bool get warn;

  @BuiltValueField(wireName: r'alertPct')
  int get alertPct;

  /// The answered offers counted, newest first.
  @BuiltValueField(wireName: r'offers')
  BuiltList<CaptainPerformanceDtoOutputAcceptanceOffersInner> get offers;

  CaptainPerformanceDtoOutputAcceptance._();

  factory CaptainPerformanceDtoOutputAcceptance([
    void updates(CaptainPerformanceDtoOutputAcceptanceBuilder b),
  ]) = _$CaptainPerformanceDtoOutputAcceptance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPerformanceDtoOutputAcceptanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPerformanceDtoOutputAcceptance> get serializer =>
      _$CaptainPerformanceDtoOutputAcceptanceSerializer();
}

class _$CaptainPerformanceDtoOutputAcceptanceSerializer
    implements PrimitiveSerializer<CaptainPerformanceDtoOutputAcceptance> {
  @override
  final Iterable<Type> types = const [
    CaptainPerformanceDtoOutputAcceptance,
    _$CaptainPerformanceDtoOutputAcceptance,
  ];

  @override
  final String wireName = r'CaptainPerformanceDtoOutputAcceptance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPerformanceDtoOutputAcceptance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rate';
    yield object.rate == null
        ? null
        : serializers.serialize(
            object.rate,
            specifiedType: const FullType.nullable(int),
          );
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(int),
    );
    yield r'answered';
    yield serializers.serialize(
      object.answered,
      specifiedType: const FullType(int),
    );
    yield r'windowOffers';
    yield serializers.serialize(
      object.windowOffers,
      specifiedType: const FullType(int),
    );
    yield r'warn';
    yield serializers.serialize(
      object.warn,
      specifiedType: const FullType(bool),
    );
    yield r'alertPct';
    yield serializers.serialize(
      object.alertPct,
      specifiedType: const FullType(int),
    );
    yield r'offers';
    yield serializers.serialize(
      object.offers,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPerformanceDtoOutputAcceptanceOffersInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPerformanceDtoOutputAcceptance object, {
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
    required CaptainPerformanceDtoOutputAcceptanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.rate = valueDes;
          break;
        case r'accepted':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.accepted = valueDes;
          break;
        case r'answered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.answered = valueDes;
          break;
        case r'windowOffers':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.windowOffers = valueDes;
          break;
        case r'warn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.warn = valueDes;
          break;
        case r'alertPct':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.alertPct = valueDes;
          break;
        case r'offers':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainPerformanceDtoOutputAcceptanceOffersInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainPerformanceDtoOutputAcceptanceOffersInner
                  >;
          result.offers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPerformanceDtoOutputAcceptance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPerformanceDtoOutputAcceptanceBuilder();
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
