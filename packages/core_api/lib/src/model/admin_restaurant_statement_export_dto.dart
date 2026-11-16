//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_statement_export_dto.g.dart';

/// AdminRestaurantStatementExportDto
///
/// Properties:
/// * [restaurantId]
/// * [from] - A business day on the city’s clock, YYYY-MM-DD.
/// * [to] - A business day on the city’s clock, YYYY-MM-DD.
@BuiltValue()
abstract class AdminRestaurantStatementExportDto
    implements
        Built<
          AdminRestaurantStatementExportDto,
          AdminRestaurantStatementExportDtoBuilder
        > {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'from')
  String get from;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'to')
  String get to;

  AdminRestaurantStatementExportDto._();

  factory AdminRestaurantStatementExportDto([
    void updates(AdminRestaurantStatementExportDtoBuilder b),
  ]) = _$AdminRestaurantStatementExportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantStatementExportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantStatementExportDto> get serializer =>
      _$AdminRestaurantStatementExportDtoSerializer();
}

class _$AdminRestaurantStatementExportDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantStatementExportDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantStatementExportDto,
    _$AdminRestaurantStatementExportDto,
  ];

  @override
  final String wireName = r'AdminRestaurantStatementExportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantStatementExportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
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
    AdminRestaurantStatementExportDto object, {
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
    required AdminRestaurantStatementExportDtoBuilder result,
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
  AdminRestaurantStatementExportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantStatementExportDtoBuilder();
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
