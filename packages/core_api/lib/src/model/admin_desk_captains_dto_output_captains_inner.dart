//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_desk_captains_dto_output_captains_inner.g.dart';

/// AdminDeskCaptainsDtoOutputCaptainsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [status]
@BuiltValue()
abstract class AdminDeskCaptainsDtoOutputCaptainsInner
    implements
        Built<
          AdminDeskCaptainsDtoOutputCaptainsInner,
          AdminDeskCaptainsDtoOutputCaptainsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum get status;
  // enum statusEnum {  active,  suspended,  terminated,  };

  AdminDeskCaptainsDtoOutputCaptainsInner._();

  factory AdminDeskCaptainsDtoOutputCaptainsInner([
    void updates(AdminDeskCaptainsDtoOutputCaptainsInnerBuilder b),
  ]) = _$AdminDeskCaptainsDtoOutputCaptainsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeskCaptainsDtoOutputCaptainsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeskCaptainsDtoOutputCaptainsInner> get serializer =>
      _$AdminDeskCaptainsDtoOutputCaptainsInnerSerializer();
}

class _$AdminDeskCaptainsDtoOutputCaptainsInnerSerializer
    implements PrimitiveSerializer<AdminDeskCaptainsDtoOutputCaptainsInner> {
  @override
  final Iterable<Type> types = const [
    AdminDeskCaptainsDtoOutputCaptainsInner,
    _$AdminDeskCaptainsDtoOutputCaptainsInner,
  ];

  @override
  final String wireName = r'AdminDeskCaptainsDtoOutputCaptainsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeskCaptainsDtoOutputCaptainsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeskCaptainsDtoOutputCaptainsInner object, {
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
    required AdminDeskCaptainsDtoOutputCaptainsInnerBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum,
                    ),
                  )
                  as AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeskCaptainsDtoOutputCaptainsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeskCaptainsDtoOutputCaptainsInnerBuilder();
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

class AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum active =
      _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum suspended =
      _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum terminated =
      _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_terminated;

  static Serializer<AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum>
  get serializer =>
      _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnumSerializer;

  const AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum>
  get values => _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnumValues;
  static AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum valueOf(
    String name,
  ) => _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnumValueOf(name);
}
