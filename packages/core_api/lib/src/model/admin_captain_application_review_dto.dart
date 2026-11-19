//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_review_dto.g.dart';

/// AdminCaptainApplicationReviewDto
///
/// Properties:
/// * [status]
/// * [reason] - Required for «مرفوض»; sent to the applicant.
@BuiltValue()
abstract class AdminCaptainApplicationReviewDto
    implements
        Built<
          AdminCaptainApplicationReviewDto,
          AdminCaptainApplicationReviewDtoBuilder
        > {
  @BuiltValueField(wireName: r'status')
  AdminCaptainApplicationReviewDtoStatusEnum get status;
  // enum statusEnum {  accepted,  rejected,  };

  /// Required for «مرفوض»; sent to the applicant.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminCaptainApplicationReviewDto._();

  factory AdminCaptainApplicationReviewDto([
    void updates(AdminCaptainApplicationReviewDtoBuilder b),
  ]) = _$AdminCaptainApplicationReviewDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationReviewDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationReviewDto> get serializer =>
      _$AdminCaptainApplicationReviewDtoSerializer();
}

class _$AdminCaptainApplicationReviewDtoSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationReviewDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationReviewDto,
    _$AdminCaptainApplicationReviewDto,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationReviewDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationReviewDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminCaptainApplicationReviewDtoStatusEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationReviewDto object, {
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
    required AdminCaptainApplicationReviewDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationReviewDtoStatusEnum,
                    ),
                  )
                  as AdminCaptainApplicationReviewDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationReviewDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationReviewDtoBuilder();
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

class AdminCaptainApplicationReviewDtoStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminCaptainApplicationReviewDtoStatusEnum accepted =
      _$adminCaptainApplicationReviewDtoStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminCaptainApplicationReviewDtoStatusEnum rejected =
      _$adminCaptainApplicationReviewDtoStatusEnum_rejected;

  static Serializer<AdminCaptainApplicationReviewDtoStatusEnum>
  get serializer => _$adminCaptainApplicationReviewDtoStatusEnumSerializer;

  const AdminCaptainApplicationReviewDtoStatusEnum._(String name) : super(name);

  static BuiltSet<AdminCaptainApplicationReviewDtoStatusEnum> get values =>
      _$adminCaptainApplicationReviewDtoStatusEnumValues;
  static AdminCaptainApplicationReviewDtoStatusEnum valueOf(String name) =>
      _$adminCaptainApplicationReviewDtoStatusEnumValueOf(name);
}
