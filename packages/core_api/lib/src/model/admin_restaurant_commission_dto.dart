//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_commission_dto.g.dart';

/// AdminRestaurantCommissionDto
///
/// Properties:
/// * [rateBp] - Basis points of the items value: 1500 is 15%.
/// * [effectiveFrom] - A later moment; null for the new orders from now.
/// * [reason] - Why, for the change log (AP §9.6.5).
@BuiltValue()
abstract class AdminRestaurantCommissionDto
    implements
        Built<
          AdminRestaurantCommissionDto,
          AdminRestaurantCommissionDtoBuilder
        > {
  /// Basis points of the items value: 1500 is 15%.
  @BuiltValueField(wireName: r'rateBp')
  int get rateBp;

  /// A later moment; null for the new orders from now.
  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime? get effectiveFrom;

  /// Why, for the change log (AP §9.6.5).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminRestaurantCommissionDto._();

  factory AdminRestaurantCommissionDto([
    void updates(AdminRestaurantCommissionDtoBuilder b),
  ]) = _$AdminRestaurantCommissionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantCommissionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantCommissionDto> get serializer =>
      _$AdminRestaurantCommissionDtoSerializer();
}

class _$AdminRestaurantCommissionDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantCommissionDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantCommissionDto,
    _$AdminRestaurantCommissionDto,
  ];

  @override
  final String wireName = r'AdminRestaurantCommissionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantCommissionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rateBp';
    yield serializers.serialize(
      object.rateBp,
      specifiedType: const FullType(int),
    );
    yield r'effectiveFrom';
    yield object.effectiveFrom == null
        ? null
        : serializers.serialize(
            object.effectiveFrom,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantCommissionDto object, {
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
    required AdminRestaurantCommissionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rateBp':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.rateBp = valueDes;
          break;
        case r'effectiveFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.effectiveFrom = valueDes;
          break;
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
  AdminRestaurantCommissionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantCommissionDtoBuilder();
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
