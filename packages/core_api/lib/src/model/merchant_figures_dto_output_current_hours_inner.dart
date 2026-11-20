//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_dto_output_current_hours_inner.g.dart';

/// MerchantFiguresDtoOutputCurrentHoursInner
///
/// Properties:
/// * [hour]
/// * [delivered]
@BuiltValue()
abstract class MerchantFiguresDtoOutputCurrentHoursInner
    implements
        Built<
          MerchantFiguresDtoOutputCurrentHoursInner,
          MerchantFiguresDtoOutputCurrentHoursInnerBuilder
        > {
  @BuiltValueField(wireName: r'hour')
  int get hour;

  @BuiltValueField(wireName: r'delivered')
  int get delivered;

  MerchantFiguresDtoOutputCurrentHoursInner._();

  factory MerchantFiguresDtoOutputCurrentHoursInner([
    void updates(MerchantFiguresDtoOutputCurrentHoursInnerBuilder b),
  ]) = _$MerchantFiguresDtoOutputCurrentHoursInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantFiguresDtoOutputCurrentHoursInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresDtoOutputCurrentHoursInner> get serializer =>
      _$MerchantFiguresDtoOutputCurrentHoursInnerSerializer();
}

class _$MerchantFiguresDtoOutputCurrentHoursInnerSerializer
    implements PrimitiveSerializer<MerchantFiguresDtoOutputCurrentHoursInner> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresDtoOutputCurrentHoursInner,
    _$MerchantFiguresDtoOutputCurrentHoursInner,
  ];

  @override
  final String wireName = r'MerchantFiguresDtoOutputCurrentHoursInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresDtoOutputCurrentHoursInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'hour';
    yield serializers.serialize(
      object.hour,
      specifiedType: const FullType(int),
    );
    yield r'delivered';
    yield serializers.serialize(
      object.delivered,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantFiguresDtoOutputCurrentHoursInner object, {
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
    required MerchantFiguresDtoOutputCurrentHoursInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'hour':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.hour = valueDes;
          break;
        case r'delivered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.delivered = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantFiguresDtoOutputCurrentHoursInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresDtoOutputCurrentHoursInnerBuilder();
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
