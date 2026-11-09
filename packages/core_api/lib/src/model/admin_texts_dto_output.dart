//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_texts_dto_output_contact.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_texts_dto_output.g.dart';

/// AdminTextsDtoOutput
///
/// Properties:
/// * [workRules] - CA §11.4, plain text with one rule per line.
/// * [contact] 
@BuiltValue()
abstract class AdminTextsDtoOutput implements Built<AdminTextsDtoOutput, AdminTextsDtoOutputBuilder> {
  /// CA §11.4, plain text with one rule per line.
  @BuiltValueField(wireName: r'workRules')
  String get workRules;

  @BuiltValueField(wireName: r'contact')
  AdminTextsDtoOutputContact get contact;

  AdminTextsDtoOutput._();

  factory AdminTextsDtoOutput([void updates(AdminTextsDtoOutputBuilder b)]) = _$AdminTextsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTextsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTextsDtoOutput> get serializer => _$AdminTextsDtoOutputSerializer();
}

class _$AdminTextsDtoOutputSerializer implements PrimitiveSerializer<AdminTextsDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminTextsDtoOutput, _$AdminTextsDtoOutput];

  @override
  final String wireName = r'AdminTextsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTextsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'workRules';
    yield serializers.serialize(
      object.workRules,
      specifiedType: const FullType(String),
    );
    yield r'contact';
    yield serializers.serialize(
      object.contact,
      specifiedType: const FullType(AdminTextsDtoOutputContact),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTextsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTextsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'workRules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.workRules = valueDes;
          break;
        case r'contact':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminTextsDtoOutputContact),
          ) as AdminTextsDtoOutputContact;
          result.contact.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTextsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTextsDtoOutputBuilder();
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


