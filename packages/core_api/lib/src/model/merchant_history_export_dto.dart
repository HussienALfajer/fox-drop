//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_history_export_dto.g.dart';

/// MerchantHistoryExportDto
///
/// Properties:
/// * [from] - The first business day.
/// * [to] - The last business day, included: at most 366 days.
/// * [status]
/// * [number] - The order number without «#».
@BuiltValue()
abstract class MerchantHistoryExportDto
    implements
        Built<MerchantHistoryExportDto, MerchantHistoryExportDtoBuilder> {
  /// The first business day.
  @BuiltValueField(wireName: r'from')
  String get from;

  /// The last business day, included: at most 366 days.
  @BuiltValueField(wireName: r'to')
  String get to;

  @BuiltValueField(wireName: r'status')
  MerchantHistoryExportDtoStatusEnum? get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// The order number without «#».
  @BuiltValueField(wireName: r'number')
  String? get number;

  MerchantHistoryExportDto._();

  factory MerchantHistoryExportDto([
    void updates(MerchantHistoryExportDtoBuilder b),
  ]) = _$MerchantHistoryExportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantHistoryExportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantHistoryExportDto> get serializer =>
      _$MerchantHistoryExportDtoSerializer();
}

class _$MerchantHistoryExportDtoSerializer
    implements PrimitiveSerializer<MerchantHistoryExportDto> {
  @override
  final Iterable<Type> types = const [
    MerchantHistoryExportDto,
    _$MerchantHistoryExportDto,
  ];

  @override
  final String wireName = r'MerchantHistoryExportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantHistoryExportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield object.status == null
        ? null
        : serializers.serialize(
            object.status,
            specifiedType: const FullType.nullable(
              MerchantHistoryExportDtoStatusEnum,
            ),
          );
    yield r'number';
    yield object.number == null
        ? null
        : serializers.serialize(
            object.number,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantHistoryExportDto object, {
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
    required MerchantHistoryExportDtoBuilder result,
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
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.to = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantHistoryExportDtoStatusEnum,
                    ),
                  )
                  as MerchantHistoryExportDtoStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.number = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantHistoryExportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantHistoryExportDtoBuilder();
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

class MerchantHistoryExportDtoStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const MerchantHistoryExportDtoStatusEnum placed =
      _$merchantHistoryExportDtoStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const MerchantHistoryExportDtoStatusEnum accepted =
      _$merchantHistoryExportDtoStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const MerchantHistoryExportDtoStatusEnum ready =
      _$merchantHistoryExportDtoStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const MerchantHistoryExportDtoStatusEnum pickedUp =
      _$merchantHistoryExportDtoStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const MerchantHistoryExportDtoStatusEnum arrived =
      _$merchantHistoryExportDtoStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const MerchantHistoryExportDtoStatusEnum delivered =
      _$merchantHistoryExportDtoStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const MerchantHistoryExportDtoStatusEnum rejected =
      _$merchantHistoryExportDtoStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const MerchantHistoryExportDtoStatusEnum cancelled =
      _$merchantHistoryExportDtoStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const MerchantHistoryExportDtoStatusEnum failed =
      _$merchantHistoryExportDtoStatusEnum_failed;

  static Serializer<MerchantHistoryExportDtoStatusEnum> get serializer =>
      _$merchantHistoryExportDtoStatusEnumSerializer;

  const MerchantHistoryExportDtoStatusEnum._(String name) : super(name);

  static BuiltSet<MerchantHistoryExportDtoStatusEnum> get values =>
      _$merchantHistoryExportDtoStatusEnumValues;
  static MerchantHistoryExportDtoStatusEnum valueOf(String name) =>
      _$merchantHistoryExportDtoStatusEnumValueOf(name);
}
