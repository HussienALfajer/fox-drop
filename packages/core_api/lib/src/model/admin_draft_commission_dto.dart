//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_draft_commission_dto_launch.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_commission_dto.g.dart';

/// AdminDraftCommissionDto
///
/// Properties:
/// * [rateBp]
/// * [launch]
@BuiltValue()
abstract class AdminDraftCommissionDto
    implements Built<AdminDraftCommissionDto, AdminDraftCommissionDtoBuilder> {
  @BuiltValueField(wireName: r'rateBp')
  int get rateBp;

  @BuiltValueField(wireName: r'launch')
  AdminDraftCommissionDtoLaunch? get launch;

  AdminDraftCommissionDto._();

  factory AdminDraftCommissionDto([
    void updates(AdminDraftCommissionDtoBuilder b),
  ]) = _$AdminDraftCommissionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftCommissionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftCommissionDto> get serializer =>
      _$AdminDraftCommissionDtoSerializer();
}

class _$AdminDraftCommissionDtoSerializer
    implements PrimitiveSerializer<AdminDraftCommissionDto> {
  @override
  final Iterable<Type> types = const [
    AdminDraftCommissionDto,
    _$AdminDraftCommissionDto,
  ];

  @override
  final String wireName = r'AdminDraftCommissionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftCommissionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rateBp';
    yield serializers.serialize(
      object.rateBp,
      specifiedType: const FullType(int),
    );
    yield r'launch';
    yield object.launch == null
        ? null
        : serializers.serialize(
            object.launch,
            specifiedType: const FullType.nullable(
              AdminDraftCommissionDtoLaunch,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftCommissionDto object, {
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
    required AdminDraftCommissionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rateBp':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.rateBp = valueDes;
          break;
        case r'launch':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminDraftCommissionDtoLaunch,
                    ),
                  )
                  as AdminDraftCommissionDtoLaunch?;
          if (valueDes == null) continue;
          result.launch.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftCommissionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftCommissionDtoBuilder();
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
