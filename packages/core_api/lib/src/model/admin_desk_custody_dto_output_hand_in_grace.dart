//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_desk_custody_dto_output_hand_in_grace.g.dart';

/// The hand-in grace running now (AP §8.5.4), or null.
///
/// Properties:
/// * [id]
/// * [until] - The next business-day cutoff when it was granted.
/// * [reason]
/// * [bulk]
/// * [grantedAt]
@BuiltValue()
abstract class AdminDeskCustodyDtoOutputHandInGrace
    implements
        Built<
          AdminDeskCustodyDtoOutputHandInGrace,
          AdminDeskCustodyDtoOutputHandInGraceBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// The next business-day cutoff when it was granted.
  @BuiltValueField(wireName: r'until')
  DateTime get until;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'bulk')
  bool get bulk;

  @BuiltValueField(wireName: r'grantedAt')
  DateTime get grantedAt;

  AdminDeskCustodyDtoOutputHandInGrace._();

  factory AdminDeskCustodyDtoOutputHandInGrace([
    void updates(AdminDeskCustodyDtoOutputHandInGraceBuilder b),
  ]) = _$AdminDeskCustodyDtoOutputHandInGrace;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeskCustodyDtoOutputHandInGraceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeskCustodyDtoOutputHandInGrace> get serializer =>
      _$AdminDeskCustodyDtoOutputHandInGraceSerializer();
}

class _$AdminDeskCustodyDtoOutputHandInGraceSerializer
    implements PrimitiveSerializer<AdminDeskCustodyDtoOutputHandInGrace> {
  @override
  final Iterable<Type> types = const [
    AdminDeskCustodyDtoOutputHandInGrace,
    _$AdminDeskCustodyDtoOutputHandInGrace,
  ];

  @override
  final String wireName = r'AdminDeskCustodyDtoOutputHandInGrace';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeskCustodyDtoOutputHandInGrace object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(DateTime),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'bulk';
    yield serializers.serialize(
      object.bulk,
      specifiedType: const FullType(bool),
    );
    yield r'grantedAt';
    yield serializers.serialize(
      object.grantedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeskCustodyDtoOutputHandInGrace object, {
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
    required AdminDeskCustodyDtoOutputHandInGraceBuilder result,
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
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.until = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'bulk':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.bulk = valueDes;
          break;
        case r'grantedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.grantedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeskCustodyDtoOutputHandInGrace deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeskCustodyDtoOutputHandInGraceBuilder();
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
