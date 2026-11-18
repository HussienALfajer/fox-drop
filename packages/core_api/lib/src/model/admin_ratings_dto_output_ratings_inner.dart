//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_customer_dto_output_block_reasons_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ratings_dto_output_ratings_inner.g.dart';

/// AdminRatingsDtoOutputRatingsInner
///
/// Properties:
/// * [orderId]
/// * [orderNumber]
/// * [stars]
/// * [reasons] - The reasons the customer picked, their labels as chosen.
/// * [comment]
/// * [at]
@BuiltValue()
abstract class AdminRatingsDtoOutputRatingsInner
    implements
        Built<
          AdminRatingsDtoOutputRatingsInner,
          AdminRatingsDtoOutputRatingsInnerBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String get orderNumber;

  @BuiltValueField(wireName: r'stars')
  int get stars;

  /// The reasons the customer picked, their labels as chosen.
  @BuiltValueField(wireName: r'reasons')
  BuiltList<AdminCustomerDtoOutputBlockReasonsInner> get reasons;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  AdminRatingsDtoOutputRatingsInner._();

  factory AdminRatingsDtoOutputRatingsInner([
    void updates(AdminRatingsDtoOutputRatingsInnerBuilder b),
  ]) = _$AdminRatingsDtoOutputRatingsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRatingsDtoOutputRatingsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRatingsDtoOutputRatingsInner> get serializer =>
      _$AdminRatingsDtoOutputRatingsInnerSerializer();
}

class _$AdminRatingsDtoOutputRatingsInnerSerializer
    implements PrimitiveSerializer<AdminRatingsDtoOutputRatingsInner> {
  @override
  final Iterable<Type> types = const [
    AdminRatingsDtoOutputRatingsInner,
    _$AdminRatingsDtoOutputRatingsInner,
  ];

  @override
  final String wireName = r'AdminRatingsDtoOutputRatingsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRatingsDtoOutputRatingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'orderNumber';
    yield serializers.serialize(
      object.orderNumber,
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
    AdminRatingsDtoOutputRatingsInner object, {
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
    required AdminRatingsDtoOutputRatingsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
          break;
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderNumber = valueDes;
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
  AdminRatingsDtoOutputRatingsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRatingsDtoOutputRatingsInnerBuilder();
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
