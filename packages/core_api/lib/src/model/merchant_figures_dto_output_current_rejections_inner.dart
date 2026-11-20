//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_dto_output_current_rejections_inner.g.dart';

/// MerchantFiguresDtoOutputCurrentRejectionsInner
///
/// Properties:
/// * [label]
/// * [byOperations]
/// * [count]
@BuiltValue()
abstract class MerchantFiguresDtoOutputCurrentRejectionsInner
    implements
        Built<
          MerchantFiguresDtoOutputCurrentRejectionsInner,
          MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'byOperations')
  bool get byOperations;

  @BuiltValueField(wireName: r'count')
  int get count;

  MerchantFiguresDtoOutputCurrentRejectionsInner._();

  factory MerchantFiguresDtoOutputCurrentRejectionsInner([
    void updates(MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder b),
  ]) = _$MerchantFiguresDtoOutputCurrentRejectionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresDtoOutputCurrentRejectionsInner>
  get serializer =>
      _$MerchantFiguresDtoOutputCurrentRejectionsInnerSerializer();
}

class _$MerchantFiguresDtoOutputCurrentRejectionsInnerSerializer
    implements
        PrimitiveSerializer<MerchantFiguresDtoOutputCurrentRejectionsInner> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresDtoOutputCurrentRejectionsInner,
    _$MerchantFiguresDtoOutputCurrentRejectionsInner,
  ];

  @override
  final String wireName = r'MerchantFiguresDtoOutputCurrentRejectionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresDtoOutputCurrentRejectionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'byOperations';
    yield serializers.serialize(
      object.byOperations,
      specifiedType: const FullType(bool),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantFiguresDtoOutputCurrentRejectionsInner object, {
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
    required MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'byOperations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.byOperations = valueDes;
          break;
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantFiguresDtoOutputCurrentRejectionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder();
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
