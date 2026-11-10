//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_reassignments_inner.g.dart';

/// AdminOrderDtoOutputOrderReassignmentsInner
///
/// Properties:
/// * [at]
/// * [captainId] - The captain the order was taken from.
/// * [reason] - The reassignment list's code.
/// * [label] - The label as chosen.
/// * [captainFault] - «بخطأ من الكابتن».
/// * [cash]
/// * [note] - Operations' internal note.
/// * [adminId]
/// * [captainSeenAt] - The captain's «حسناً».
@BuiltValue()
abstract class AdminOrderDtoOutputOrderReassignmentsInner
    implements
        Built<
          AdminOrderDtoOutputOrderReassignmentsInner,
          AdminOrderDtoOutputOrderReassignmentsInnerBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The captain the order was taken from.
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  /// The reassignment list's code.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// The label as chosen.
  @BuiltValueField(wireName: r'label')
  String get label;

  /// «بخطأ من الكابتن».
  @BuiltValueField(wireName: r'captainFault')
  bool get captainFault;

  @BuiltValueField(wireName: r'cash')
  AdminOrderDtoOutputOrderReassignmentsInnerCashEnum? get cash;
  // enum cashEnum {  returned,  not_returned,  not_paid,  };

  /// Operations' internal note.
  @BuiltValueField(wireName: r'note')
  String get note;

  @BuiltValueField(wireName: r'adminId')
  String get adminId;

  /// The captain's «حسناً».
  @BuiltValueField(wireName: r'captainSeenAt')
  DateTime? get captainSeenAt;

  AdminOrderDtoOutputOrderReassignmentsInner._();

  factory AdminOrderDtoOutputOrderReassignmentsInner([
    void updates(AdminOrderDtoOutputOrderReassignmentsInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderReassignmentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderReassignmentsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderReassignmentsInner>
  get serializer => _$AdminOrderDtoOutputOrderReassignmentsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderReassignmentsInnerSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderReassignmentsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderReassignmentsInner,
    _$AdminOrderDtoOutputOrderReassignmentsInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderReassignmentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderReassignmentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'captainFault';
    yield serializers.serialize(
      object.captainFault,
      specifiedType: const FullType(bool),
    );
    yield r'cash';
    yield object.cash == null
        ? null
        : serializers.serialize(
            object.cash,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderReassignmentsInnerCashEnum,
            ),
          );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
    yield r'adminId';
    yield serializers.serialize(
      object.adminId,
      specifiedType: const FullType(String),
    );
    yield r'captainSeenAt';
    yield object.captainSeenAt == null
        ? null
        : serializers.serialize(
            object.captainSeenAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderReassignmentsInner object, {
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
    required AdminOrderDtoOutputOrderReassignmentsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
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
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'captainFault':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.captainFault = valueDes;
          break;
        case r'cash':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderReassignmentsInnerCashEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderReassignmentsInnerCashEnum?;
          if (valueDes == null) continue;
          result.cash = valueDes;
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
        case r'adminId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.adminId = valueDes;
          break;
        case r'captainSeenAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.captainSeenAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderReassignmentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderReassignmentsInnerBuilder();
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

class AdminOrderDtoOutputOrderReassignmentsInnerCashEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'returned')
  static const AdminOrderDtoOutputOrderReassignmentsInnerCashEnum returned =
      _$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_returned;
  @BuiltValueEnumConst(wireName: r'not_returned')
  static const AdminOrderDtoOutputOrderReassignmentsInnerCashEnum notReturned =
      _$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_notReturned;
  @BuiltValueEnumConst(wireName: r'not_paid')
  static const AdminOrderDtoOutputOrderReassignmentsInnerCashEnum notPaid =
      _$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_notPaid;

  static Serializer<AdminOrderDtoOutputOrderReassignmentsInnerCashEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderReassignmentsInnerCashEnumSerializer;

  const AdminOrderDtoOutputOrderReassignmentsInnerCashEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderReassignmentsInnerCashEnum>
  get values => _$adminOrderDtoOutputOrderReassignmentsInnerCashEnumValues;
  static AdminOrderDtoOutputOrderReassignmentsInnerCashEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderReassignmentsInnerCashEnumValueOf(name);
}
