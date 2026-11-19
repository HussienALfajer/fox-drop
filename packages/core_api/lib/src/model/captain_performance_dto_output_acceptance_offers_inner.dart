//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_performance_dto_output_acceptance_offers_inner.g.dart';

/// CaptainPerformanceDtoOutputAcceptanceOffersInner
///
/// Properties:
/// * [offeredAt]
/// * [restaurantName]
/// * [response]
@BuiltValue()
abstract class CaptainPerformanceDtoOutputAcceptanceOffersInner
    implements
        Built<
          CaptainPerformanceDtoOutputAcceptanceOffersInner,
          CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder
        > {
  @BuiltValueField(wireName: r'offeredAt')
  DateTime get offeredAt;

  @BuiltValueField(wireName: r'restaurantName')
  String? get restaurantName;

  @BuiltValueField(wireName: r'response')
  CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum get response;
  // enum responseEnum {  accepted,  declined,  expired,  };

  CaptainPerformanceDtoOutputAcceptanceOffersInner._();

  factory CaptainPerformanceDtoOutputAcceptanceOffersInner([
    void updates(CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder b),
  ]) = _$CaptainPerformanceDtoOutputAcceptanceOffersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPerformanceDtoOutputAcceptanceOffersInner>
  get serializer =>
      _$CaptainPerformanceDtoOutputAcceptanceOffersInnerSerializer();
}

class _$CaptainPerformanceDtoOutputAcceptanceOffersInnerSerializer
    implements
        PrimitiveSerializer<CaptainPerformanceDtoOutputAcceptanceOffersInner> {
  @override
  final Iterable<Type> types = const [
    CaptainPerformanceDtoOutputAcceptanceOffersInner,
    _$CaptainPerformanceDtoOutputAcceptanceOffersInner,
  ];

  @override
  final String wireName = r'CaptainPerformanceDtoOutputAcceptanceOffersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPerformanceDtoOutputAcceptanceOffersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'offeredAt';
    yield serializers.serialize(
      object.offeredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'restaurantName';
    yield object.restaurantName == null
        ? null
        : serializers.serialize(
            object.restaurantName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'response';
    yield serializers.serialize(
      object.response,
      specifiedType: const FullType(
        CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPerformanceDtoOutputAcceptanceOffersInner object, {
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
    required CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'offeredAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.offeredAt = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.restaurantName = valueDes;
          break;
        case r'response':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum,
                    ),
                  )
                  as CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum;
          result.response = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPerformanceDtoOutputAcceptanceOffersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder();
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

class CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum
  accepted =
      _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_accepted;
  @BuiltValueEnumConst(wireName: r'declined')
  static const CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum
  declined =
      _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_declined;
  @BuiltValueEnumConst(wireName: r'expired')
  static const CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum
  expired =
      _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_expired;

  static Serializer<
    CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum
  >
  get serializer =>
      _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnumSerializer;

  const CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum._(
    String name,
  ) : super(name);

  static BuiltSet<CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum>
  get values =>
      _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnumValues;
  static CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum valueOf(
    String name,
  ) => _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnumValueOf(
    name,
  );
}
