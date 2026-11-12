//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_current_drawer_session_dto_output_session_currencies_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_current_drawer_session_dto_output_session.g.dart';

/// AdminCurrentDrawerSessionDtoOutputSession
///
/// Properties:
/// * [id]
/// * [cityId]
/// * [adminAccountId]
/// * [adminName]
/// * [kind]
/// * [openedAt]
/// * [closedAt]
/// * [closeNote]
/// * [currencies]
@BuiltValue()
abstract class AdminCurrentDrawerSessionDtoOutputSession
    implements
        Built<
          AdminCurrentDrawerSessionDtoOutputSession,
          AdminCurrentDrawerSessionDtoOutputSessionBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'adminAccountId')
  String get adminAccountId;

  @BuiltValueField(wireName: r'adminName')
  String? get adminName;

  @BuiltValueField(wireName: r'kind')
  AdminCurrentDrawerSessionDtoOutputSessionKindEnum get kind;
  // enum kindEnum {  office,  };

  @BuiltValueField(wireName: r'openedAt')
  DateTime get openedAt;

  @BuiltValueField(wireName: r'closedAt')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'closeNote')
  String? get closeNote;

  @BuiltValueField(wireName: r'currencies')
  BuiltList<AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner>
  get currencies;

  AdminCurrentDrawerSessionDtoOutputSession._();

  factory AdminCurrentDrawerSessionDtoOutputSession([
    void updates(AdminCurrentDrawerSessionDtoOutputSessionBuilder b),
  ]) = _$AdminCurrentDrawerSessionDtoOutputSession;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCurrentDrawerSessionDtoOutputSessionBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCurrentDrawerSessionDtoOutputSession> get serializer =>
      _$AdminCurrentDrawerSessionDtoOutputSessionSerializer();
}

class _$AdminCurrentDrawerSessionDtoOutputSessionSerializer
    implements PrimitiveSerializer<AdminCurrentDrawerSessionDtoOutputSession> {
  @override
  final Iterable<Type> types = const [
    AdminCurrentDrawerSessionDtoOutputSession,
    _$AdminCurrentDrawerSessionDtoOutputSession,
  ];

  @override
  final String wireName = r'AdminCurrentDrawerSessionDtoOutputSession';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCurrentDrawerSessionDtoOutputSession object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'adminAccountId';
    yield serializers.serialize(
      object.adminAccountId,
      specifiedType: const FullType(String),
    );
    yield r'adminName';
    yield object.adminName == null
        ? null
        : serializers.serialize(
            object.adminName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminCurrentDrawerSessionDtoOutputSessionKindEnum,
      ),
    );
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'closedAt';
    yield object.closedAt == null
        ? null
        : serializers.serialize(
            object.closedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'closeNote';
    yield object.closeNote == null
        ? null
        : serializers.serialize(
            object.closeNote,
            specifiedType: const FullType.nullable(String),
          );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCurrentDrawerSessionDtoOutputSession object, {
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
    required AdminCurrentDrawerSessionDtoOutputSessionBuilder result,
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
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'adminAccountId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.adminAccountId = valueDes;
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
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCurrentDrawerSessionDtoOutputSessionKindEnum,
                    ),
                  )
                  as AdminCurrentDrawerSessionDtoOutputSessionKindEnum;
          result.kind = valueDes;
          break;
        case r'openedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.openedAt = valueDes;
          break;
        case r'closedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'closeNote':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.closeNote = valueDes;
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner
                  >;
          result.currencies.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCurrentDrawerSessionDtoOutputSession deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCurrentDrawerSessionDtoOutputSessionBuilder();
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

class AdminCurrentDrawerSessionDtoOutputSessionKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'office')
  static const AdminCurrentDrawerSessionDtoOutputSessionKindEnum office =
      _$adminCurrentDrawerSessionDtoOutputSessionKindEnum_office;

  static Serializer<AdminCurrentDrawerSessionDtoOutputSessionKindEnum>
  get serializer =>
      _$adminCurrentDrawerSessionDtoOutputSessionKindEnumSerializer;

  const AdminCurrentDrawerSessionDtoOutputSessionKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminCurrentDrawerSessionDtoOutputSessionKindEnum>
  get values => _$adminCurrentDrawerSessionDtoOutputSessionKindEnumValues;
  static AdminCurrentDrawerSessionDtoOutputSessionKindEnum valueOf(
    String name,
  ) => _$adminCurrentDrawerSessionDtoOutputSessionKindEnumValueOf(name);
}
