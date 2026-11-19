//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_change_money_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_item_output.g.dart';

/// AdminChangeItemOutput
///
/// Properties:
/// * [name]
/// * [description]
/// * [photoKey]
/// * [price]
@BuiltValue()
abstract class AdminChangeItemOutput
    implements Built<AdminChangeItemOutput, AdminChangeItemOutputBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'photoKey')
  String? get photoKey;

  @BuiltValueField(wireName: r'price')
  AdminChangeMoneyOutput get price;

  AdminChangeItemOutput._();

  factory AdminChangeItemOutput([
    void updates(AdminChangeItemOutputBuilder b),
  ]) = _$AdminChangeItemOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeItemOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeItemOutput> get serializer =>
      _$AdminChangeItemOutputSerializer();
}

class _$AdminChangeItemOutputSerializer
    implements PrimitiveSerializer<AdminChangeItemOutput> {
  @override
  final Iterable<Type> types = const [
    AdminChangeItemOutput,
    _$AdminChangeItemOutput,
  ];

  @override
  final String wireName = r'AdminChangeItemOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeItemOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null
        ? null
        : serializers.serialize(
            object.description,
            specifiedType: const FullType.nullable(String),
          );
    yield r'photoKey';
    yield object.photoKey == null
        ? null
        : serializers.serialize(
            object.photoKey,
            specifiedType: const FullType.nullable(String),
          );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(AdminChangeMoneyOutput),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeItemOutput object, {
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
    required AdminChangeItemOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'photoKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.photoKey = valueDes;
          break;
        case r'price':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminChangeMoneyOutput),
                  )
                  as AdminChangeMoneyOutput;
          result.price.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChangeItemOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeItemOutputBuilder();
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
