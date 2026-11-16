//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_promo_code_report_dto_output_report.dart';
import 'package:core_api/src/model/admin_promo_codes_dto_output_codes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_promo_code_report_dto_output.g.dart';

/// AdminPromoCodeReportDtoOutput
///
/// Properties:
/// * [code]
/// * [report]
/// * [canManage] - Pause, resume and extend (marketing.manage).
@BuiltValue()
abstract class AdminPromoCodeReportDtoOutput
    implements
        Built<
          AdminPromoCodeReportDtoOutput,
          AdminPromoCodeReportDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'code')
  AdminPromoCodesDtoOutputCodesInner get code;

  @BuiltValueField(wireName: r'report')
  AdminPromoCodeReportDtoOutputReport get report;

  /// Pause, resume and extend (marketing.manage).
  @BuiltValueField(wireName: r'canManage')
  bool get canManage;

  AdminPromoCodeReportDtoOutput._();

  factory AdminPromoCodeReportDtoOutput([
    void updates(AdminPromoCodeReportDtoOutputBuilder b),
  ]) = _$AdminPromoCodeReportDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPromoCodeReportDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPromoCodeReportDtoOutput> get serializer =>
      _$AdminPromoCodeReportDtoOutputSerializer();
}

class _$AdminPromoCodeReportDtoOutputSerializer
    implements PrimitiveSerializer<AdminPromoCodeReportDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminPromoCodeReportDtoOutput,
    _$AdminPromoCodeReportDtoOutput,
  ];

  @override
  final String wireName = r'AdminPromoCodeReportDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPromoCodeReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(AdminPromoCodesDtoOutputCodesInner),
    );
    yield r'report';
    yield serializers.serialize(
      object.report,
      specifiedType: const FullType(AdminPromoCodeReportDtoOutputReport),
    );
    yield r'canManage';
    yield serializers.serialize(
      object.canManage,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPromoCodeReportDtoOutput object, {
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
    required AdminPromoCodeReportDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPromoCodesDtoOutputCodesInner,
                    ),
                  )
                  as AdminPromoCodesDtoOutputCodesInner;
          result.code.replace(valueDes);
          break;
        case r'report':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPromoCodeReportDtoOutputReport,
                    ),
                  )
                  as AdminPromoCodeReportDtoOutputReport;
          result.report.replace(valueDes);
          break;
        case r'canManage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.canManage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPromoCodeReportDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPromoCodeReportDtoOutputBuilder();
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
