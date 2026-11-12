//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_desk_custody_dto_output_closed_due.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_desk_custody_dto_output_currencies_inner.dart';
import 'package:core_api/src/model/admin_desk_custody_dto_output_usage.dart';
import 'package:core_api/src/model/admin_desk_custody_dto_output_hand_in_grace.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_desk_custody_dto_output.g.dart';

/// AdminDeskCustodyDtoOutput
///
/// Properties:
/// * [id]
/// * [name]
/// * [status]
/// * [usage]
/// * [limit]
/// * [closedDue]
/// * [lastCutoff]
/// * [currencies]
/// * [handInGrace]
/// * [closedDueBlocks] - closed_due above the tolerance with no grace running: what a grace lifts.
@BuiltValue()
abstract class AdminDeskCustodyDtoOutput
    implements
        Built<AdminDeskCustodyDtoOutput, AdminDeskCustodyDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  AdminDeskCustodyDtoOutputStatusEnum get status;
  // enum statusEnum {  active,  suspended,  terminated,  };

  @BuiltValueField(wireName: r'usage')
  AdminDeskCustodyDtoOutputUsage get usage;

  @BuiltValueField(wireName: r'limit')
  AdminDeskCustodyDtoOutputUsage get limit;

  @BuiltValueField(wireName: r'closedDue')
  AdminDeskCustodyDtoOutputClosedDue get closedDue;

  @BuiltValueField(wireName: r'lastCutoff')
  DateTime get lastCutoff;

  @BuiltValueField(wireName: r'currencies')
  BuiltList<AdminDeskCustodyDtoOutputCurrenciesInner> get currencies;

  @BuiltValueField(wireName: r'handInGrace')
  AdminDeskCustodyDtoOutputHandInGrace? get handInGrace;

  /// closed_due above the tolerance with no grace running: what a grace lifts.
  @BuiltValueField(wireName: r'closedDueBlocks')
  bool get closedDueBlocks;

  AdminDeskCustodyDtoOutput._();

  factory AdminDeskCustodyDtoOutput([
    void updates(AdminDeskCustodyDtoOutputBuilder b),
  ]) = _$AdminDeskCustodyDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeskCustodyDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeskCustodyDtoOutput> get serializer =>
      _$AdminDeskCustodyDtoOutputSerializer();
}

class _$AdminDeskCustodyDtoOutputSerializer
    implements PrimitiveSerializer<AdminDeskCustodyDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDeskCustodyDtoOutput,
    _$AdminDeskCustodyDtoOutput,
  ];

  @override
  final String wireName = r'AdminDeskCustodyDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeskCustodyDtoOutput object, {
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
      specifiedType: const FullType(AdminDeskCustodyDtoOutputStatusEnum),
    );
    yield r'usage';
    yield serializers.serialize(
      object.usage,
      specifiedType: const FullType(AdminDeskCustodyDtoOutputUsage),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(AdminDeskCustodyDtoOutputUsage),
    );
    yield r'closedDue';
    yield serializers.serialize(
      object.closedDue,
      specifiedType: const FullType(AdminDeskCustodyDtoOutputClosedDue),
    );
    yield r'lastCutoff';
    yield serializers.serialize(
      object.lastCutoff,
      specifiedType: const FullType(DateTime),
    );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDeskCustodyDtoOutputCurrenciesInner),
      ]),
    );
    yield r'handInGrace';
    yield object.handInGrace == null
        ? null
        : serializers.serialize(
            object.handInGrace,
            specifiedType: const FullType.nullable(
              AdminDeskCustodyDtoOutputHandInGrace,
            ),
          );
    yield r'closedDueBlocks';
    yield serializers.serialize(
      object.closedDueBlocks,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeskCustodyDtoOutput object, {
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
    required AdminDeskCustodyDtoOutputBuilder result,
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
                      AdminDeskCustodyDtoOutputStatusEnum,
                    ),
                  )
                  as AdminDeskCustodyDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'usage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeskCustodyDtoOutputUsage,
                    ),
                  )
                  as AdminDeskCustodyDtoOutputUsage;
          result.usage.replace(valueDes);
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeskCustodyDtoOutputUsage,
                    ),
                  )
                  as AdminDeskCustodyDtoOutputUsage;
          result.limit.replace(valueDes);
          break;
        case r'closedDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeskCustodyDtoOutputClosedDue,
                    ),
                  )
                  as AdminDeskCustodyDtoOutputClosedDue;
          result.closedDue.replace(valueDes);
          break;
        case r'lastCutoff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.lastCutoff = valueDes;
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDeskCustodyDtoOutputCurrenciesInner),
                    ]),
                  )
                  as BuiltList<AdminDeskCustodyDtoOutputCurrenciesInner>;
          result.currencies.replace(valueDes);
          break;
        case r'handInGrace':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminDeskCustodyDtoOutputHandInGrace,
                    ),
                  )
                  as AdminDeskCustodyDtoOutputHandInGrace?;
          if (valueDes == null) continue;
          result.handInGrace.replace(valueDes);
          break;
        case r'closedDueBlocks':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.closedDueBlocks = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeskCustodyDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeskCustodyDtoOutputBuilder();
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

class AdminDeskCustodyDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminDeskCustodyDtoOutputStatusEnum active =
      _$adminDeskCustodyDtoOutputStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminDeskCustodyDtoOutputStatusEnum suspended =
      _$adminDeskCustodyDtoOutputStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminDeskCustodyDtoOutputStatusEnum terminated =
      _$adminDeskCustodyDtoOutputStatusEnum_terminated;

  static Serializer<AdminDeskCustodyDtoOutputStatusEnum> get serializer =>
      _$adminDeskCustodyDtoOutputStatusEnumSerializer;

  const AdminDeskCustodyDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<AdminDeskCustodyDtoOutputStatusEnum> get values =>
      _$adminDeskCustodyDtoOutputStatusEnumValues;
  static AdminDeskCustodyDtoOutputStatusEnum valueOf(String name) =>
      _$adminDeskCustodyDtoOutputStatusEnumValueOf(name);
}
