//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_customer_dto_output_block_reasons_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_rating_captain.g.dart';

/// «قيّم الكابتن» as sent; never edited (Q16).
///
/// Properties:
/// * [stars]
/// * [reasons]
/// * [comment]
/// * [at]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain,
          CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder
        > {
  @BuiltValueField(wireName: r'stars')
  int get stars;

  @BuiltValueField(wireName: r'reasons')
  BuiltList<AdminCustomerDtoOutputBlockReasonsInner> get reasons;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain([
    void updates(
      CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder b,
    ),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain,
    _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain,
  ];

  @override
  final String wireName =
      r'CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stars';
    yield serializers.serialize(
      object.stars,
      specifiedType: const FullType(int),
    );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputBlockReasonsInner),
      ]),
    );
    yield r'comment';
    yield object.comment == null
        ? null
        : serializers.serialize(
            object.comment,
            specifiedType: const FullType.nullable(String),
          );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stars':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.stars = valueDes;
          break;
        case r'reasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputBlockReasonsInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputBlockReasonsInner>;
          result.reasons.replace(valueDes);
          break;
        case r'comment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder();
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
