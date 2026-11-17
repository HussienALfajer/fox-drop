//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_ratings_inner_reasons_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_ratings_dto_output_ratings_inner.g.dart';

/// MerchantRatingsDtoOutputRatingsInner
///
/// Properties:
/// * [id]
/// * [stars]
/// * [reasons] - The reasons the customer picked, their labels as chosen.
/// * [comment]
/// * [at]
@BuiltValue()
abstract class MerchantRatingsDtoOutputRatingsInner
    implements
        Built<
          MerchantRatingsDtoOutputRatingsInner,
          MerchantRatingsDtoOutputRatingsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'stars')
  int get stars;

  /// The reasons the customer picked, their labels as chosen.
  @BuiltValueField(wireName: r'reasons')
  BuiltList<AdminCustomerDtoOutputRatingsInnerReasonsInner?> get reasons;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  MerchantRatingsDtoOutputRatingsInner._();

  factory MerchantRatingsDtoOutputRatingsInner([
    void updates(MerchantRatingsDtoOutputRatingsInnerBuilder b),
  ]) = _$MerchantRatingsDtoOutputRatingsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantRatingsDtoOutputRatingsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantRatingsDtoOutputRatingsInner> get serializer =>
      _$MerchantRatingsDtoOutputRatingsInnerSerializer();
}

class _$MerchantRatingsDtoOutputRatingsInnerSerializer
    implements PrimitiveSerializer<MerchantRatingsDtoOutputRatingsInner> {
  @override
  final Iterable<Type> types = const [
    MerchantRatingsDtoOutputRatingsInner,
    _$MerchantRatingsDtoOutputRatingsInner,
  ];

  @override
  final String wireName = r'MerchantRatingsDtoOutputRatingsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantRatingsDtoOutputRatingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'stars';
    yield serializers.serialize(
      object.stars,
      specifiedType: const FullType(int),
    );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminCustomerDtoOutputRatingsInnerReasonsInner),
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
    MerchantRatingsDtoOutputRatingsInner object, {
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
    required MerchantRatingsDtoOutputRatingsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
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
                      FullType.nullable(
                        AdminCustomerDtoOutputRatingsInnerReasonsInner,
                      ),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputRatingsInnerReasonsInner?>;
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
  MerchantRatingsDtoOutputRatingsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantRatingsDtoOutputRatingsInnerBuilder();
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
