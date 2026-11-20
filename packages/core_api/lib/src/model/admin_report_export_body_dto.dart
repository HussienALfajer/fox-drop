//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_export_body_dto.g.dart';

/// AdminReportExportBodyDto
///
/// Properties:
/// * [cityId]
/// * [from] - The first business day.
/// * [to] - The last business day, included; at most 366 days, not after today.
@BuiltValue()
abstract class AdminReportExportBodyDto
    implements
        Built<AdminReportExportBodyDto, AdminReportExportBodyDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The first business day.
  @BuiltValueField(wireName: r'from')
  String get from;

  /// The last business day, included; at most 366 days, not after today.
  @BuiltValueField(wireName: r'to')
  String get to;

  AdminReportExportBodyDto._();

  factory AdminReportExportBodyDto([
    void updates(AdminReportExportBodyDtoBuilder b),
  ]) = _$AdminReportExportBodyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportExportBodyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportExportBodyDto> get serializer =>
      _$AdminReportExportBodyDtoSerializer();
}

class _$AdminReportExportBodyDtoSerializer
    implements PrimitiveSerializer<AdminReportExportBodyDto> {
  @override
  final Iterable<Type> types = const [
    AdminReportExportBodyDto,
    _$AdminReportExportBodyDto,
  ];

  @override
  final String wireName = r'AdminReportExportBodyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportExportBodyDto object, {
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
    AdminReportExportBodyDto object, {
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
    required AdminReportExportBodyDtoBuilder result,
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
  AdminReportExportBodyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportExportBodyDtoBuilder();
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
