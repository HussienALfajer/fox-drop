//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_activation_kit_items_inner.g.dart';

/// AdminCaptainApplicationDtoOutputActivationKitItemsInner
///
/// Properties:
/// * [code]
/// * [label]
/// * [size]
/// * [quantity]
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputActivationKitItemsInner
    implements
        Built<
          AdminCaptainApplicationDtoOutputActivationKitItemsInner,
          AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'size')
  String? get size;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  AdminCaptainApplicationDtoOutputActivationKitItemsInner._();

  factory AdminCaptainApplicationDtoOutputActivationKitItemsInner([
    void updates(
      AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder b,
    ),
  ]) = _$AdminCaptainApplicationDtoOutputActivationKitItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputActivationKitItemsInner>
  get serializer =>
      _$AdminCaptainApplicationDtoOutputActivationKitItemsInnerSerializer();
}

class _$AdminCaptainApplicationDtoOutputActivationKitItemsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainApplicationDtoOutputActivationKitItemsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputActivationKitItemsInner,
    _$AdminCaptainApplicationDtoOutputActivationKitItemsInner,
  ];

  @override
  final String wireName =
      r'AdminCaptainApplicationDtoOutputActivationKitItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationKitItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'size';
    yield object.size == null
        ? null
        : serializers.serialize(
            object.size,
            specifiedType: const FullType.nullable(String),
          );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationKitItemsInner object, {
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
    required AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'size':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.size = valueDes;
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputActivationKitItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder();
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
