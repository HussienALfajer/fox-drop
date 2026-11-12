//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_hand_in_dto_conversions_inner_rates_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_hand_in_dto_conversions_inner.g.dart';

/// AdminHandInDtoConversionsInner
///
/// Properties:
/// * [from]
/// * [to]
/// * [amount] - Of `from`, taken off its custody towards zero.
/// * [converted] - Of `to`, as the quote showed it.
/// * [rates] - The rate version of each currency but the base, as the quote gave them.
@BuiltValue()
abstract class AdminHandInDtoConversionsInner
    implements
        Built<
          AdminHandInDtoConversionsInner,
          AdminHandInDtoConversionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'from')
  String get from;

  @BuiltValueField(wireName: r'to')
  String get to;

  /// Of `from`, taken off its custody towards zero.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// Of `to`, as the quote showed it.
  @BuiltValueField(wireName: r'converted')
  String get converted;

  /// The rate version of each currency but the base, as the quote gave them.
  @BuiltValueField(wireName: r'rates')
  BuiltList<AdminHandInDtoConversionsInnerRatesInner> get rates;

  AdminHandInDtoConversionsInner._();

  factory AdminHandInDtoConversionsInner([
    void updates(AdminHandInDtoConversionsInnerBuilder b),
  ]) = _$AdminHandInDtoConversionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHandInDtoConversionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHandInDtoConversionsInner> get serializer =>
      _$AdminHandInDtoConversionsInnerSerializer();
}

class _$AdminHandInDtoConversionsInnerSerializer
    implements PrimitiveSerializer<AdminHandInDtoConversionsInner> {
  @override
  final Iterable<Type> types = const [
    AdminHandInDtoConversionsInner,
    _$AdminHandInDtoConversionsInner,
  ];

  @override
  final String wireName = r'AdminHandInDtoConversionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHandInDtoConversionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'converted';
    yield serializers.serialize(
      object.converted,
      specifiedType: const FullType(String),
    );
    yield r'rates';
    yield serializers.serialize(
      object.rates,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminHandInDtoConversionsInnerRatesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminHandInDtoConversionsInner object, {
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
    required AdminHandInDtoConversionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.to = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'converted':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.converted = valueDes;
          break;
        case r'rates':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminHandInDtoConversionsInnerRatesInner),
                    ]),
                  )
                  as BuiltList<AdminHandInDtoConversionsInnerRatesInner>;
          result.rates.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminHandInDtoConversionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHandInDtoConversionsInnerBuilder();
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
