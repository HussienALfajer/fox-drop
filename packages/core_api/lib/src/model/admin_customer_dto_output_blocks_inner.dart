//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_blocks_inner.g.dart';

/// AdminCustomerDtoOutputBlocksInner
///
/// Properties:
/// * [id]
/// * [kind]
/// * [reason]
/// * [reasonLabel]
/// * [note]
/// * [until]
/// * [duesAmount]
/// * [duesCurrency]
/// * [startedAt]
/// * [startedByName]
/// * [endedAt] - A duration that ran out ends at its time.
/// * [endedByName]
/// * [endNote]
/// * [inForce]
@BuiltValue()
abstract class AdminCustomerDtoOutputBlocksInner
    implements
        Built<
          AdminCustomerDtoOutputBlocksInner,
          AdminCustomerDtoOutputBlocksInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  AdminCustomerDtoOutputBlocksInnerKindEnum get kind;
  // enum kindEnum {  until,  indefinite,  dues,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'reasonLabel')
  String get reasonLabel;

  @BuiltValueField(wireName: r'note')
  String get note;

  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  @BuiltValueField(wireName: r'duesAmount')
  String? get duesAmount;

  @BuiltValueField(wireName: r'duesCurrency')
  String? get duesCurrency;

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'startedByName')
  String? get startedByName;

  /// A duration that ran out ends at its time.
  @BuiltValueField(wireName: r'endedAt')
  DateTime? get endedAt;

  @BuiltValueField(wireName: r'endedByName')
  String? get endedByName;

  @BuiltValueField(wireName: r'endNote')
  String? get endNote;

  @BuiltValueField(wireName: r'inForce')
  bool get inForce;

  AdminCustomerDtoOutputBlocksInner._();

  factory AdminCustomerDtoOutputBlocksInner([
    void updates(AdminCustomerDtoOutputBlocksInnerBuilder b),
  ]) = _$AdminCustomerDtoOutputBlocksInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputBlocksInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputBlocksInner> get serializer =>
      _$AdminCustomerDtoOutputBlocksInnerSerializer();
}

class _$AdminCustomerDtoOutputBlocksInnerSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputBlocksInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputBlocksInner,
    _$AdminCustomerDtoOutputBlocksInner,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputBlocksInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputBlocksInner object, {
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
      specifiedType: const FullType(AdminCustomerDtoOutputBlocksInnerKindEnum),
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
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'duesAmount';
    yield object.duesAmount == null
        ? null
        : serializers.serialize(
            object.duesAmount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'duesCurrency';
    yield object.duesCurrency == null
        ? null
        : serializers.serialize(
            object.duesCurrency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'startedByName';
    yield object.startedByName == null
        ? null
        : serializers.serialize(
            object.startedByName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'endedAt';
    yield object.endedAt == null
        ? null
        : serializers.serialize(
            object.endedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'endedByName';
    yield object.endedByName == null
        ? null
        : serializers.serialize(
            object.endedByName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'endNote';
    yield object.endNote == null
        ? null
        : serializers.serialize(
            object.endNote,
            specifiedType: const FullType.nullable(String),
          );
    yield r'inForce';
    yield serializers.serialize(
      object.inForce,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputBlocksInner object, {
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
    required AdminCustomerDtoOutputBlocksInnerBuilder result,
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
                      AdminCustomerDtoOutputBlocksInnerKindEnum,
                    ),
                  )
                  as AdminCustomerDtoOutputBlocksInnerKindEnum;
          result.kind = valueDes;
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
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
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
        case r'duesAmount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.duesAmount = valueDes;
          break;
        case r'duesCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.duesCurrency = valueDes;
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
        case r'startedByName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.startedByName = valueDes;
          break;
        case r'endedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.endedAt = valueDes;
          break;
        case r'endedByName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.endedByName = valueDes;
          break;
        case r'endNote':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.endNote = valueDes;
          break;
        case r'inForce':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.inForce = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputBlocksInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputBlocksInnerBuilder();
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

class AdminCustomerDtoOutputBlocksInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'until')
  static const AdminCustomerDtoOutputBlocksInnerKindEnum until =
      _$adminCustomerDtoOutputBlocksInnerKindEnum_until;
  @BuiltValueEnumConst(wireName: r'indefinite')
  static const AdminCustomerDtoOutputBlocksInnerKindEnum indefinite =
      _$adminCustomerDtoOutputBlocksInnerKindEnum_indefinite;
  @BuiltValueEnumConst(wireName: r'dues')
  static const AdminCustomerDtoOutputBlocksInnerKindEnum dues =
      _$adminCustomerDtoOutputBlocksInnerKindEnum_dues;

  static Serializer<AdminCustomerDtoOutputBlocksInnerKindEnum> get serializer =>
      _$adminCustomerDtoOutputBlocksInnerKindEnumSerializer;

  const AdminCustomerDtoOutputBlocksInnerKindEnum._(String name) : super(name);

  static BuiltSet<AdminCustomerDtoOutputBlocksInnerKindEnum> get values =>
      _$adminCustomerDtoOutputBlocksInnerKindEnumValues;
  static AdminCustomerDtoOutputBlocksInnerKindEnum valueOf(String name) =>
      _$adminCustomerDtoOutputBlocksInnerKindEnumValueOf(name);
}
