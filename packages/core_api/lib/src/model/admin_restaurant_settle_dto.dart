//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_settle_dto_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_settle_dto.g.dart';

/// AdminRestaurantSettleDto
///
/// Properties:
/// * [restaurantId]
/// * [due] - The balance the screen showed.
/// * [lines]
@BuiltValue()
abstract class AdminRestaurantSettleDto
    implements
        Built<AdminRestaurantSettleDto, AdminRestaurantSettleDtoBuilder> {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  /// The balance the screen showed.
  @BuiltValueField(wireName: r'due')
  String get due;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminRestaurantSettleDtoLinesInner> get lines;

  AdminRestaurantSettleDto._();

  factory AdminRestaurantSettleDto([
    void updates(AdminRestaurantSettleDtoBuilder b),
  ]) = _$AdminRestaurantSettleDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantSettleDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantSettleDto> get serializer =>
      _$AdminRestaurantSettleDtoSerializer();
}

class _$AdminRestaurantSettleDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantSettleDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantSettleDto,
    _$AdminRestaurantSettleDto,
  ];

  @override
  final String wireName = r'AdminRestaurantSettleDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantSettleDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'due';
    yield serializers.serialize(
      object.due,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantSettleDtoLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSettleDto object, {
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
    required AdminRestaurantSettleDtoBuilder result,
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
        case r'due':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.due = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminRestaurantSettleDtoLinesInner),
                    ]),
                  )
                  as BuiltList<AdminRestaurantSettleDtoLinesInner>;
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
  AdminRestaurantSettleDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantSettleDtoBuilder();
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
