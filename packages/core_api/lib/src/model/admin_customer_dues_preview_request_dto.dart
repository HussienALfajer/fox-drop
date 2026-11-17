//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_open_drawer_session_dto_floats_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dues_preview_request_dto.g.dart';

/// AdminCustomerDuesPreviewRequestDto
///
/// Properties:
/// * [cityId]
/// * [customerId]
/// * [lines] - The cash per currency; none to read the dues alone.
@BuiltValue()
abstract class AdminCustomerDuesPreviewRequestDto
    implements
        Built<
          AdminCustomerDuesPreviewRequestDto,
          AdminCustomerDuesPreviewRequestDtoBuilder
        > {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'customerId')
  String get customerId;

  /// The cash per currency; none to read the dues alone.
  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminOpenDrawerSessionDtoFloatsInner> get lines;

  AdminCustomerDuesPreviewRequestDto._();

  factory AdminCustomerDuesPreviewRequestDto([
    void updates(AdminCustomerDuesPreviewRequestDtoBuilder b),
  ]) = _$AdminCustomerDuesPreviewRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDuesPreviewRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDuesPreviewRequestDto> get serializer =>
      _$AdminCustomerDuesPreviewRequestDtoSerializer();
}

class _$AdminCustomerDuesPreviewRequestDtoSerializer
    implements PrimitiveSerializer<AdminCustomerDuesPreviewRequestDto> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDuesPreviewRequestDto,
    _$AdminCustomerDuesPreviewRequestDto,
  ];

  @override
  final String wireName = r'AdminCustomerDuesPreviewRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDuesPreviewRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'customerId';
    yield serializers.serialize(
      object.customerId,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOpenDrawerSessionDtoFloatsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDuesPreviewRequestDto object, {
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
    required AdminCustomerDuesPreviewRequestDtoBuilder result,
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
        case r'customerId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.customerId = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOpenDrawerSessionDtoFloatsInner),
                    ]),
                  )
                  as BuiltList<AdminOpenDrawerSessionDtoFloatsInner>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDuesPreviewRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDuesPreviewRequestDtoBuilder();
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
