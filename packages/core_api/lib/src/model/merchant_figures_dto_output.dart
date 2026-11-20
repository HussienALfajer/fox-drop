//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_figures_dto_output_current.dart';
import 'package:core_api/src/model/merchant_figures_dto_output_previous.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_dto_output.g.dart';

/// MerchantFiguresDtoOutput
///
/// Properties:
/// * [from]
/// * [to] - The period’s end, or now while it runs.
/// * [currency] - The money’s currency, the city’s base.
/// * [current]
/// * [previous]
@BuiltValue()
abstract class MerchantFiguresDtoOutput
    implements
        Built<MerchantFiguresDtoOutput, MerchantFiguresDtoOutputBuilder> {
  @BuiltValueField(wireName: r'from')
  DateTime get from;

  /// The period’s end, or now while it runs.
  @BuiltValueField(wireName: r'to')
  DateTime get to;

  /// The money’s currency, the city’s base.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'current')
  MerchantFiguresDtoOutputCurrent get current;

  @BuiltValueField(wireName: r'previous')
  MerchantFiguresDtoOutputPrevious get previous;

  MerchantFiguresDtoOutput._();

  factory MerchantFiguresDtoOutput([
    void updates(MerchantFiguresDtoOutputBuilder b),
  ]) = _$MerchantFiguresDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantFiguresDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresDtoOutput> get serializer =>
      _$MerchantFiguresDtoOutputSerializer();
}

class _$MerchantFiguresDtoOutputSerializer
    implements PrimitiveSerializer<MerchantFiguresDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresDtoOutput,
    _$MerchantFiguresDtoOutput,
  ];

  @override
  final String wireName = r'MerchantFiguresDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(DateTime),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(DateTime),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'current';
    yield serializers.serialize(
      object.current,
      specifiedType: const FullType(MerchantFiguresDtoOutputCurrent),
    );
    yield r'previous';
    yield serializers.serialize(
      object.previous,
      specifiedType: const FullType(MerchantFiguresDtoOutputPrevious),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantFiguresDtoOutput object, {
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
    required MerchantFiguresDtoOutputBuilder result,
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
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.to = valueDes;
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
        case r'current':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantFiguresDtoOutputCurrent,
                    ),
                  )
                  as MerchantFiguresDtoOutputCurrent;
          result.current.replace(valueDes);
          break;
        case r'previous':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantFiguresDtoOutputPrevious,
                    ),
                  )
                  as MerchantFiguresDtoOutputPrevious;
          result.previous.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantFiguresDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresDtoOutputBuilder();
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
