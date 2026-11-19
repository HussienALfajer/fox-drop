//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_approve_dto.g.dart';

/// AdminChangeApproveDto
///
/// Properties:
/// * [seen] - The `updatedAt` of the request's view the reviewer saw.
/// * [name] - The reviewer's correction of the name asked (RA §9.5).
/// * [description]
@BuiltValue()
abstract class AdminChangeApproveDto
    implements Built<AdminChangeApproveDto, AdminChangeApproveDtoBuilder> {
  /// The `updatedAt` of the request's view the reviewer saw.
  @BuiltValueField(wireName: r'seen')
  DateTime get seen;

  /// The reviewer's correction of the name asked (RA §9.5).
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  AdminChangeApproveDto._();

  factory AdminChangeApproveDto([
    void updates(AdminChangeApproveDtoBuilder b),
  ]) = _$AdminChangeApproveDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeApproveDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeApproveDto> get serializer =>
      _$AdminChangeApproveDtoSerializer();
}

class _$AdminChangeApproveDtoSerializer
    implements PrimitiveSerializer<AdminChangeApproveDto> {
  @override
  final Iterable<Type> types = const [
    AdminChangeApproveDto,
    _$AdminChangeApproveDto,
  ];

  @override
  final String wireName = r'AdminChangeApproveDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeApproveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'seen';
    yield serializers.serialize(
      object.seen,
      specifiedType: const FullType(DateTime),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeApproveDto object, {
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
    required AdminChangeApproveDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'seen':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.seen = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChangeApproveDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeApproveDtoBuilder();
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
