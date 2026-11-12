//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_desk_custody_dto_output_closed_due.g.dart';

/// Due from closed days, netted in the base currency (AP §8.5.4).
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminDeskCustodyDtoOutputClosedDue
    implements
        Built<
          AdminDeskCustodyDtoOutputClosedDue,
          AdminDeskCustodyDtoOutputClosedDueBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminDeskCustodyDtoOutputClosedDue._();

  factory AdminDeskCustodyDtoOutputClosedDue([
    void updates(AdminDeskCustodyDtoOutputClosedDueBuilder b),
  ]) = _$AdminDeskCustodyDtoOutputClosedDue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeskCustodyDtoOutputClosedDueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeskCustodyDtoOutputClosedDue> get serializer =>
      _$AdminDeskCustodyDtoOutputClosedDueSerializer();
}

class _$AdminDeskCustodyDtoOutputClosedDueSerializer
    implements PrimitiveSerializer<AdminDeskCustodyDtoOutputClosedDue> {
  @override
  final Iterable<Type> types = const [
    AdminDeskCustodyDtoOutputClosedDue,
    _$AdminDeskCustodyDtoOutputClosedDue,
  ];

  @override
  final String wireName = r'AdminDeskCustodyDtoOutputClosedDue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeskCustodyDtoOutputClosedDue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeskCustodyDtoOutputClosedDue object, {
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
    required AdminDeskCustodyDtoOutputClosedDueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeskCustodyDtoOutputClosedDue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeskCustodyDtoOutputClosedDueBuilder();
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
