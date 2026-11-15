//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_earnings_dto_output_orders_inner_parts.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_earnings_dto_output_orders_inner.g.dart';

/// CaptainEarningsDtoOutputOrdersInner
///
/// Properties:
/// * [orderNumber]
/// * [at]
/// * [parts]
/// * [total] - Integer minor units of the base currency (AP §8.6).
@BuiltValue()
abstract class CaptainEarningsDtoOutputOrdersInner
    implements
        Built<
          CaptainEarningsDtoOutputOrdersInner,
          CaptainEarningsDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'parts')
  CaptainEarningsDtoOutputOrdersInnerParts? get parts;

  /// Integer minor units of the base currency (AP §8.6).
  @BuiltValueField(wireName: r'total')
  String get total;

  CaptainEarningsDtoOutputOrdersInner._();

  factory CaptainEarningsDtoOutputOrdersInner([
    void updates(CaptainEarningsDtoOutputOrdersInnerBuilder b),
  ]) = _$CaptainEarningsDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainEarningsDtoOutputOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainEarningsDtoOutputOrdersInner> get serializer =>
      _$CaptainEarningsDtoOutputOrdersInnerSerializer();
}

class _$CaptainEarningsDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<CaptainEarningsDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    CaptainEarningsDtoOutputOrdersInner,
    _$CaptainEarningsDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'CaptainEarningsDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainEarningsDtoOutputOrdersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orderNumber';
    yield object.orderNumber == null
        ? null
        : serializers.serialize(
            object.orderNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'parts';
    yield object.parts == null
        ? null
        : serializers.serialize(
            object.parts,
            specifiedType: const FullType.nullable(
              CaptainEarningsDtoOutputOrdersInnerParts,
            ),
          );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainEarningsDtoOutputOrdersInner object, {
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
    required CaptainEarningsDtoOutputOrdersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderNumber = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'parts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainEarningsDtoOutputOrdersInnerParts,
                    ),
                  )
                  as CaptainEarningsDtoOutputOrdersInnerParts?;
          if (valueDes == null) continue;
          result.parts.replace(valueDes);
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainEarningsDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainEarningsDtoOutputOrdersInnerBuilder();
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
