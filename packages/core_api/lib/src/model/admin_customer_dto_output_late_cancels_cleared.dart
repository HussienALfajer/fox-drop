//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_late_cancels_cleared.g.dart';

/// The latest «مسح المخالفات».
///
/// Properties:
/// * [at]
/// * [byName]
/// * [note]
@BuiltValue()
abstract class AdminCustomerDtoOutputLateCancelsCleared
    implements
        Built<
          AdminCustomerDtoOutputLateCancelsCleared,
          AdminCustomerDtoOutputLateCancelsClearedBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'byName')
  String? get byName;

  @BuiltValueField(wireName: r'note')
  String get note;

  AdminCustomerDtoOutputLateCancelsCleared._();

  factory AdminCustomerDtoOutputLateCancelsCleared([
    void updates(AdminCustomerDtoOutputLateCancelsClearedBuilder b),
  ]) = _$AdminCustomerDtoOutputLateCancelsCleared;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputLateCancelsClearedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputLateCancelsCleared> get serializer =>
      _$AdminCustomerDtoOutputLateCancelsClearedSerializer();
}

class _$AdminCustomerDtoOutputLateCancelsClearedSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputLateCancelsCleared> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputLateCancelsCleared,
    _$AdminCustomerDtoOutputLateCancelsCleared,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputLateCancelsCleared';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputLateCancelsCleared object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputLateCancelsCleared object, {
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
    required AdminCustomerDtoOutputLateCancelsClearedBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputLateCancelsCleared deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputLateCancelsClearedBuilder();
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
