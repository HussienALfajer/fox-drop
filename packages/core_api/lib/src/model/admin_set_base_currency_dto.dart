//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_base_currency_dto.g.dart';

/// AdminSetBaseCurrencyDto
///
/// Properties:
/// * [currency]
/// * [reason] - Why, for the audit log; optional.
@BuiltValue()
abstract class AdminSetBaseCurrencyDto
    implements Built<AdminSetBaseCurrencyDto, AdminSetBaseCurrencyDtoBuilder> {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// Why, for the audit log; optional.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminSetBaseCurrencyDto._();

  factory AdminSetBaseCurrencyDto([
    void updates(AdminSetBaseCurrencyDtoBuilder b),
  ]) = _$AdminSetBaseCurrencyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetBaseCurrencyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetBaseCurrencyDto> get serializer =>
      _$AdminSetBaseCurrencyDtoSerializer();
}

class _$AdminSetBaseCurrencyDtoSerializer
    implements PrimitiveSerializer<AdminSetBaseCurrencyDto> {
  @override
  final Iterable<Type> types = const [
    AdminSetBaseCurrencyDto,
    _$AdminSetBaseCurrencyDto,
  ];

  @override
  final String wireName = r'AdminSetBaseCurrencyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetBaseCurrencyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
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
    AdminSetBaseCurrencyDto object, {
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
    required AdminSetBaseCurrencyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
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
  AdminSetBaseCurrencyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetBaseCurrencyDtoBuilder();
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
