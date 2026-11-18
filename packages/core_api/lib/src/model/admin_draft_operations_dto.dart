//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_draft_operations_dto_periods_inner.dart';
import 'package:core_api/src/model/admin_draft_operations_dto_coverage.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_draft_operations_dto_minimum_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_operations_dto.g.dart';

/// AdminDraftOperationsDto
///
/// Properties:
/// * [periods]
/// * [defaultPrepMin]
/// * [minimumOrder]
/// * [coverage]
@BuiltValue()
abstract class AdminDraftOperationsDto
    implements Built<AdminDraftOperationsDto, AdminDraftOperationsDtoBuilder> {
  @BuiltValueField(wireName: r'periods')
  BuiltList<AdminDraftOperationsDtoPeriodsInner> get periods;

  @BuiltValueField(wireName: r'defaultPrepMin')
  int get defaultPrepMin;

  @BuiltValueField(wireName: r'minimumOrder')
  AdminDraftOperationsDtoMinimumOrder get minimumOrder;

  @BuiltValueField(wireName: r'coverage')
  AdminDraftOperationsDtoCoverage get coverage;

  AdminDraftOperationsDto._();

  factory AdminDraftOperationsDto([
    void updates(AdminDraftOperationsDtoBuilder b),
  ]) = _$AdminDraftOperationsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftOperationsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftOperationsDto> get serializer =>
      _$AdminDraftOperationsDtoSerializer();
}

class _$AdminDraftOperationsDtoSerializer
    implements PrimitiveSerializer<AdminDraftOperationsDto> {
  @override
  final Iterable<Type> types = const [
    AdminDraftOperationsDto,
    _$AdminDraftOperationsDto,
  ];

  @override
  final String wireName = r'AdminDraftOperationsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftOperationsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'periods';
    yield serializers.serialize(
      object.periods,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDraftOperationsDtoPeriodsInner),
      ]),
    );
    yield r'defaultPrepMin';
    yield serializers.serialize(
      object.defaultPrepMin,
      specifiedType: const FullType(int),
    );
    yield r'minimumOrder';
    yield serializers.serialize(
      object.minimumOrder,
      specifiedType: const FullType(AdminDraftOperationsDtoMinimumOrder),
    );
    yield r'coverage';
    yield serializers.serialize(
      object.coverage,
      specifiedType: const FullType(AdminDraftOperationsDtoCoverage),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftOperationsDto object, {
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
    required AdminDraftOperationsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'periods':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDraftOperationsDtoPeriodsInner),
                    ]),
                  )
                  as BuiltList<AdminDraftOperationsDtoPeriodsInner>;
          result.periods.replace(valueDes);
          break;
        case r'defaultPrepMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.defaultPrepMin = valueDes;
          break;
        case r'minimumOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDraftOperationsDtoMinimumOrder,
                    ),
                  )
                  as AdminDraftOperationsDtoMinimumOrder;
          result.minimumOrder.replace(valueDes);
          break;
        case r'coverage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDraftOperationsDtoCoverage,
                    ),
                  )
                  as AdminDraftOperationsDtoCoverage;
          result.coverage.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftOperationsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftOperationsDtoBuilder();
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
