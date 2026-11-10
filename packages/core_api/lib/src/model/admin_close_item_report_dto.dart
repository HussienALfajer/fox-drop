//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_close_item_report_dto.g.dart';

/// AdminCloseItemReportDto
///
/// Properties:
/// * [reason] - Required (AP §9.3.2).
@BuiltValue()
abstract class AdminCloseItemReportDto
    implements Built<AdminCloseItemReportDto, AdminCloseItemReportDtoBuilder> {
  /// Required (AP §9.3.2).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminCloseItemReportDto._();

  factory AdminCloseItemReportDto([
    void updates(AdminCloseItemReportDtoBuilder b),
  ]) = _$AdminCloseItemReportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCloseItemReportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCloseItemReportDto> get serializer =>
      _$AdminCloseItemReportDtoSerializer();
}

class _$AdminCloseItemReportDtoSerializer
    implements PrimitiveSerializer<AdminCloseItemReportDto> {
  @override
  final Iterable<Type> types = const [
    AdminCloseItemReportDto,
    _$AdminCloseItemReportDto,
  ];

  @override
  final String wireName = r'AdminCloseItemReportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCloseItemReportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCloseItemReportDto object, {
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
    required AdminCloseItemReportDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCloseItemReportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCloseItemReportDtoBuilder();
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
