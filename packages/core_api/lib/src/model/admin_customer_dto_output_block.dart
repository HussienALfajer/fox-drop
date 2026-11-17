//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_block.g.dart';

/// The block in force: a duration or until further notice.
///
/// Properties:
/// * [id]
/// * [kind]
/// * [until]
/// * [reason]
/// * [reasonLabel]
/// * [customerText]
/// * [note]
/// * [startedAt]
/// * [viaAccountId] - The device block (slice 2.25d): the account signed in on the same device whose block this is; null for the line's own, which «فك الحظر» ends.
@BuiltValue()
abstract class AdminCustomerDtoOutputBlock
    implements
        Built<AdminCustomerDtoOutputBlock, AdminCustomerDtoOutputBlockBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  AdminCustomerDtoOutputBlockKindEnum get kind;
  // enum kindEnum {  until,  indefinite,  dues,  };

  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'reasonLabel')
  String get reasonLabel;

  @BuiltValueField(wireName: r'customerText')
  String get customerText;

  @BuiltValueField(wireName: r'note')
  String get note;

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  /// The device block (slice 2.25d): the account signed in on the same device whose block this is; null for the line's own, which «فك الحظر» ends.
  @BuiltValueField(wireName: r'viaAccountId')
  String? get viaAccountId;

  AdminCustomerDtoOutputBlock._();

  factory AdminCustomerDtoOutputBlock([
    void updates(AdminCustomerDtoOutputBlockBuilder b),
  ]) = _$AdminCustomerDtoOutputBlock;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputBlockBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputBlock> get serializer =>
      _$AdminCustomerDtoOutputBlockSerializer();
}

class _$AdminCustomerDtoOutputBlockSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputBlock> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputBlock,
    _$AdminCustomerDtoOutputBlock,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputBlock';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputBlock object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminCustomerDtoOutputBlockKindEnum),
    );
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'reasonLabel';
    yield serializers.serialize(
      object.reasonLabel,
      specifiedType: const FullType(String),
    );
    yield r'customerText';
    yield serializers.serialize(
      object.customerText,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'viaAccountId';
    yield object.viaAccountId == null
        ? null
        : serializers.serialize(
            object.viaAccountId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputBlock object, {
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
    required AdminCustomerDtoOutputBlockBuilder result,
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
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCustomerDtoOutputBlockKindEnum,
                    ),
                  )
                  as AdminCustomerDtoOutputBlockKindEnum;
          result.kind = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
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
        case r'reasonLabel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reasonLabel = valueDes;
          break;
        case r'customerText':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.customerText = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
          break;
        case r'startedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.startedAt = valueDes;
          break;
        case r'viaAccountId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.viaAccountId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputBlock deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputBlockBuilder();
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

class AdminCustomerDtoOutputBlockKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'until')
  static const AdminCustomerDtoOutputBlockKindEnum until =
      _$adminCustomerDtoOutputBlockKindEnum_until;
  @BuiltValueEnumConst(wireName: r'indefinite')
  static const AdminCustomerDtoOutputBlockKindEnum indefinite =
      _$adminCustomerDtoOutputBlockKindEnum_indefinite;
  @BuiltValueEnumConst(wireName: r'dues')
  static const AdminCustomerDtoOutputBlockKindEnum dues =
      _$adminCustomerDtoOutputBlockKindEnum_dues;

  static Serializer<AdminCustomerDtoOutputBlockKindEnum> get serializer =>
      _$adminCustomerDtoOutputBlockKindEnumSerializer;

  const AdminCustomerDtoOutputBlockKindEnum._(String name) : super(name);

  static BuiltSet<AdminCustomerDtoOutputBlockKindEnum> get values =>
      _$adminCustomerDtoOutputBlockKindEnumValues;
  static AdminCustomerDtoOutputBlockKindEnum valueOf(String name) =>
      _$adminCustomerDtoOutputBlockKindEnumValueOf(name);
}
