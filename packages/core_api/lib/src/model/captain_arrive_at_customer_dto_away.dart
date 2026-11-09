//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_arrive_at_customer_dto_away.g.dart';

/// Needed beyond captain.customer_radius_m of the pin: «الزبون طلب مكاناً آخر», «موقع الزبون على الخريطة غير دقيق», «أخرى».
///
/// Properties:
/// * [reason] - The reason's code in its Content list.
/// * [note] - The text of a reason that needs one («أخرى»), and only of it.
@BuiltValue()
abstract class CaptainArriveAtCustomerDtoAway
    implements
        Built<
          CaptainArriveAtCustomerDtoAway,
          CaptainArriveAtCustomerDtoAwayBuilder
        > {
  /// The reason's code in its Content list.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// The text of a reason that needs one («أخرى»), and only of it.
  @BuiltValueField(wireName: r'note')
  String? get note;

  CaptainArriveAtCustomerDtoAway._();

  factory CaptainArriveAtCustomerDtoAway([
    void updates(CaptainArriveAtCustomerDtoAwayBuilder b),
  ]) = _$CaptainArriveAtCustomerDtoAway;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainArriveAtCustomerDtoAwayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainArriveAtCustomerDtoAway> get serializer =>
      _$CaptainArriveAtCustomerDtoAwaySerializer();
}

class _$CaptainArriveAtCustomerDtoAwaySerializer
    implements PrimitiveSerializer<CaptainArriveAtCustomerDtoAway> {
  @override
  final Iterable<Type> types = const [
    CaptainArriveAtCustomerDtoAway,
    _$CaptainArriveAtCustomerDtoAway,
  ];

  @override
  final String wireName = r'CaptainArriveAtCustomerDtoAway';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainArriveAtCustomerDtoAway object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainArriveAtCustomerDtoAway object, {
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
    required CaptainArriveAtCustomerDtoAwayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainArriveAtCustomerDtoAway deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainArriveAtCustomerDtoAwayBuilder();
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
