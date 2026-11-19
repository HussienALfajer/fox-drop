//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_kit_dto_items_inner.g.dart';

/// AdminCaptainApplicationKitDtoItemsInner
///
/// Properties:
/// * [code] - A reason of the list kit_item.
/// * [size]
/// * [quantity]
@BuiltValue()
abstract class AdminCaptainApplicationKitDtoItemsInner
    implements
        Built<
          AdminCaptainApplicationKitDtoItemsInner,
          AdminCaptainApplicationKitDtoItemsInnerBuilder
        > {
  /// A reason of the list kit_item.
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'size')
  String? get size;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  AdminCaptainApplicationKitDtoItemsInner._();

  factory AdminCaptainApplicationKitDtoItemsInner([
    void updates(AdminCaptainApplicationKitDtoItemsInnerBuilder b),
  ]) = _$AdminCaptainApplicationKitDtoItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationKitDtoItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationKitDtoItemsInner> get serializer =>
      _$AdminCaptainApplicationKitDtoItemsInnerSerializer();
}

class _$AdminCaptainApplicationKitDtoItemsInnerSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationKitDtoItemsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationKitDtoItemsInner,
    _$AdminCaptainApplicationKitDtoItemsInner,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationKitDtoItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationKitDtoItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    if (object.size != null) {
      yield r'size';
      yield serializers.serialize(
        object.size,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationKitDtoItemsInner object, {
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
    required AdminCaptainApplicationKitDtoItemsInnerBuilder result,
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
  AdminCaptainApplicationKitDtoItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationKitDtoItemsInnerBuilder();
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
