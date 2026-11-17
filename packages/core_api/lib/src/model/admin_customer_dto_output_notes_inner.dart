//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_notes_inner.g.dart';

/// AdminCustomerDtoOutputNotesInner
///
/// Properties:
/// * [id]
/// * [body]
/// * [authorName]
/// * [createdAt]
@BuiltValue()
abstract class AdminCustomerDtoOutputNotesInner
    implements
        Built<
          AdminCustomerDtoOutputNotesInner,
          AdminCustomerDtoOutputNotesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'authorName')
  String? get authorName;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminCustomerDtoOutputNotesInner._();

  factory AdminCustomerDtoOutputNotesInner([
    void updates(AdminCustomerDtoOutputNotesInnerBuilder b),
  ]) = _$AdminCustomerDtoOutputNotesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputNotesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputNotesInner> get serializer =>
      _$AdminCustomerDtoOutputNotesInnerSerializer();
}

class _$AdminCustomerDtoOutputNotesInnerSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputNotesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputNotesInner,
    _$AdminCustomerDtoOutputNotesInner,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputNotesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputNotesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'authorName';
    yield object.authorName == null
        ? null
        : serializers.serialize(
            object.authorName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputNotesInner object, {
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
    required AdminCustomerDtoOutputNotesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'body':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.body = valueDes;
          break;
        case r'authorName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.authorName = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputNotesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputNotesInnerBuilder();
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
