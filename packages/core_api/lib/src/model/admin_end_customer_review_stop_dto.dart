//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_end_customer_review_stop_dto.g.dart';

/// AdminEndCustomerReviewStopDto
///
/// Properties:
/// * [cityId]
/// * [stopId] - The open review stop the panel showed.
/// * [note] - The required reason.
@BuiltValue()
abstract class AdminEndCustomerReviewStopDto
    implements
        Built<
          AdminEndCustomerReviewStopDto,
          AdminEndCustomerReviewStopDtoBuilder
        > {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The open review stop the panel showed.
  @BuiltValueField(wireName: r'stopId')
  String get stopId;

  /// The required reason.
  @BuiltValueField(wireName: r'note')
  String get note;

  AdminEndCustomerReviewStopDto._();

  factory AdminEndCustomerReviewStopDto([
    void updates(AdminEndCustomerReviewStopDtoBuilder b),
  ]) = _$AdminEndCustomerReviewStopDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEndCustomerReviewStopDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEndCustomerReviewStopDto> get serializer =>
      _$AdminEndCustomerReviewStopDtoSerializer();
}

class _$AdminEndCustomerReviewStopDtoSerializer
    implements PrimitiveSerializer<AdminEndCustomerReviewStopDto> {
  @override
  final Iterable<Type> types = const [
    AdminEndCustomerReviewStopDto,
    _$AdminEndCustomerReviewStopDto,
  ];

  @override
  final String wireName = r'AdminEndCustomerReviewStopDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEndCustomerReviewStopDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'stopId';
    yield serializers.serialize(
      object.stopId,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEndCustomerReviewStopDto object, {
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
    required AdminEndCustomerReviewStopDtoBuilder result,
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
        case r'stopId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.stopId = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEndCustomerReviewStopDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEndCustomerReviewStopDtoBuilder();
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
