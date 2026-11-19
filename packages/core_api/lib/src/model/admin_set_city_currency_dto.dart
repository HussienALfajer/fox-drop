//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_city_currency_dto.g.dart';

/// AdminSetCityCurrencyDto
///
/// Properties:
/// * [displayOrder]
/// * [enabled]
/// * [reason] - Why, for the audit log; optional.
@BuiltValue()
abstract class AdminSetCityCurrencyDto
    implements Built<AdminSetCityCurrencyDto, AdminSetCityCurrencyDtoBuilder> {
  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Why, for the audit log; optional.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminSetCityCurrencyDto._();

  factory AdminSetCityCurrencyDto([
    void updates(AdminSetCityCurrencyDtoBuilder b),
  ]) = _$AdminSetCityCurrencyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetCityCurrencyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetCityCurrencyDto> get serializer =>
      _$AdminSetCityCurrencyDtoSerializer();
}

class _$AdminSetCityCurrencyDtoSerializer
    implements PrimitiveSerializer<AdminSetCityCurrencyDto> {
  @override
  final Iterable<Type> types = const [
    AdminSetCityCurrencyDto,
    _$AdminSetCityCurrencyDto,
  ];

  @override
  final String wireName = r'AdminSetCityCurrencyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetCityCurrencyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
      specifiedType: const FullType(int),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetCityCurrencyDto object, {
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
    required AdminSetCityCurrencyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'displayOrder':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.displayOrder = valueDes;
          break;
        case r'enabled':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.enabled = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
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
  AdminSetCityCurrencyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetCityCurrencyDtoBuilder();
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
