//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_lines_inner.dart';
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_customer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner.g.dart';

/// MerchantOrdersDtoOutputOrdersInner
///
/// Properties:
/// * [id]
/// * [number] - Shown as #10423 (AP §4.8).
/// * [status] - AP §8.1; the board column (RA §8.1–8.2).
/// * [version] - Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).
/// * [placedAt]
/// * [acceptAlertAt] - While placed from then: the card turns red and the prompt adds «تأخرتم في الرد — سيتصل بكم فريق العمليات» (RA §8.2–8.3).
/// * [autoCancelAt] - «يُلغى تلقائياً خلال {د:ث}» counts down to it while placed (RA §8.3).
/// * [customer]
/// * [note] - The customer's note.
/// * [lines]
/// * [currency]
/// * [itemsValue] - «قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام» (RA §8.4); the delivery fee and the customer total are never shown (R11).
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInner
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInner,
          MerchantOrdersDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// AP §8.1; the board column (RA §8.1–8.2).
  @BuiltValueField(wireName: r'status')
  MerchantOrdersDtoOutputOrdersInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  /// While placed from then: the card turns red and the prompt adds «تأخرتم في الرد — سيتصل بكم فريق العمليات» (RA §8.2–8.3).
  @BuiltValueField(wireName: r'acceptAlertAt')
  DateTime? get acceptAlertAt;

  /// «يُلغى تلقائياً خلال {د:ث}» counts down to it while placed (RA §8.3).
  @BuiltValueField(wireName: r'autoCancelAt')
  DateTime? get autoCancelAt;

  @BuiltValueField(wireName: r'customer')
  MerchantOrdersDtoOutputOrdersInnerCustomer get customer;

  /// The customer's note.
  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'lines')
  BuiltList<MerchantOrdersDtoOutputOrdersInnerLinesInner> get lines;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// «قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام» (RA §8.4); the delivery fee and the customer total are never shown (R11).
  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  MerchantOrdersDtoOutputOrdersInner._();

  factory MerchantOrdersDtoOutputOrdersInner([
    void updates(MerchantOrdersDtoOutputOrdersInnerBuilder b),
  ]) = _$MerchantOrdersDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrdersDtoOutputOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInner> get serializer =>
      _$MerchantOrdersDtoOutputOrdersInnerSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInner,
    _$MerchantOrdersDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        MerchantOrdersDtoOutputOrdersInnerStatusEnum,
      ),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'acceptAlertAt';
    yield object.acceptAlertAt == null
        ? null
        : serializers.serialize(
            object.acceptAlertAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'autoCancelAt';
    yield object.autoCancelAt == null
        ? null
        : serializers.serialize(
            object.autoCancelAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'customer';
    yield serializers.serialize(
      object.customer,
      specifiedType: const FullType(MerchantOrdersDtoOutputOrdersInnerCustomer),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantOrdersDtoOutputOrdersInnerLinesInner),
      ]),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'itemsValue';
    yield serializers.serialize(
      object.itemsValue,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInner object, {
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
    required MerchantOrdersDtoOutputOrdersInnerBuilder result,
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
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantOrdersDtoOutputOrdersInnerStatusEnum,
                    ),
                  )
                  as MerchantOrdersDtoOutputOrdersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'version':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.version = valueDes;
          break;
        case r'placedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.placedAt = valueDes;
          break;
        case r'acceptAlertAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.acceptAlertAt = valueDes;
          break;
        case r'autoCancelAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.autoCancelAt = valueDes;
          break;
        case r'customer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantOrdersDtoOutputOrdersInnerCustomer,
                    ),
                  )
                  as MerchantOrdersDtoOutputOrdersInnerCustomer;
          result.customer.replace(valueDes);
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantOrdersDtoOutputOrdersInnerLinesInner),
                    ]),
                  )
                  as BuiltList<MerchantOrdersDtoOutputOrdersInnerLinesInner>;
          result.lines.replace(valueDes);
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
        case r'itemsValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemsValue = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerBuilder();
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

/// AP §8.1; the board column (RA §8.1–8.2).
class MerchantOrdersDtoOutputOrdersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const MerchantOrdersDtoOutputOrdersInnerStatusEnum placed =
      _$merchantOrdersDtoOutputOrdersInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const MerchantOrdersDtoOutputOrdersInnerStatusEnum accepted =
      _$merchantOrdersDtoOutputOrdersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const MerchantOrdersDtoOutputOrdersInnerStatusEnum ready =
      _$merchantOrdersDtoOutputOrdersInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const MerchantOrdersDtoOutputOrdersInnerStatusEnum pickedUp =
      _$merchantOrdersDtoOutputOrdersInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const MerchantOrdersDtoOutputOrdersInnerStatusEnum arrived =
      _$merchantOrdersDtoOutputOrdersInnerStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const MerchantOrdersDtoOutputOrdersInnerStatusEnum delivered =
      _$merchantOrdersDtoOutputOrdersInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const MerchantOrdersDtoOutputOrdersInnerStatusEnum rejected =
      _$merchantOrdersDtoOutputOrdersInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const MerchantOrdersDtoOutputOrdersInnerStatusEnum cancelled =
      _$merchantOrdersDtoOutputOrdersInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const MerchantOrdersDtoOutputOrdersInnerStatusEnum failed =
      _$merchantOrdersDtoOutputOrdersInnerStatusEnum_failed;

  static Serializer<MerchantOrdersDtoOutputOrdersInnerStatusEnum>
  get serializer => _$merchantOrdersDtoOutputOrdersInnerStatusEnumSerializer;

  const MerchantOrdersDtoOutputOrdersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<MerchantOrdersDtoOutputOrdersInnerStatusEnum> get values =>
      _$merchantOrdersDtoOutputOrdersInnerStatusEnumValues;
  static MerchantOrdersDtoOutputOrdersInnerStatusEnum valueOf(String name) =>
      _$merchantOrdersDtoOutputOrdersInnerStatusEnumValueOf(name);
}
