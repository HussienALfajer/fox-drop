//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_open_drawer_session_dto_floats_inner.g.dart';

/// AdminOpenDrawerSessionDtoFloatsInner
///
/// Properties:
/// * [currency]
/// * [amount]
@BuiltValue()
abstract class AdminOpenDrawerSessionDtoFloatsInner
    implements
        Built<
          AdminOpenDrawerSessionDtoFloatsInner,
          AdminOpenDrawerSessionDtoFloatsInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  AdminOpenDrawerSessionDtoFloatsInner._();

  factory AdminOpenDrawerSessionDtoFloatsInner([
    void updates(AdminOpenDrawerSessionDtoFloatsInnerBuilder b),
  ]) = _$AdminOpenDrawerSessionDtoFloatsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOpenDrawerSessionDtoFloatsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOpenDrawerSessionDtoFloatsInner> get serializer =>
      _$AdminOpenDrawerSessionDtoFloatsInnerSerializer();
}

class _$AdminOpenDrawerSessionDtoFloatsInnerSerializer
    implements PrimitiveSerializer<AdminOpenDrawerSessionDtoFloatsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOpenDrawerSessionDtoFloatsInner,
    _$AdminOpenDrawerSessionDtoFloatsInner,
  ];

  @override
  final String wireName = r'AdminOpenDrawerSessionDtoFloatsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOpenDrawerSessionDtoFloatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOpenDrawerSessionDtoFloatsInner object, {
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
    required AdminOpenDrawerSessionDtoFloatsInnerBuilder result,
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
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOpenDrawerSessionDtoFloatsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOpenDrawerSessionDtoFloatsInnerBuilder();
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
