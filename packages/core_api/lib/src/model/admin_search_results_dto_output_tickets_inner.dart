//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_search_results_dto_output_tickets_inner.g.dart';

/// AdminSearchResultsDtoOutputTicketsInner
///
/// Properties:
/// * [id]
/// * [number]
/// * [status]
@BuiltValue()
abstract class AdminSearchResultsDtoOutputTicketsInner
    implements
        Built<
          AdminSearchResultsDtoOutputTicketsInner,
          AdminSearchResultsDtoOutputTicketsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'status')
  AdminSearchResultsDtoOutputTicketsInnerStatusEnum get status;
  // enum statusEnum {  new,  in_progress,  waiting,  resolved,  closed,  };

  AdminSearchResultsDtoOutputTicketsInner._();

  factory AdminSearchResultsDtoOutputTicketsInner([
    void updates(AdminSearchResultsDtoOutputTicketsInnerBuilder b),
  ]) = _$AdminSearchResultsDtoOutputTicketsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSearchResultsDtoOutputTicketsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSearchResultsDtoOutputTicketsInner> get serializer =>
      _$AdminSearchResultsDtoOutputTicketsInnerSerializer();
}

class _$AdminSearchResultsDtoOutputTicketsInnerSerializer
    implements PrimitiveSerializer<AdminSearchResultsDtoOutputTicketsInner> {
  @override
  final Iterable<Type> types = const [
    AdminSearchResultsDtoOutputTicketsInner,
    _$AdminSearchResultsDtoOutputTicketsInner,
  ];

  @override
  final String wireName = r'AdminSearchResultsDtoOutputTicketsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSearchResultsDtoOutputTicketsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminSearchResultsDtoOutputTicketsInnerStatusEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSearchResultsDtoOutputTicketsInner object, {
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
    required AdminSearchResultsDtoOutputTicketsInnerBuilder result,
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
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSearchResultsDtoOutputTicketsInnerStatusEnum,
                    ),
                  )
                  as AdminSearchResultsDtoOutputTicketsInnerStatusEnum;
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
  AdminSearchResultsDtoOutputTicketsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSearchResultsDtoOutputTicketsInnerBuilder();
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

class AdminSearchResultsDtoOutputTicketsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminSearchResultsDtoOutputTicketsInnerStatusEnum new_ =
      _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_new_;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const AdminSearchResultsDtoOutputTicketsInnerStatusEnum inProgress =
      _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const AdminSearchResultsDtoOutputTicketsInnerStatusEnum waiting =
      _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_waiting;
  @BuiltValueEnumConst(wireName: r'resolved')
  static const AdminSearchResultsDtoOutputTicketsInnerStatusEnum resolved =
      _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_resolved;
  @BuiltValueEnumConst(wireName: r'closed')
  static const AdminSearchResultsDtoOutputTicketsInnerStatusEnum closed =
      _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_closed;

  static Serializer<AdminSearchResultsDtoOutputTicketsInnerStatusEnum>
  get serializer =>
      _$adminSearchResultsDtoOutputTicketsInnerStatusEnumSerializer;

  const AdminSearchResultsDtoOutputTicketsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminSearchResultsDtoOutputTicketsInnerStatusEnum>
  get values => _$adminSearchResultsDtoOutputTicketsInnerStatusEnumValues;
  static AdminSearchResultsDtoOutputTicketsInnerStatusEnum valueOf(
    String name,
  ) => _$adminSearchResultsDtoOutputTicketsInnerStatusEnumValueOf(name);
}
