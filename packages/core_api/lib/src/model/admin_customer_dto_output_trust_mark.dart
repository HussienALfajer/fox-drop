//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_trust_mark.g.dart';

/// The latest «توثيق» or «إزالة الثقة».
///
/// Properties:
/// * [at]
/// * [byName]
/// * [note]
/// * [trusted]
@BuiltValue()
abstract class AdminCustomerDtoOutputTrustMark
    implements
        Built<
          AdminCustomerDtoOutputTrustMark,
          AdminCustomerDtoOutputTrustMarkBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'byName')
  String? get byName;

  @BuiltValueField(wireName: r'note')
  String get note;

  @BuiltValueField(wireName: r'trusted')
  bool get trusted;

  AdminCustomerDtoOutputTrustMark._();

  factory AdminCustomerDtoOutputTrustMark([
    void updates(AdminCustomerDtoOutputTrustMarkBuilder b),
  ]) = _$AdminCustomerDtoOutputTrustMark;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputTrustMarkBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputTrustMark> get serializer =>
      _$AdminCustomerDtoOutputTrustMarkSerializer();
}

class _$AdminCustomerDtoOutputTrustMarkSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputTrustMark> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputTrustMark,
    _$AdminCustomerDtoOutputTrustMark,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputTrustMark';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputTrustMark object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'byName';
    yield object.byName == null
        ? null
        : serializers.serialize(
            object.byName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
    yield r'trusted';
    yield serializers.serialize(
      object.trusted,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputTrustMark object, {
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
    required AdminCustomerDtoOutputTrustMarkBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'byName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.byName = valueDes;
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
        case r'trusted':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.trusted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputTrustMark deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputTrustMarkBuilder();
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
