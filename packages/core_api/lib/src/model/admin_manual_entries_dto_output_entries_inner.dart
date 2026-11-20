//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_manual_entries_dto_output_entries_inner_corrects.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_manual_entries_dto_output_entries_inner_reversed_by.dart';
import 'package:core_api/src/model/admin_manual_entries_dto_output_entries_inner_journal.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_manual_entries_dto_output_entries_inner.g.dart';

/// AdminManualEntriesDtoOutputEntriesInner
///
/// Properties:
/// * [id]
/// * [kind]
/// * [partyKind]
/// * [partyId]
/// * [partyName]
/// * [reason]
/// * [adminId]
/// * [adminName]
/// * [createdAt]
/// * [journal]
/// * [corrects]
/// * [reversedBy]
/// * [reversible]
/// * [orderId] - A financial correction from «سجل الطلبات»: the finished order it corrects.
/// * [orderNumber]
@BuiltValue()
abstract class AdminManualEntriesDtoOutputEntriesInner
    implements
        Built<
          AdminManualEntriesDtoOutputEntriesInner,
          AdminManualEntriesDtoOutputEntriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  AdminManualEntriesDtoOutputEntriesInnerKindEnum get kind;
  // enum kindEnum {  adjustment,  reversal,  };

  @BuiltValueField(wireName: r'partyKind')
  AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum get partyKind;
  // enum partyKindEnum {  captain,  restaurant,  customer,  };

  @BuiltValueField(wireName: r'partyId')
  String get partyId;

  @BuiltValueField(wireName: r'partyName')
  String get partyName;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'adminId')
  String get adminId;

  @BuiltValueField(wireName: r'adminName')
  String? get adminName;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'journal')
  AdminManualEntriesDtoOutputEntriesInnerJournal get journal;

  @BuiltValueField(wireName: r'corrects')
  AdminManualEntriesDtoOutputEntriesInnerCorrects? get corrects;

  @BuiltValueField(wireName: r'reversedBy')
  AdminManualEntriesDtoOutputEntriesInnerReversedBy? get reversedBy;

  @BuiltValueField(wireName: r'reversible')
  bool get reversible;

  /// A financial correction from «سجل الطلبات»: the finished order it corrects.
  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  AdminManualEntriesDtoOutputEntriesInner._();

  factory AdminManualEntriesDtoOutputEntriesInner([
    void updates(AdminManualEntriesDtoOutputEntriesInnerBuilder b),
  ]) = _$AdminManualEntriesDtoOutputEntriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminManualEntriesDtoOutputEntriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminManualEntriesDtoOutputEntriesInner> get serializer =>
      _$AdminManualEntriesDtoOutputEntriesInnerSerializer();
}

