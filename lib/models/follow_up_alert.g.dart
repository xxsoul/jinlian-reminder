// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_up_alert.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFollowUpAlertCollection on Isar {
  IsarCollection<FollowUpAlert> get followUpAlerts => this.collection();
}

const FollowUpAlertSchema = CollectionSchema(
  name: r'FollowUpAlert',
  id: -4270786956915182795,
  properties: {
    r'alertDate': PropertySchema(
      id: 0,
      name: r'alertDate',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'followUpDate': PropertySchema(
      id: 2,
      name: r'followUpDate',
      type: IsarType.dateTime,
    ),
    r'hasAlerted': PropertySchema(
      id: 3,
      name: r'hasAlerted',
      type: IsarType.bool,
    ),
    r'isConfirmed': PropertySchema(
      id: 4,
      name: r'isConfirmed',
      type: IsarType.bool,
    ),
    r'medicationId': PropertySchema(
      id: 5,
      name: r'medicationId',
      type: IsarType.long,
    ),
    r'message': PropertySchema(
      id: 6,
      name: r'message',
      type: IsarType.string,
    )
  },
  estimateSize: _followUpAlertEstimateSize,
  serialize: _followUpAlertSerialize,
  deserialize: _followUpAlertDeserialize,
  deserializeProp: _followUpAlertDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _followUpAlertGetId,
  getLinks: _followUpAlertGetLinks,
  attach: _followUpAlertAttach,
  version: '3.1.0+1',
);

int _followUpAlertEstimateSize(
  FollowUpAlert object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.message.length * 3;
  return bytesCount;
}

void _followUpAlertSerialize(
  FollowUpAlert object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.alertDate);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.followUpDate);
  writer.writeBool(offsets[3], object.hasAlerted);
  writer.writeBool(offsets[4], object.isConfirmed);
  writer.writeLong(offsets[5], object.medicationId);
  writer.writeString(offsets[6], object.message);
}

FollowUpAlert _followUpAlertDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FollowUpAlert(
    alertDate: reader.readDateTime(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    followUpDate: reader.readDateTime(offsets[2]),
    hasAlerted: reader.readBoolOrNull(offsets[3]) ?? false,
    isConfirmed: reader.readBoolOrNull(offsets[4]) ?? false,
    medicationId: reader.readLong(offsets[5]),
    message: reader.readString(offsets[6]),
  );
  object.id = id;
  return object;
}

P _followUpAlertDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _followUpAlertGetId(FollowUpAlert object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _followUpAlertGetLinks(FollowUpAlert object) {
  return [];
}

void _followUpAlertAttach(
    IsarCollection<dynamic> col, Id id, FollowUpAlert object) {
  object.id = id;
}

extension FollowUpAlertQueryWhereSort
    on QueryBuilder<FollowUpAlert, FollowUpAlert, QWhere> {
  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FollowUpAlertQueryWhere
    on QueryBuilder<FollowUpAlert, FollowUpAlert, QWhereClause> {
  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FollowUpAlertQueryFilter
    on QueryBuilder<FollowUpAlert, FollowUpAlert, QFilterCondition> {
  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      alertDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alertDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      alertDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alertDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      alertDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alertDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      alertDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alertDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      followUpDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followUpDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      followUpDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'followUpDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      followUpDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'followUpDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      followUpDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'followUpDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      hasAlertedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasAlerted',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      isConfirmedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isConfirmed',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      medicationIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicationId',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      medicationIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medicationId',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      medicationIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medicationId',
        value: value,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      medicationIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medicationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      messageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      messageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      messageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      messageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'message',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      messageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      messageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      messageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      messageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'message',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      messageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterFilterCondition>
      messageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'message',
        value: '',
      ));
    });
  }
}

extension FollowUpAlertQueryObject
    on QueryBuilder<FollowUpAlert, FollowUpAlert, QFilterCondition> {}

extension FollowUpAlertQueryLinks
    on QueryBuilder<FollowUpAlert, FollowUpAlert, QFilterCondition> {}

extension FollowUpAlertQuerySortBy
    on QueryBuilder<FollowUpAlert, FollowUpAlert, QSortBy> {
  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> sortByAlertDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertDate', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      sortByAlertDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertDate', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      sortByFollowUpDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      sortByFollowUpDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> sortByHasAlerted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAlerted', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      sortByHasAlertedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAlerted', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> sortByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      sortByIsConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      sortByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      sortByMedicationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> sortByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> sortByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.desc);
    });
  }
}

extension FollowUpAlertQuerySortThenBy
    on QueryBuilder<FollowUpAlert, FollowUpAlert, QSortThenBy> {
  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> thenByAlertDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertDate', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      thenByAlertDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertDate', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      thenByFollowUpDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      thenByFollowUpDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpDate', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> thenByHasAlerted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAlerted', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      thenByHasAlertedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAlerted', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> thenByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      thenByIsConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      thenByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy>
      thenByMedicationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.desc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> thenByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.asc);
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QAfterSortBy> thenByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.desc);
    });
  }
}

extension FollowUpAlertQueryWhereDistinct
    on QueryBuilder<FollowUpAlert, FollowUpAlert, QDistinct> {
  QueryBuilder<FollowUpAlert, FollowUpAlert, QDistinct> distinctByAlertDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alertDate');
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QDistinct>
      distinctByFollowUpDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followUpDate');
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QDistinct> distinctByHasAlerted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasAlerted');
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QDistinct>
      distinctByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isConfirmed');
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QDistinct>
      distinctByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicationId');
    });
  }

  QueryBuilder<FollowUpAlert, FollowUpAlert, QDistinct> distinctByMessage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'message', caseSensitive: caseSensitive);
    });
  }
}

extension FollowUpAlertQueryProperty
    on QueryBuilder<FollowUpAlert, FollowUpAlert, QQueryProperty> {
  QueryBuilder<FollowUpAlert, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FollowUpAlert, DateTime, QQueryOperations> alertDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alertDate');
    });
  }

  QueryBuilder<FollowUpAlert, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FollowUpAlert, DateTime, QQueryOperations>
      followUpDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followUpDate');
    });
  }

  QueryBuilder<FollowUpAlert, bool, QQueryOperations> hasAlertedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasAlerted');
    });
  }

  QueryBuilder<FollowUpAlert, bool, QQueryOperations> isConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isConfirmed');
    });
  }

  QueryBuilder<FollowUpAlert, int, QQueryOperations> medicationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicationId');
    });
  }

  QueryBuilder<FollowUpAlert, String, QQueryOperations> messageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'message');
    });
  }
}
