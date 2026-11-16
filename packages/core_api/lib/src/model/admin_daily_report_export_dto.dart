//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_daily_report_export_dto.g.dart';

/// AdminDailyReportExportDto
///
/// Properties:
/// * [cityId]
/// * [day] - A business day on the city’s clock, YYYY-MM-DD.
@BuiltValue()
abstract class AdminDailyReportExportDto
    implements
        Built<AdminDailyReportExportDto, AdminDailyReportExportDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'day')
  String get day;

  AdminDailyReportExportDto._();

  factory AdminDailyReportExportDto([
    void updates(AdminDailyReportExportDtoBuilder b),
  ]) = _$AdminDailyReportExportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDailyReportExportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDailyReportExportDto> get serializer =>
      _$AdminDailyReportExportDtoSerializer();
}

class _$AdminDailyReportExportDtoSerializer
    implements PrimitiveSerializer<AdminDailyReportExportDto> {
  @override
  final Iterable<Type> types = const [
    AdminDailyReportExportDto,
    _$AdminDailyReportExportDto,
  ];

  @override
  final String wireName = r'AdminDailyReportExportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDailyReportExportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'day';
    yield serializers.serialize(
      object.day,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDailyReportExportDto object, {
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
    required AdminDailyReportExportDtoBuilder result,
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
        case r'day':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.day = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDailyReportExportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDailyReportExportDtoBuilder();
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
