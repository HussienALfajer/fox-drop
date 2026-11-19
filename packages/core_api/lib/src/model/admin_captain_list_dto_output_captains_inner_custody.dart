//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_list_dto_output_captains_inner_custody_usage.dart';
import 'package:core_api/src/model/admin_captain_list_dto_output_captains_inner_custody_limit.dart';
import 'package:core_api/src/model/admin_captain_list_dto_output_captains_inner_custody_closed_due.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_list_dto_output_captains_inner_custody.g.dart';

/// AdminCaptainListDtoOutputCaptainsInnerCustody
///
/// Properties:
/// * [usage]
/// * [limit]
/// * [closedDue]
@BuiltValue()
abstract class AdminCaptainListDtoOutputCaptainsInnerCustody
    implements
        Built<
          AdminCaptainListDtoOutputCaptainsInnerCustody,
          AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder
        > {
  @BuiltValueField(wireName: r'usage')
  AdminCaptainListDtoOutputCaptainsInnerCustodyUsage get usage;

  @BuiltValueField(wireName: r'limit')
  AdminCaptainListDtoOutputCaptainsInnerCustodyLimit get limit;

  @BuiltValueField(wireName: r'closedDue')
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? get closedDue;

  AdminCaptainListDtoOutputCaptainsInnerCustody._();

  factory AdminCaptainListDtoOutputCaptainsInnerCustody([
    void updates(AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder b),
  ]) = _$AdminCaptainListDtoOutputCaptainsInnerCustody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainListDtoOutputCaptainsInnerCustody>
  get serializer => _$AdminCaptainListDtoOutputCaptainsInnerCustodySerializer();
}

class _$AdminCaptainListDtoOutputCaptainsInnerCustodySerializer
    implements
        PrimitiveSerializer<AdminCaptainListDtoOutputCaptainsInnerCustody> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainListDtoOutputCaptainsInnerCustody,
    _$AdminCaptainListDtoOutputCaptainsInnerCustody,
  ];

  @override
  final String wireName = r'AdminCaptainListDtoOutputCaptainsInnerCustody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainListDtoOutputCaptainsInnerCustody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'usage';
    yield serializers.serialize(
      object.usage,
      specifiedType: const FullType(
        AdminCaptainListDtoOutputCaptainsInnerCustodyUsage,
      ),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(
        AdminCaptainListDtoOutputCaptainsInnerCustodyLimit,
      ),
    );
    yield r'closedDue';
    yield object.closedDue == null
        ? null
        : serializers.serialize(
            object.closedDue,
            specifiedType: const FullType.nullable(
              AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainListDtoOutputCaptainsInnerCustody object, {
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
    required AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'usage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainListDtoOutputCaptainsInnerCustodyUsage,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerCustodyUsage;
          result.usage.replace(valueDes);
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainListDtoOutputCaptainsInnerCustodyLimit,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerCustodyLimit;
          result.limit.replace(valueDes);
          break;
        case r'closedDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue?;
          if (valueDes == null) continue;
          result.closedDue.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainListDtoOutputCaptainsInnerCustody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder();
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
