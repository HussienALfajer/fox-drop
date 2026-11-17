//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cost_report_export_dto.g.dart';

/// AdminCostReportExportDto
///
/// Properties:
/// * [cityId]
/// * [from] - A business day on the city’s clock, YYYY-MM-DD.
/// * [to] - A business day on the city’s clock, YYYY-MM-DD.
@BuiltValue()
abstract class AdminCostReportExportDto
    implements
        Built<AdminCostReportExportDto, AdminCostReportExportDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'from')
  String get from;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'to')
  String get to;

  AdminCostReportExportDto._();

  factory AdminCostReportExportDto([
    void updates(AdminCostReportExportDtoBuilder b),
  ]) = _$AdminCostReportExportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCostReportExportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCostReportExportDto> get serializer =>
      _$AdminCostReportExportDtoSerializer();
}

class _$AdminCostReportExportDtoSerializer
    implements PrimitiveSerializer<AdminCostReportExportDto> {
  @override
  final Iterable<Type> types = const [
    AdminCostReportExportDto,
    _$AdminCostReportExportDto,
  ];

  @override
  final String wireName = r'AdminCostReportExportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCostReportExportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCostReportExportDto object, {
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
    required AdminCostReportExportDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCostReportExportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCostReportExportDtoBuilder();
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
