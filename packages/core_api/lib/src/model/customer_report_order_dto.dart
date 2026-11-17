//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_report_order_dto_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_report_order_dto.g.dart';

/// CustomerReportOrderDto
///
/// Properties:
/// * [typeCode] - A code of Content's customer_problem list (AP Appendix B).
/// * [note] - Optional, up to 300 characters; required for «أخرى» (CU §12.2).
/// * [items] - The order's lines by position with how many: required for «صنف ناقص», «صنف خطأ» and «الطلب تالف», empty for the others.
/// * [photoUploadIds] - Up to 3 photos, each from POST /v1/customer/uploads/report-photo once uploaded.
@BuiltValue()
abstract class CustomerReportOrderDto
    implements Built<CustomerReportOrderDto, CustomerReportOrderDtoBuilder> {
  /// A code of Content's customer_problem list (AP Appendix B).
  @BuiltValueField(wireName: r'typeCode')
  String get typeCode;

  /// Optional, up to 300 characters; required for «أخرى» (CU §12.2).
  @BuiltValueField(wireName: r'note')
  String? get note;

  /// The order's lines by position with how many: required for «صنف ناقص», «صنف خطأ» and «الطلب تالف», empty for the others.
  @BuiltValueField(wireName: r'items')
  BuiltList<CustomerReportOrderDtoItemsInner> get items;

  /// Up to 3 photos, each from POST /v1/customer/uploads/report-photo once uploaded.
  @BuiltValueField(wireName: r'photoUploadIds')
  BuiltList<String> get photoUploadIds;

  CustomerReportOrderDto._();

  factory CustomerReportOrderDto([
    void updates(CustomerReportOrderDtoBuilder b),
  ]) = _$CustomerReportOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerReportOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerReportOrderDto> get serializer =>
      _$CustomerReportOrderDtoSerializer();
}

class _$CustomerReportOrderDtoSerializer
    implements PrimitiveSerializer<CustomerReportOrderDto> {
  @override
  final Iterable<Type> types = const [
    CustomerReportOrderDto,
    _$CustomerReportOrderDto,
  ];

  @override
  final String wireName = r'CustomerReportOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerReportOrderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'typeCode';
    yield serializers.serialize(
      object.typeCode,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerReportOrderDtoItemsInner),
      ]),
    );
    yield r'photoUploadIds';
    yield serializers.serialize(
      object.photoUploadIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerReportOrderDto object, {
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
    required CustomerReportOrderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'typeCode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeCode = valueDes;
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
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerReportOrderDtoItemsInner),
                    ]),
                  )
                  as BuiltList<CustomerReportOrderDtoItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'photoUploadIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.photoUploadIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerReportOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerReportOrderDtoBuilder();
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
