//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_report_export_dto.g.dart';

/// MerchantReportExportDto
///
/// Properties:
/// * [period] - RA §11: «اليوم», «أمس», «آخر 7 أيام», «آخر 30 يوماً»; or `from` and `to`.
/// * [from] - A business day on the city’s clock, YYYY-MM-DD.
/// * [to] - A business day on the city’s clock, YYYY-MM-DD.
@BuiltValue()
abstract class MerchantReportExportDto
    implements Built<MerchantReportExportDto, MerchantReportExportDtoBuilder> {
  /// RA §11: «اليوم», «أمس», «آخر 7 أيام», «آخر 30 يوماً»; or `from` and `to`.
  @BuiltValueField(wireName: r'period')
  MerchantReportExportDtoPeriodEnum? get period;
  // enum periodEnum {  today,  yesterday,  last_7_days,  last_30_days,  };

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'from')
  String? get from;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'to')
  String? get to;

  MerchantReportExportDto._();

  factory MerchantReportExportDto([
    void updates(MerchantReportExportDtoBuilder b),
  ]) = _$MerchantReportExportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantReportExportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantReportExportDto> get serializer =>
      _$MerchantReportExportDtoSerializer();
}

class _$MerchantReportExportDtoSerializer
    implements PrimitiveSerializer<MerchantReportExportDto> {
  @override
  final Iterable<Type> types = const [
    MerchantReportExportDto,
    _$MerchantReportExportDto,
  ];

  @override
  final String wireName = r'MerchantReportExportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantReportExportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'period';
    yield object.period == null
        ? null
        : serializers.serialize(
            object.period,
            specifiedType: const FullType.nullable(
              MerchantReportExportDtoPeriodEnum,
            ),
          );
    yield r'from';
    yield object.from == null
        ? null
        : serializers.serialize(
            object.from,
            specifiedType: const FullType.nullable(String),
          );
    yield r'to';
    yield object.to == null
        ? null
        : serializers.serialize(
            object.to,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantReportExportDto object, {
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
    required MerchantReportExportDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'period':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantReportExportDtoPeriodEnum,
                    ),
                  )
                  as MerchantReportExportDtoPeriodEnum?;
          if (valueDes == null) continue;
          result.period = valueDes;
          break;
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.to = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantReportExportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantReportExportDtoBuilder();
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

/// RA §11: «اليوم», «أمس», «آخر 7 أيام», «آخر 30 يوماً»; or `from` and `to`.
class MerchantReportExportDtoPeriodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'today')
  static const MerchantReportExportDtoPeriodEnum today =
      _$merchantReportExportDtoPeriodEnum_today;
  @BuiltValueEnumConst(wireName: r'yesterday')
  static const MerchantReportExportDtoPeriodEnum yesterday =
      _$merchantReportExportDtoPeriodEnum_yesterday;
  @BuiltValueEnumConst(wireName: r'last_7_days')
  static const MerchantReportExportDtoPeriodEnum last7Days =
      _$merchantReportExportDtoPeriodEnum_last7Days;
  @BuiltValueEnumConst(wireName: r'last_30_days')
  static const MerchantReportExportDtoPeriodEnum last30Days =
      _$merchantReportExportDtoPeriodEnum_last30Days;

  static Serializer<MerchantReportExportDtoPeriodEnum> get serializer =>
      _$merchantReportExportDtoPeriodEnumSerializer;

  const MerchantReportExportDtoPeriodEnum._(String name) : super(name);

  static BuiltSet<MerchantReportExportDtoPeriodEnum> get values =>
      _$merchantReportExportDtoPeriodEnumValues;
  static MerchantReportExportDtoPeriodEnum valueOf(String name) =>
      _$merchantReportExportDtoPeriodEnumValueOf(name);
}
