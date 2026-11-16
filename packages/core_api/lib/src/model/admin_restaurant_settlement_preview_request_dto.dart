//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_open_drawer_session_dto_floats_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_settlement_preview_request_dto.g.dart';

/// AdminRestaurantSettlementPreviewRequestDto
///
/// Properties:
/// * [restaurantId]
/// * [lines] - The cash per currency; none to read the balance alone.
@BuiltValue()
abstract class AdminRestaurantSettlementPreviewRequestDto
    implements
        Built<
          AdminRestaurantSettlementPreviewRequestDto,
          AdminRestaurantSettlementPreviewRequestDtoBuilder
        > {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  /// The cash per currency; none to read the balance alone.
  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminOpenDrawerSessionDtoFloatsInner> get lines;

  AdminRestaurantSettlementPreviewRequestDto._();

  factory AdminRestaurantSettlementPreviewRequestDto([
    void updates(AdminRestaurantSettlementPreviewRequestDtoBuilder b),
  ]) = _$AdminRestaurantSettlementPreviewRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantSettlementPreviewRequestDtoBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantSettlementPreviewRequestDto>
  get serializer => _$AdminRestaurantSettlementPreviewRequestDtoSerializer();
}

class _$AdminRestaurantSettlementPreviewRequestDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantSettlementPreviewRequestDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantSettlementPreviewRequestDto,
    _$AdminRestaurantSettlementPreviewRequestDto,
  ];

  @override
  final String wireName = r'AdminRestaurantSettlementPreviewRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantSettlementPreviewRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
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
    AdminRestaurantSettlementPreviewRequestDto object, {
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
    required AdminRestaurantSettlementPreviewRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
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
  AdminRestaurantSettlementPreviewRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantSettlementPreviewRequestDtoBuilder();
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
