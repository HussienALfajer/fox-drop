//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customers_found_dto_output_customers_inner.g.dart';

/// AdminCustomersFoundDtoOutputCustomersInner
///
/// Properties:
/// * [id]
/// * [name] - null until «أكمل بياناتك».
/// * [maskedPhone]
/// * [status] - «نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم» (AP §9.8).
@BuiltValue()
abstract class AdminCustomersFoundDtoOutputCustomersInner
    implements
        Built<
          AdminCustomersFoundDtoOutputCustomersInner,
          AdminCustomersFoundDtoOutputCustomersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// null until «أكمل بياناتك».
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'maskedPhone')
  String? get maskedPhone;

  /// «نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم» (AP §9.8).
  @BuiltValueField(wireName: r'status')
  AdminCustomersFoundDtoOutputCustomersInnerStatusEnum get status;
  // enum statusEnum {  active,  blocked,  dues_unpaid,  review_stop,  };

  AdminCustomersFoundDtoOutputCustomersInner._();

  factory AdminCustomersFoundDtoOutputCustomersInner([
    void updates(AdminCustomersFoundDtoOutputCustomersInnerBuilder b),
  ]) = _$AdminCustomersFoundDtoOutputCustomersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomersFoundDtoOutputCustomersInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomersFoundDtoOutputCustomersInner>
  get serializer => _$AdminCustomersFoundDtoOutputCustomersInnerSerializer();
}

class _$AdminCustomersFoundDtoOutputCustomersInnerSerializer
    implements PrimitiveSerializer<AdminCustomersFoundDtoOutputCustomersInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomersFoundDtoOutputCustomersInner,
    _$AdminCustomersFoundDtoOutputCustomersInner,
  ];

  @override
  final String wireName = r'AdminCustomersFoundDtoOutputCustomersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomersFoundDtoOutputCustomersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
            object.name,
            specifiedType: const FullType.nullable(String),
          );
    yield r'maskedPhone';
    yield object.maskedPhone == null
        ? null
        : serializers.serialize(
            object.maskedPhone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminCustomersFoundDtoOutputCustomersInnerStatusEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomersFoundDtoOutputCustomersInner object, {
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
    required AdminCustomersFoundDtoOutputCustomersInnerBuilder result,
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
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'maskedPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maskedPhone = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCustomersFoundDtoOutputCustomersInnerStatusEnum,
                    ),
                  )
                  as AdminCustomersFoundDtoOutputCustomersInnerStatusEnum;
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
  AdminCustomersFoundDtoOutputCustomersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomersFoundDtoOutputCustomersInnerBuilder();
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

/// «نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم» (AP §9.8).
class AdminCustomersFoundDtoOutputCustomersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum active =
      _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'blocked')
  static const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum blocked =
      _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_blocked;
  @BuiltValueEnumConst(wireName: r'dues_unpaid')
  static const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum duesUnpaid =
      _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_duesUnpaid;
  @BuiltValueEnumConst(wireName: r'review_stop')
  static const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum reviewStop =
      _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_reviewStop;

  static Serializer<AdminCustomersFoundDtoOutputCustomersInnerStatusEnum>
  get serializer =>
      _$adminCustomersFoundDtoOutputCustomersInnerStatusEnumSerializer;

  const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminCustomersFoundDtoOutputCustomersInnerStatusEnum>
  get values => _$adminCustomersFoundDtoOutputCustomersInnerStatusEnumValues;
  static AdminCustomersFoundDtoOutputCustomersInnerStatusEnum valueOf(
    String name,
  ) => _$adminCustomersFoundDtoOutputCustomersInnerStatusEnumValueOf(name);
}
