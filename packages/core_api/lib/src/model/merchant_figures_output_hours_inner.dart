//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_output_hours_inner.g.dart';

/// MerchantFiguresOutputHoursInner
///
/// Properties:
/// * [hour]
/// * [delivered]
@BuiltValue()
abstract class MerchantFiguresOutputHoursInner
    implements
        Built<
          MerchantFiguresOutputHoursInner,
          MerchantFiguresOutputHoursInnerBuilder
        > {
  @BuiltValueField(wireName: r'hour')
  int get hour;

  @BuiltValueField(wireName: r'delivered')
  int get delivered;

  MerchantFiguresOutputHoursInner._();

  factory MerchantFiguresOutputHoursInner([
    void updates(MerchantFiguresOutputHoursInnerBuilder b),
  ]) = _$MerchantFiguresOutputHoursInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantFiguresOutputHoursInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresOutputHoursInner> get serializer =>
      _$MerchantFiguresOutputHoursInnerSerializer();
}

class _$MerchantFiguresOutputHoursInnerSerializer
    implements PrimitiveSerializer<MerchantFiguresOutputHoursInner> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresOutputHoursInner,
    _$MerchantFiguresOutputHoursInner,
  ];

  @override
  final String wireName = r'MerchantFiguresOutputHoursInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresOutputHoursInner object, {
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
    MerchantFiguresOutputHoursInner object, {
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
    required MerchantFiguresOutputHoursInnerBuilder result,
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
  MerchantFiguresOutputHoursInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresOutputHoursInnerBuilder();
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
