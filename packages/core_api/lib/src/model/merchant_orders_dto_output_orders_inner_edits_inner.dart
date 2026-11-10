//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_edits_inner_changes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_edits_inner.g.dart';

/// MerchantOrdersDtoOutputOrdersInnerEditsInner
///
/// Properties:
/// * [at]
/// * [addsItems] - Items added or a quantity raised: every device rings «تم تعديل الطلب #{رقم} — أُضيفت أصناف» until «اطلعت على التعديل», and pickup requests wait (RA §8.10, §16 #16); otherwise it chimes «تم تعديل الطلب #{رقم}» once and stays on the card (RA §16 #17).
/// * [changes] - The prompt lists them (RA §8.13).
/// * [itemsValue] - The new items value after this edit.
/// * [extraPrepMin] - Items added to a ready order: back to «قيد التحضير» with this many minutes from the edit (RA §8.13); null otherwise.
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerEditsInner
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerEditsInner,
          MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// Items added or a quantity raised: every device rings «تم تعديل الطلب #{رقم} — أُضيفت أصناف» until «اطلعت على التعديل», and pickup requests wait (RA §8.10, §16 #16); otherwise it chimes «تم تعديل الطلب #{رقم}» once and stays on the card (RA §16 #17).
  @BuiltValueField(wireName: r'addsItems')
  bool get addsItems;

  /// The prompt lists them (RA §8.13).
  @BuiltValueField(wireName: r'changes')
  BuiltList<MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner>
  get changes;

  /// The new items value after this edit.
  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  /// Items added to a ready order: back to «قيد التحضير» with this many minutes from the edit (RA §8.13); null otherwise.
  @BuiltValueField(wireName: r'extraPrepMin')
  int? get extraPrepMin;

  MerchantOrdersDtoOutputOrdersInnerEditsInner._();

  factory MerchantOrdersDtoOutputOrdersInnerEditsInner([
    void updates(MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder b),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerEditsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerEditsInner>
  get serializer => _$MerchantOrdersDtoOutputOrdersInnerEditsInnerSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerEditsInnerSerializer
    implements
        PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerEditsInner> {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerEditsInner,
    _$MerchantOrdersDtoOutputOrdersInnerEditsInner,
  ];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerEditsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerEditsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'addsItems';
    yield serializers.serialize(
      object.addsItems,
      specifiedType: const FullType(bool),
    );
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner),
      ]),
    );
    yield r'itemsValue';
    yield serializers.serialize(
      object.itemsValue,
      specifiedType: const FullType(String),
    );
    yield r'extraPrepMin';
    yield object.extraPrepMin == null
        ? null
        : serializers.serialize(
            object.extraPrepMin,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerEditsInner object, {
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
    required MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'addsItems':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.addsItems = valueDes;
          break;
        case r'changes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner
                  >;
          result.changes.replace(valueDes);
          break;
        case r'itemsValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemsValue = valueDes;
          break;
        case r'extraPrepMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.extraPrepMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerEditsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder();
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
