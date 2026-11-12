//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_custody_dto_output_closed_due.g.dart';

/// «من أيام سابقة»: due from closed days, netted (AP §8.5.4).
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class CaptainCustodyDtoOutputClosedDue
    implements
        Built<
          CaptainCustodyDtoOutputClosedDue,
          CaptainCustodyDtoOutputClosedDueBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainCustodyDtoOutputClosedDue._();

  factory CaptainCustodyDtoOutputClosedDue([
    void updates(CaptainCustodyDtoOutputClosedDueBuilder b),
  ]) = _$CaptainCustodyDtoOutputClosedDue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCustodyDtoOutputClosedDueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCustodyDtoOutputClosedDue> get serializer =>
      _$CaptainCustodyDtoOutputClosedDueSerializer();
}

class _$CaptainCustodyDtoOutputClosedDueSerializer
    implements PrimitiveSerializer<CaptainCustodyDtoOutputClosedDue> {
  @override
  final Iterable<Type> types = const [
    CaptainCustodyDtoOutputClosedDue,
    _$CaptainCustodyDtoOutputClosedDue,
  ];

  @override
  final String wireName = r'CaptainCustodyDtoOutputClosedDue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCustodyDtoOutputClosedDue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCustodyDtoOutputClosedDue object, {
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
    required CaptainCustodyDtoOutputClosedDueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCustodyDtoOutputClosedDue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCustodyDtoOutputClosedDueBuilder();
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