class _$AdminManualEntriesDtoOutputEntriesInnerSerializer
    implements PrimitiveSerializer<AdminManualEntriesDtoOutputEntriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminManualEntriesDtoOutputEntriesInner,
    _$AdminManualEntriesDtoOutputEntriesInner,
  ];

  @override
  final String wireName = r'AdminManualEntriesDtoOutputEntriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminManualEntriesDtoOutputEntriesInner object, {
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
      specifiedType: const FullType(
        AdminManualEntriesDtoOutputEntriesInnerKindEnum,
      ),
    );
    yield r'partyKind';
    yield serializers.serialize(
      object.partyKind,
      specifiedType: const FullType(
        AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum,
      ),
    );
    yield r'partyId';
    yield serializers.serialize(
      object.partyId,
      specifiedType: const FullType(String),
    );
    yield r'partyName';
    yield serializers.serialize(
      object.partyName,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'adminId';
    yield serializers.serialize(
      object.adminId,
      specifiedType: const FullType(String),
    );
    yield r'adminName';
    yield object.adminName == null
        ? null
        : serializers.serialize(
            object.adminName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'journal';
    yield serializers.serialize(
      object.journal,
      specifiedType: const FullType(
        AdminManualEntriesDtoOutputEntriesInnerJournal,
      ),
    );
    yield r'corrects';
    yield object.corrects == null
        ? null
        : serializers.serialize(
            object.corrects,
            specifiedType: const FullType.nullable(
              AdminManualEntriesDtoOutputEntriesInnerCorrects,
            ),
          );
    yield r'reversedBy';
    yield object.reversedBy == null
        ? null
        : serializers.serialize(
            object.reversedBy,
            specifiedType: const FullType.nullable(
              AdminManualEntriesDtoOutputEntriesInnerReversedBy,
            ),
          );
    yield r'reversible';
    yield serializers.serialize(
      object.reversible,
      specifiedType: const FullType(bool),
    );
    yield r'orderId';
    yield object.orderId == null
        ? null
        : serializers.serialize(
            object.orderId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'orderNumber';
    yield object.orderNumber == null
        ? null
        : serializers.serialize(
            object.orderNumber,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminManualEntriesDtoOutputEntriesInner object, {
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
    required AdminManualEntriesDtoOutputEntriesInnerBuilder result,
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
                      AdminManualEntriesDtoOutputEntriesInnerKindEnum,
                    ),
                  )
                  as AdminManualEntriesDtoOutputEntriesInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'partyKind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum,
                    ),
                  )
                  as AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum;
          result.partyKind = valueDes;
          break;
        case r'partyId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.partyId = valueDes;
          break;
        case r'partyName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.partyName = valueDes;
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
        case r'adminId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.adminId = valueDes;
          break;
        case r'adminName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.adminName = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'journal':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminManualEntriesDtoOutputEntriesInnerJournal,
                    ),
                  )
                  as AdminManualEntriesDtoOutputEntriesInnerJournal;
          result.journal.replace(valueDes);
          break;
        case r'corrects':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminManualEntriesDtoOutputEntriesInnerCorrects,
                    ),
                  )
                  as AdminManualEntriesDtoOutputEntriesInnerCorrects?;
          if (valueDes == null) continue;
          result.corrects.replace(valueDes);
          break;
        case r'reversedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminManualEntriesDtoOutputEntriesInnerReversedBy,
                    ),
                  )
                  as AdminManualEntriesDtoOutputEntriesInnerReversedBy?;
          if (valueDes == null) continue;
          result.reversedBy.replace(valueDes);
          break;
        case r'reversible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.reversible = valueDes;
          break;
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderNumber = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminManualEntriesDtoOutputEntriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminManualEntriesDtoOutputEntriesInnerBuilder();
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

class AdminManualEntriesDtoOutputEntriesInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'adjustment')
  static const AdminManualEntriesDtoOutputEntriesInnerKindEnum adjustment =
      _$adminManualEntriesDtoOutputEntriesInnerKindEnum_adjustment;
  @BuiltValueEnumConst(wireName: r'reversal')
  static const AdminManualEntriesDtoOutputEntriesInnerKindEnum reversal =
      _$adminManualEntriesDtoOutputEntriesInnerKindEnum_reversal;

  static Serializer<AdminManualEntriesDtoOutputEntriesInnerKindEnum>
  get serializer => _$adminManualEntriesDtoOutputEntriesInnerKindEnumSerializer;

  const AdminManualEntriesDtoOutputEntriesInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminManualEntriesDtoOutputEntriesInnerKindEnum> get values =>
      _$adminManualEntriesDtoOutputEntriesInnerKindEnumValues;
  static AdminManualEntriesDtoOutputEntriesInnerKindEnum valueOf(String name) =>
      _$adminManualEntriesDtoOutputEntriesInnerKindEnumValueOf(name);
}

class AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum captain =
      _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_captain;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum restaurant =
      _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum customer =
      _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_customer;

  static Serializer<AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum>
  get serializer =>
      _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnumSerializer;

  const AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum>
  get values => _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnumValues;
  static AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum valueOf(
    String name,
  ) => _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnumValueOf(name);
}
