//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output_tasks_inner.g.dart';

/// AdminDashboardDtoOutputTasksInner
///
/// Properties:
/// * [key]
/// * [count]
@BuiltValue()
abstract class AdminDashboardDtoOutputTasksInner
    implements
        Built<
          AdminDashboardDtoOutputTasksInner,
          AdminDashboardDtoOutputTasksInnerBuilder
        > {
  @BuiltValueField(wireName: r'key')
  AdminDashboardDtoOutputTasksInnerKeyEnum get key;
  // enum keyEnum {  compensationApprovals,  menuChanges,  applications,  probationReviews,  expiringDocuments,  acceptanceReviews,  shortfalls,  cashBlocked,  settlementsDue,  overdueRestaurants,  payoutsDue,  };

  @BuiltValueField(wireName: r'count')
  int get count;

  AdminDashboardDtoOutputTasksInner._();

  factory AdminDashboardDtoOutputTasksInner([
    void updates(AdminDashboardDtoOutputTasksInnerBuilder b),
  ]) = _$AdminDashboardDtoOutputTasksInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardDtoOutputTasksInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutputTasksInner> get serializer =>
      _$AdminDashboardDtoOutputTasksInnerSerializer();
}

class _$AdminDashboardDtoOutputTasksInnerSerializer
    implements PrimitiveSerializer<AdminDashboardDtoOutputTasksInner> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutputTasksInner,
    _$AdminDashboardDtoOutputTasksInner,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutputTasksInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutputTasksInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(AdminDashboardDtoOutputTasksInnerKeyEnum),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutputTasksInner object, {
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
    required AdminDashboardDtoOutputTasksInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDashboardDtoOutputTasksInnerKeyEnum,
                    ),
                  )
                  as AdminDashboardDtoOutputTasksInnerKeyEnum;
          result.key = valueDes;
          break;
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutputTasksInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputTasksInnerBuilder();
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

class AdminDashboardDtoOutputTasksInnerKeyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'compensationApprovals')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum compensationApprovals =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_compensationApprovals;
  @BuiltValueEnumConst(wireName: r'menuChanges')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum menuChanges =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_menuChanges;
  @BuiltValueEnumConst(wireName: r'applications')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum applications =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_applications;
  @BuiltValueEnumConst(wireName: r'probationReviews')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum probationReviews =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_probationReviews;
  @BuiltValueEnumConst(wireName: r'expiringDocuments')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum expiringDocuments =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_expiringDocuments;
  @BuiltValueEnumConst(wireName: r'acceptanceReviews')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum acceptanceReviews =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_acceptanceReviews;
  @BuiltValueEnumConst(wireName: r'shortfalls')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum shortfalls =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_shortfalls;
  @BuiltValueEnumConst(wireName: r'cashBlocked')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum cashBlocked =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_cashBlocked;
  @BuiltValueEnumConst(wireName: r'settlementsDue')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum settlementsDue =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_settlementsDue;
  @BuiltValueEnumConst(wireName: r'overdueRestaurants')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum overdueRestaurants =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_overdueRestaurants;
  @BuiltValueEnumConst(wireName: r'payoutsDue')
  static const AdminDashboardDtoOutputTasksInnerKeyEnum payoutsDue =
      _$adminDashboardDtoOutputTasksInnerKeyEnum_payoutsDue;

  static Serializer<AdminDashboardDtoOutputTasksInnerKeyEnum> get serializer =>
      _$adminDashboardDtoOutputTasksInnerKeyEnumSerializer;

  const AdminDashboardDtoOutputTasksInnerKeyEnum._(String name) : super(name);

  static BuiltSet<AdminDashboardDtoOutputTasksInnerKeyEnum> get values =>
      _$adminDashboardDtoOutputTasksInnerKeyEnumValues;
  static AdminDashboardDtoOutputTasksInnerKeyEnum valueOf(String name) =>
      _$adminDashboardDtoOutputTasksInnerKeyEnumValueOf(name);
}
