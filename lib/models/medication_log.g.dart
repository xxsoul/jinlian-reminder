// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMedicationLogCollection on Isar {
  IsarCollection<MedicationLog> get medicationLogs => this.collection();
}

const MedicationLogSchema = CollectionSchema(
  name: r'MedicationLog',
  id: 1536858489241207630,
  properties: {
    r'actualTime': PropertySchema(
      id: 0,
      name: r'actualTime',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'medicationId': PropertySchema(
      id: 2,
      name: r'medicationId',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 3,
      name: r'notes',
      type: IsarType.string,
    ),
    r'reminderId': PropertySchema(
      id: 4,
      name: r'reminderId',
      type: IsarType.long,
    ),
    r'scheduledTime': PropertySchema(
      id: 5,
      name: r'scheduledTime',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 6,
      name: r'status',
      type: IsarType.byte,
      enumMap: _MedicationLogstatusEnumValueMap,
    )
  },
  estimateSize: _medicationLogEstimateSize,
  serialize: _medicationLogSerialize,
  deserialize: _medicationLogDeserialize,
  deserializeProp: _medicationLogDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _medicationLogGetId,
  getLinks: _medicationLogGetLinks,
  attach: _medicationLogAttach,
  version: '3.1.0+1',
);

int _medicationLogEstimateSize(
  MedicationLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _medicationLogSerialize(
  MedicationLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.actualTime);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.medicationId);
  writer.writeString(offsets[3], object.notes);
  writer.writeLong(offsets[4], object.reminderId);
  writer.writeDateTime(offsets[5], object.scheduledTime);
  writer.writeByte(offsets[6], object.status.index);
}

MedicationLog _medicationLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MedicationLog(
    actualTime: reader.readDateTimeOrNull(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    medicationId: reader.readLong(offsets[2]),
    notes: reader.readStringOrNull(offsets[3]),
    reminderId: reader.readLongOrNull(offsets[4]),
    scheduledTime: reader.readDateTime(offsets[5]),
    status:
        _MedicationLogstatusValueEnumMap[reader.readByteOrNull(offsets[6])] ??
            MedicationLogStatus.taken,
  );
  object.id = id;
  return object;
}

P _medicationLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (_MedicationLogstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          MedicationLogStatus.taken) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MedicationLogstatusEnumValueMap = {
  'taken': 0,
  'skipped': 1,
  'missed': 2,
};
const _MedicationLogstatusValueEnumMap = {
  0: MedicationLogStatus.taken,
  1: MedicationLogStatus.skipped,
  2: MedicationLogStatus.missed,
};

Id _medicationLogGetId(MedicationLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _medicationLogGetLinks(MedicationLog object) {
  return [];
}

void _medicationLogAttach(
    IsarCollection<dynamic> col, Id id, MedicationLog object) {
  object.id = id;
}

extension MedicationLogQueryWhereSort
    on QueryBuilder<MedicationLog, MedicationLog, QWhere> {
  QueryBuilder<MedicationLog, MedicationLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MedicationLogQueryWhere
    on QueryBuilder<MedicationLog, MedicationLog, QWhereClause> {
  QueryBuilder<MedicationLog, MedicationLog, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<MedicationLog, MedicationLog, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterWhereClause> idBetween(
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

extension MedicationLogQueryFilter
    on QueryBuilder<MedicationLog, MedicationLog, QFilterCondition> {
  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      actualTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actualTime',
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      actualTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actualTime',
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      actualTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      actualTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      actualTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      actualTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
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

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
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

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
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

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
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

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      medicationIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicationId',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
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

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
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

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
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

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      reminderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reminderId',
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      reminderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reminderId',
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      reminderIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderId',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      reminderIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderId',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      reminderIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderId',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      reminderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      scheduledTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      scheduledTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      scheduledTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      scheduledTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      statusEqualTo(MedicationLogStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      statusGreaterThan(
    MedicationLogStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      statusLessThan(
    MedicationLogStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterFilterCondition>
      statusBetween(
    MedicationLogStatus lower,
    MedicationLogStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MedicationLogQueryObject
    on QueryBuilder<MedicationLog, MedicationLog, QFilterCondition> {}

extension MedicationLogQueryLinks
    on QueryBuilder<MedicationLog, MedicationLog, QFilterCondition> {}

extension MedicationLogQuerySortBy
    on QueryBuilder<MedicationLog, MedicationLog, QSortBy> {
  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> sortByActualTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      sortByActualTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      sortByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      sortByMedicationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> sortByReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      sortByReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      sortByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      sortByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension MedicationLogQuerySortThenBy
    on QueryBuilder<MedicationLog, MedicationLog, QSortThenBy> {
  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> thenByActualTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      thenByActualTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      thenByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      thenByMedicationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> thenByReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      thenByReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      thenByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy>
      thenByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension MedicationLogQueryWhereDistinct
    on QueryBuilder<MedicationLog, MedicationLog, QDistinct> {
  QueryBuilder<MedicationLog, MedicationLog, QDistinct> distinctByActualTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualTime');
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QDistinct>
      distinctByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicationId');
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QDistinct> distinctByReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderId');
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QDistinct>
      distinctByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledTime');
    });
  }

  QueryBuilder<MedicationLog, MedicationLog, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension MedicationLogQueryProperty
    on QueryBuilder<MedicationLog, MedicationLog, QQueryProperty> {
  QueryBuilder<MedicationLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MedicationLog, DateTime?, QQueryOperations>
      actualTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualTime');
    });
  }

  QueryBuilder<MedicationLog, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MedicationLog, int, QQueryOperations> medicationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicationId');
    });
  }

  QueryBuilder<MedicationLog, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<MedicationLog, int?, QQueryOperations> reminderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderId');
    });
  }

  QueryBuilder<MedicationLog, DateTime, QQueryOperations>
      scheduledTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledTime');
    });
  }

  QueryBuilder<MedicationLog, MedicationLogStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
