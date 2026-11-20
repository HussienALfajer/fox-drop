//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_export_dto_output.g.dart';

/// AdminExportDtoOutput
///
/// Properties:
/// * [id]
/// * [kind]
/// * [status]
/// * [fileName]
/// * [createdAt]
/// * [expiresAt] - Until when it can be downloaded.
/// * [url] - Asked with download=true while ready: a signed download on the panel’s origin, valid 5 minutes.
@BuiltValue()
abstract class AdminExportDtoOutput
    implements Built<AdminExportDtoOutput, AdminExportDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  AdminExportDtoOutputKindEnum get kind;
  // enum kindEnum {  restaurant_statement,  daily_report,  cost_report,  order_history,  report,  };

  @BuiltValueField(wireName: r'status')
  AdminExportDtoOutputStatusEnum get status;
  // enum statusEnum {  pending,  ready,  expired,  };

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Until when it can be downloaded.
  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  /// Asked with download=true while ready: a signed download on the panel’s origin, valid 5 minutes.
  @BuiltValueField(wireName: r'url')
  String? get url;

  AdminExportDtoOutput._();

  factory AdminExportDtoOutput([void updates(AdminExportDtoOutputBuilder b)]) =
      _$AdminExportDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminExportDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminExportDtoOutput> get serializer =>
      _$AdminExportDtoOutputSerializer();
}

class _$AdminExportDtoOutputSerializer
    implements PrimitiveSerializer<AdminExportDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminExportDtoOutput,
    _$AdminExportDtoOutput,
  ];

  @override
  final String wireName = r'AdminExportDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminExportDtoOutput object, {
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
      specifiedType: const FullType(AdminExportDtoOutputKindEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminExportDtoOutputStatusEnum),
    );
    yield r'fileName';
    yield serializers.serialize(
      object.fileName,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield object.expiresAt == null
        ? null
        : serializers.serialize(
            object.expiresAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'url';
    yield object.url == null
        ? null
        : serializers.serialize(
            object.url,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminExportDtoOutput object, {
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
    required AdminExportDtoOutputBuilder result,
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
                    specifiedType: const FullType(AdminExportDtoOutputKindEnum),
                  )
                  as AdminExportDtoOutputKindEnum;
          result.kind = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminExportDtoOutputStatusEnum,
                    ),
                  )
                  as AdminExportDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'fileName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fileName = valueDes;
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
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'url':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminExportDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminExportDtoOutputBuilder();
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

class AdminExportDtoOutputKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant_statement')
  static const AdminExportDtoOutputKindEnum restaurantStatement =
      _$adminExportDtoOutputKindEnum_restaurantStatement;
  @BuiltValueEnumConst(wireName: r'daily_report')
  static const AdminExportDtoOutputKindEnum dailyReport =
      _$adminExportDtoOutputKindEnum_dailyReport;
  @BuiltValueEnumConst(wireName: r'cost_report')
  static const AdminExportDtoOutputKindEnum costReport =
      _$adminExportDtoOutputKindEnum_costReport;
  @BuiltValueEnumConst(wireName: r'order_history')
  static const AdminExportDtoOutputKindEnum orderHistory =
      _$adminExportDtoOutputKindEnum_orderHistory;
  @BuiltValueEnumConst(wireName: r'report')
  static const AdminExportDtoOutputKindEnum report =
      _$adminExportDtoOutputKindEnum_report;

  static Serializer<AdminExportDtoOutputKindEnum> get serializer =>
      _$adminExportDtoOutputKindEnumSerializer;

  const AdminExportDtoOutputKindEnum._(String name) : super(name);

  static BuiltSet<AdminExportDtoOutputKindEnum> get values =>
      _$adminExportDtoOutputKindEnumValues;
  static AdminExportDtoOutputKindEnum valueOf(String name) =>
      _$adminExportDtoOutputKindEnumValueOf(name);
}

class AdminExportDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const AdminExportDtoOutputStatusEnum pending =
      _$adminExportDtoOutputStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminExportDtoOutputStatusEnum ready =
      _$adminExportDtoOutputStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'expired')
  static const AdminExportDtoOutputStatusEnum expired =
      _$adminExportDtoOutputStatusEnum_expired;

  static Serializer<AdminExportDtoOutputStatusEnum> get serializer =>
      _$adminExportDtoOutputStatusEnumSerializer;

  const AdminExportDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<AdminExportDtoOutputStatusEnum> get values =>
      _$adminExportDtoOutputStatusEnumValues;
  static AdminExportDtoOutputStatusEnum valueOf(String name) =>
      _$adminExportDtoOutputStatusEnumValueOf(name);
}
