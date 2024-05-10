// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_progress_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBookProgressModelCollection on Isar {
  IsarCollection<BookProgressModel> get bookProgressModels => this.collection();
}

const BookProgressModelSchema = CollectionSchema(
  name: r'BookProgressModel',
  id: 2050998199370397082,
  properties: {
    r'bookId': PropertySchema(
      id: 0,
      name: r'bookId',
      type: IsarType.string,
    ),
    r'currentChapterIndex': PropertySchema(
      id: 1,
      name: r'currentChapterIndex',
      type: IsarType.long,
    ),
    r'currentPageIndex': PropertySchema(
      id: 2,
      name: r'currentPageIndex',
      type: IsarType.long,
    )
  },
  estimateSize: _bookProgressModelEstimateSize,
  serialize: _bookProgressModelSerialize,
  deserialize: _bookProgressModelDeserialize,
  deserializeProp: _bookProgressModelDeserializeProp,
  idName: r'localId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _bookProgressModelGetId,
  getLinks: _bookProgressModelGetLinks,
  attach: _bookProgressModelAttach,
  version: '3.1.0+1',
);

int _bookProgressModelEstimateSize(
  BookProgressModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bookId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _bookProgressModelSerialize(
  BookProgressModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bookId);
  writer.writeLong(offsets[1], object.currentChapterIndex);
  writer.writeLong(offsets[2], object.currentPageIndex);
}

BookProgressModel _bookProgressModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BookProgressModel(
    bookId: reader.readStringOrNull(offsets[0]),
    currentChapterIndex: reader.readLongOrNull(offsets[1]),
    currentPageIndex: reader.readLongOrNull(offsets[2]),
  );
  object.localId = id;
  return object;
}

P _bookProgressModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bookProgressModelGetId(BookProgressModel object) {
  return object.localId;
}

List<IsarLinkBase<dynamic>> _bookProgressModelGetLinks(
    BookProgressModel object) {
  return [];
}

void _bookProgressModelAttach(
    IsarCollection<dynamic> col, Id id, BookProgressModel object) {
  object.localId = id;
}

extension BookProgressModelQueryWhereSort
    on QueryBuilder<BookProgressModel, BookProgressModel, QWhere> {
  QueryBuilder<BookProgressModel, BookProgressModel, QAfterWhere> anyLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BookProgressModelQueryWhere
    on QueryBuilder<BookProgressModel, BookProgressModel, QWhereClause> {
  QueryBuilder<BookProgressModel, BookProgressModel, QAfterWhereClause>
      localIdEqualTo(Id localId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: localId,
        upper: localId,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterWhereClause>
      localIdNotEqualTo(Id localId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: localId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: localId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: localId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: localId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterWhereClause>
      localIdGreaterThan(Id localId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: localId, includeLower: include),
      );
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterWhereClause>
      localIdLessThan(Id localId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: localId, includeUpper: include),
      );
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterWhereClause>
      localIdBetween(
    Id lowerLocalId,
    Id upperLocalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerLocalId,
        includeLower: includeLower,
        upper: upperLocalId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BookProgressModelQueryFilter
    on QueryBuilder<BookProgressModel, BookProgressModel, QFilterCondition> {
  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bookId',
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bookId',
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      bookIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentChapterIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentChapterIndex',
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentChapterIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentChapterIndex',
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentChapterIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentChapterIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentChapterIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentChapterIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentChapterIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentChapterIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentChapterIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentChapterIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentPageIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentPageIndex',
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentPageIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentPageIndex',
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentPageIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentPageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentPageIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentPageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentPageIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentPageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      currentPageIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentPageIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      localIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      localIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      localIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterFilterCondition>
      localIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BookProgressModelQueryObject
    on QueryBuilder<BookProgressModel, BookProgressModel, QFilterCondition> {}

extension BookProgressModelQueryLinks
    on QueryBuilder<BookProgressModel, BookProgressModel, QFilterCondition> {}

extension BookProgressModelQuerySortBy
    on QueryBuilder<BookProgressModel, BookProgressModel, QSortBy> {
  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      sortByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      sortByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      sortByCurrentChapterIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentChapterIndex', Sort.asc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      sortByCurrentChapterIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentChapterIndex', Sort.desc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      sortByCurrentPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPageIndex', Sort.asc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      sortByCurrentPageIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPageIndex', Sort.desc);
    });
  }
}

extension BookProgressModelQuerySortThenBy
    on QueryBuilder<BookProgressModel, BookProgressModel, QSortThenBy> {
  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      thenByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      thenByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      thenByCurrentChapterIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentChapterIndex', Sort.asc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      thenByCurrentChapterIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentChapterIndex', Sort.desc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      thenByCurrentPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPageIndex', Sort.asc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      thenByCurrentPageIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPageIndex', Sort.desc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QAfterSortBy>
      thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }
}

extension BookProgressModelQueryWhereDistinct
    on QueryBuilder<BookProgressModel, BookProgressModel, QDistinct> {
  QueryBuilder<BookProgressModel, BookProgressModel, QDistinct>
      distinctByBookId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QDistinct>
      distinctByCurrentChapterIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentChapterIndex');
    });
  }

  QueryBuilder<BookProgressModel, BookProgressModel, QDistinct>
      distinctByCurrentPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPageIndex');
    });
  }
}

extension BookProgressModelQueryProperty
    on QueryBuilder<BookProgressModel, BookProgressModel, QQueryProperty> {
  QueryBuilder<BookProgressModel, int, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<BookProgressModel, String?, QQueryOperations> bookIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookId');
    });
  }

  QueryBuilder<BookProgressModel, int?, QQueryOperations>
      currentChapterIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentChapterIndex');
    });
  }

  QueryBuilder<BookProgressModel, int?, QQueryOperations>
      currentPageIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPageIndex');
    });
  }
}
