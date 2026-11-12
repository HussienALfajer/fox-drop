//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_current_drawer_session_dto_output_session_currencies_inner.g.dart';

/// AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner
///
/// Properties:
/// * [currency]
/// * [openingFloat]
/// * [expected] - The float plus the cash moved; as at the close once closed.
/// * [counted]
/// * [variance]
@BuiltValue()
abstract class AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner
    implements
        Built<
          AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner,
          AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'openingFloat')
  String get openingFloat;

  /// The float plus the cash moved; as at the close once closed.
  @BuiltValueField(wireName: r'expected')
  String get expected;

  @BuiltValueField(wireName: r'counted')
  String? get counted;

  @BuiltValueField(wireName: r'variance')
  String? get variance;

  AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner._();

  factory AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner([
    void updates(
      AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder b,
    ),
  ]) = _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner>
  get serializer =>
      _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerSerializer();
}

class _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerSerializer
    implements
        PrimitiveSerializer<
          AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner,
    _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner,
  ];

  @override
  final String wireName =
      r'AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'openingFloat';
    yield serializers.serialize(
      object.openingFloat,
      specifiedType: const FullType(String),
    );
    yield r'expected';
    yield serializers.serialize(
      object.expected,
      specifiedType: const FullType(String),
    );
    yield r'counted';
    yield object.counted == null
        ? null
        : serializers.serialize(
            object.counted,
            specifiedType: const FullType.nullable(String),
          );
    yield r'variance';
    yield object.variance == null
        ? null
        : serializers.serialize(
            object.variance,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner object, {
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
    required AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder
    result,
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
        case r'openingFloat':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.openingFloat = valueDes;
          break;
        case r'expected':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.expected = valueDes;
          break;
        case r'counted':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.counted = valueDes;
          break;
        case r'variance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.variance = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder();
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
