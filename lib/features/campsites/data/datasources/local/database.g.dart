// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CampsitesTable extends Campsites
    with TableInfo<$CampsitesTable, CampsiteDbModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CampsitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCloseToWaterMeta = const VerificationMeta(
    'isCloseToWater',
  );
  @override
  late final GeneratedColumn<bool> isCloseToWater = GeneratedColumn<bool>(
    'is_close_to_water',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_close_to_water" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isCampFireAllowedMeta = const VerificationMeta(
    'isCampFireAllowed',
  );
  @override
  late final GeneratedColumn<bool> isCampFireAllowed = GeneratedColumn<bool>(
    'is_camp_fire_allowed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_camp_fire_allowed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _hostLanguagesMeta = const VerificationMeta(
    'hostLanguages',
  );
  @override
  late final GeneratedColumn<String> hostLanguages = GeneratedColumn<String>(
    'host_languages',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerNightMeta = const VerificationMeta(
    'pricePerNight',
  );
  @override
  late final GeneratedColumn<double> pricePerNight = GeneratedColumn<double>(
    'price_per_night',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
    'photo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suitableForMeta = const VerificationMeta(
    'suitableFor',
  );
  @override
  late final GeneratedColumn<String> suitableFor = GeneratedColumn<String>(
    'suitable_for',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    latitude,
    longitude,
    createdAt,
    isCloseToWater,
    isCampFireAllowed,
    hostLanguages,
    pricePerNight,
    photo,
    suitableFor,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'campsites';
  @override
  VerificationContext validateIntegrity(
    Insertable<CampsiteDbModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_close_to_water')) {
      context.handle(
        _isCloseToWaterMeta,
        isCloseToWater.isAcceptableOrUnknown(
          data['is_close_to_water']!,
          _isCloseToWaterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isCloseToWaterMeta);
    }
    if (data.containsKey('is_camp_fire_allowed')) {
      context.handle(
        _isCampFireAllowedMeta,
        isCampFireAllowed.isAcceptableOrUnknown(
          data['is_camp_fire_allowed']!,
          _isCampFireAllowedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isCampFireAllowedMeta);
    }
    if (data.containsKey('host_languages')) {
      context.handle(
        _hostLanguagesMeta,
        hostLanguages.isAcceptableOrUnknown(
          data['host_languages']!,
          _hostLanguagesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hostLanguagesMeta);
    }
    if (data.containsKey('price_per_night')) {
      context.handle(
        _pricePerNightMeta,
        pricePerNight.isAcceptableOrUnknown(
          data['price_per_night']!,
          _pricePerNightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerNightMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    } else if (isInserting) {
      context.missing(_photoMeta);
    }
    if (data.containsKey('suitable_for')) {
      context.handle(
        _suitableForMeta,
        suitableFor.isAcceptableOrUnknown(
          data['suitable_for']!,
          _suitableForMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_suitableForMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CampsiteDbModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CampsiteDbModel(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      label:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}label'],
          )!,
      latitude:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}latitude'],
          )!,
      longitude:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}longitude'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}created_at'],
          )!,
      isCloseToWater:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_close_to_water'],
          )!,
      isCampFireAllowed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_camp_fire_allowed'],
          )!,
      hostLanguages:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}host_languages'],
          )!,
      pricePerNight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}price_per_night'],
          )!,
      photo:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}photo'],
          )!,
      suitableFor:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}suitable_for'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $CampsitesTable createAlias(String alias) {
    return $CampsitesTable(attachedDatabase, alias);
  }
}

class CampsiteDbModel extends DataClass implements Insertable<CampsiteDbModel> {
  final String id;
  final String label;
  final double latitude;
  final double longitude;
  final String createdAt;
  final bool isCloseToWater;
  final bool isCampFireAllowed;
  final String hostLanguages;
  final double pricePerNight;
  final String photo;
  final String suitableFor;
  final DateTime updatedAt;
  const CampsiteDbModel({
    required this.id,
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.isCloseToWater,
    required this.isCampFireAllowed,
    required this.hostLanguages,
    required this.pricePerNight,
    required this.photo,
    required this.suitableFor,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['created_at'] = Variable<String>(createdAt);
    map['is_close_to_water'] = Variable<bool>(isCloseToWater);
    map['is_camp_fire_allowed'] = Variable<bool>(isCampFireAllowed);
    map['host_languages'] = Variable<String>(hostLanguages);
    map['price_per_night'] = Variable<double>(pricePerNight);
    map['photo'] = Variable<String>(photo);
    map['suitable_for'] = Variable<String>(suitableFor);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CampsitesCompanion toCompanion(bool nullToAbsent) {
    return CampsitesCompanion(
      id: Value(id),
      label: Value(label),
      latitude: Value(latitude),
      longitude: Value(longitude),
      createdAt: Value(createdAt),
      isCloseToWater: Value(isCloseToWater),
      isCampFireAllowed: Value(isCampFireAllowed),
      hostLanguages: Value(hostLanguages),
      pricePerNight: Value(pricePerNight),
      photo: Value(photo),
      suitableFor: Value(suitableFor),
      updatedAt: Value(updatedAt),
    );
  }

  factory CampsiteDbModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CampsiteDbModel(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      isCloseToWater: serializer.fromJson<bool>(json['isCloseToWater']),
      isCampFireAllowed: serializer.fromJson<bool>(json['isCampFireAllowed']),
      hostLanguages: serializer.fromJson<String>(json['hostLanguages']),
      pricePerNight: serializer.fromJson<double>(json['pricePerNight']),
      photo: serializer.fromJson<String>(json['photo']),
      suitableFor: serializer.fromJson<String>(json['suitableFor']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'createdAt': serializer.toJson<String>(createdAt),
      'isCloseToWater': serializer.toJson<bool>(isCloseToWater),
      'isCampFireAllowed': serializer.toJson<bool>(isCampFireAllowed),
      'hostLanguages': serializer.toJson<String>(hostLanguages),
      'pricePerNight': serializer.toJson<double>(pricePerNight),
      'photo': serializer.toJson<String>(photo),
      'suitableFor': serializer.toJson<String>(suitableFor),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CampsiteDbModel copyWith({
    String? id,
    String? label,
    double? latitude,
    double? longitude,
    String? createdAt,
    bool? isCloseToWater,
    bool? isCampFireAllowed,
    String? hostLanguages,
    double? pricePerNight,
    String? photo,
    String? suitableFor,
    DateTime? updatedAt,
  }) => CampsiteDbModel(
    id: id ?? this.id,
    label: label ?? this.label,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    createdAt: createdAt ?? this.createdAt,
    isCloseToWater: isCloseToWater ?? this.isCloseToWater,
    isCampFireAllowed: isCampFireAllowed ?? this.isCampFireAllowed,
    hostLanguages: hostLanguages ?? this.hostLanguages,
    pricePerNight: pricePerNight ?? this.pricePerNight,
    photo: photo ?? this.photo,
    suitableFor: suitableFor ?? this.suitableFor,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CampsiteDbModel copyWithCompanion(CampsitesCompanion data) {
    return CampsiteDbModel(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isCloseToWater:
          data.isCloseToWater.present
              ? data.isCloseToWater.value
              : this.isCloseToWater,
      isCampFireAllowed:
          data.isCampFireAllowed.present
              ? data.isCampFireAllowed.value
              : this.isCampFireAllowed,
      hostLanguages:
          data.hostLanguages.present
              ? data.hostLanguages.value
              : this.hostLanguages,
      pricePerNight:
          data.pricePerNight.present
              ? data.pricePerNight.value
              : this.pricePerNight,
      photo: data.photo.present ? data.photo.value : this.photo,
      suitableFor:
          data.suitableFor.present ? data.suitableFor.value : this.suitableFor,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CampsiteDbModel(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('createdAt: $createdAt, ')
          ..write('isCloseToWater: $isCloseToWater, ')
          ..write('isCampFireAllowed: $isCampFireAllowed, ')
          ..write('hostLanguages: $hostLanguages, ')
          ..write('pricePerNight: $pricePerNight, ')
          ..write('photo: $photo, ')
          ..write('suitableFor: $suitableFor, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    latitude,
    longitude,
    createdAt,
    isCloseToWater,
    isCampFireAllowed,
    hostLanguages,
    pricePerNight,
    photo,
    suitableFor,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CampsiteDbModel &&
          other.id == this.id &&
          other.label == this.label &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.createdAt == this.createdAt &&
          other.isCloseToWater == this.isCloseToWater &&
          other.isCampFireAllowed == this.isCampFireAllowed &&
          other.hostLanguages == this.hostLanguages &&
          other.pricePerNight == this.pricePerNight &&
          other.photo == this.photo &&
          other.suitableFor == this.suitableFor &&
          other.updatedAt == this.updatedAt);
}

class CampsitesCompanion extends UpdateCompanion<CampsiteDbModel> {
  final Value<String> id;
  final Value<String> label;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> createdAt;
  final Value<bool> isCloseToWater;
  final Value<bool> isCampFireAllowed;
  final Value<String> hostLanguages;
  final Value<double> pricePerNight;
  final Value<String> photo;
  final Value<String> suitableFor;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CampsitesCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isCloseToWater = const Value.absent(),
    this.isCampFireAllowed = const Value.absent(),
    this.hostLanguages = const Value.absent(),
    this.pricePerNight = const Value.absent(),
    this.photo = const Value.absent(),
    this.suitableFor = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CampsitesCompanion.insert({
    required String id,
    required String label,
    required double latitude,
    required double longitude,
    required String createdAt,
    required bool isCloseToWater,
    required bool isCampFireAllowed,
    required String hostLanguages,
    required double pricePerNight,
    required String photo,
    required String suitableFor,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       latitude = Value(latitude),
       longitude = Value(longitude),
       createdAt = Value(createdAt),
       isCloseToWater = Value(isCloseToWater),
       isCampFireAllowed = Value(isCampFireAllowed),
       hostLanguages = Value(hostLanguages),
       pricePerNight = Value(pricePerNight),
       photo = Value(photo),
       suitableFor = Value(suitableFor);
  static Insertable<CampsiteDbModel> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? createdAt,
    Expression<bool>? isCloseToWater,
    Expression<bool>? isCampFireAllowed,
    Expression<String>? hostLanguages,
    Expression<double>? pricePerNight,
    Expression<String>? photo,
    Expression<String>? suitableFor,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (createdAt != null) 'created_at': createdAt,
      if (isCloseToWater != null) 'is_close_to_water': isCloseToWater,
      if (isCampFireAllowed != null) 'is_camp_fire_allowed': isCampFireAllowed,
      if (hostLanguages != null) 'host_languages': hostLanguages,
      if (pricePerNight != null) 'price_per_night': pricePerNight,
      if (photo != null) 'photo': photo,
      if (suitableFor != null) 'suitable_for': suitableFor,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CampsitesCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String>? createdAt,
    Value<bool>? isCloseToWater,
    Value<bool>? isCampFireAllowed,
    Value<String>? hostLanguages,
    Value<double>? pricePerNight,
    Value<String>? photo,
    Value<String>? suitableFor,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CampsitesCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      isCloseToWater: isCloseToWater ?? this.isCloseToWater,
      isCampFireAllowed: isCampFireAllowed ?? this.isCampFireAllowed,
      hostLanguages: hostLanguages ?? this.hostLanguages,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      photo: photo ?? this.photo,
      suitableFor: suitableFor ?? this.suitableFor,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (isCloseToWater.present) {
      map['is_close_to_water'] = Variable<bool>(isCloseToWater.value);
    }
    if (isCampFireAllowed.present) {
      map['is_camp_fire_allowed'] = Variable<bool>(isCampFireAllowed.value);
    }
    if (hostLanguages.present) {
      map['host_languages'] = Variable<String>(hostLanguages.value);
    }
    if (pricePerNight.present) {
      map['price_per_night'] = Variable<double>(pricePerNight.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (suitableFor.present) {
      map['suitable_for'] = Variable<String>(suitableFor.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CampsitesCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('createdAt: $createdAt, ')
          ..write('isCloseToWater: $isCloseToWater, ')
          ..write('isCampFireAllowed: $isCampFireAllowed, ')
          ..write('hostLanguages: $hostLanguages, ')
          ..write('pricePerNight: $pricePerNight, ')
          ..write('photo: $photo, ')
          ..write('suitableFor: $suitableFor, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CacheMetadataTable extends CacheMetadata
    with TableInfo<$CacheMetadataTable, CacheMetadataDbModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemCountMeta = const VerificationMeta(
    'itemCount',
  );
  @override
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
    'item_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [key, lastUpdated, itemCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheMetadataDbModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('item_count')) {
      context.handle(
        _itemCountMeta,
        itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CacheMetadataDbModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheMetadataDbModel(
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      lastUpdated:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_updated'],
          )!,
      itemCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}item_count'],
          )!,
    );
  }

  @override
  $CacheMetadataTable createAlias(String alias) {
    return $CacheMetadataTable(attachedDatabase, alias);
  }
}

class CacheMetadataDbModel extends DataClass
    implements Insertable<CacheMetadataDbModel> {
  final String key;
  final DateTime lastUpdated;
  final int itemCount;
  const CacheMetadataDbModel({
    required this.key,
    required this.lastUpdated,
    required this.itemCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['item_count'] = Variable<int>(itemCount);
    return map;
  }

  CacheMetadataCompanion toCompanion(bool nullToAbsent) {
    return CacheMetadataCompanion(
      key: Value(key),
      lastUpdated: Value(lastUpdated),
      itemCount: Value(itemCount),
    );
  }

  factory CacheMetadataDbModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheMetadataDbModel(
      key: serializer.fromJson<String>(json['key']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      itemCount: serializer.fromJson<int>(json['itemCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'itemCount': serializer.toJson<int>(itemCount),
    };
  }

  CacheMetadataDbModel copyWith({
    String? key,
    DateTime? lastUpdated,
    int? itemCount,
  }) => CacheMetadataDbModel(
    key: key ?? this.key,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    itemCount: itemCount ?? this.itemCount,
  );
  CacheMetadataDbModel copyWithCompanion(CacheMetadataCompanion data) {
    return CacheMetadataDbModel(
      key: data.key.present ? data.key.value : this.key,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetadataDbModel(')
          ..write('key: $key, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('itemCount: $itemCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, lastUpdated, itemCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheMetadataDbModel &&
          other.key == this.key &&
          other.lastUpdated == this.lastUpdated &&
          other.itemCount == this.itemCount);
}

class CacheMetadataCompanion extends UpdateCompanion<CacheMetadataDbModel> {
  final Value<String> key;
  final Value<DateTime> lastUpdated;
  final Value<int> itemCount;
  final Value<int> rowid;
  const CacheMetadataCompanion({
    this.key = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheMetadataCompanion.insert({
    required String key,
    required DateTime lastUpdated,
    this.itemCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       lastUpdated = Value(lastUpdated);
  static Insertable<CacheMetadataDbModel> custom({
    Expression<String>? key,
    Expression<DateTime>? lastUpdated,
    Expression<int>? itemCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (itemCount != null) 'item_count': itemCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheMetadataCompanion copyWith({
    Value<String>? key,
    Value<DateTime>? lastUpdated,
    Value<int>? itemCount,
    Value<int>? rowid,
  }) {
    return CacheMetadataCompanion(
      key: key ?? this.key,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      itemCount: itemCount ?? this.itemCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetadataCompanion(')
          ..write('key: $key, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('itemCount: $itemCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CampsiteDatabase extends GeneratedDatabase {
  _$CampsiteDatabase(QueryExecutor e) : super(e);
  $CampsiteDatabaseManager get managers => $CampsiteDatabaseManager(this);
  late final $CampsitesTable campsites = $CampsitesTable(this);
  late final $CacheMetadataTable cacheMetadata = $CacheMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    campsites,
    cacheMetadata,
  ];
}

typedef $$CampsitesTableCreateCompanionBuilder =
    CampsitesCompanion Function({
      required String id,
      required String label,
      required double latitude,
      required double longitude,
      required String createdAt,
      required bool isCloseToWater,
      required bool isCampFireAllowed,
      required String hostLanguages,
      required double pricePerNight,
      required String photo,
      required String suitableFor,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CampsitesTableUpdateCompanionBuilder =
    CampsitesCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<double> latitude,
      Value<double> longitude,
      Value<String> createdAt,
      Value<bool> isCloseToWater,
      Value<bool> isCampFireAllowed,
      Value<String> hostLanguages,
      Value<double> pricePerNight,
      Value<String> photo,
      Value<String> suitableFor,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CampsitesTableFilterComposer
    extends Composer<_$CampsiteDatabase, $CampsitesTable> {
  $$CampsitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCloseToWater => $composableBuilder(
    column: $table.isCloseToWater,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCampFireAllowed => $composableBuilder(
    column: $table.isCampFireAllowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hostLanguages => $composableBuilder(
    column: $table.hostLanguages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerNight => $composableBuilder(
    column: $table.pricePerNight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suitableFor => $composableBuilder(
    column: $table.suitableFor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CampsitesTableOrderingComposer
    extends Composer<_$CampsiteDatabase, $CampsitesTable> {
  $$CampsitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCloseToWater => $composableBuilder(
    column: $table.isCloseToWater,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCampFireAllowed => $composableBuilder(
    column: $table.isCampFireAllowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hostLanguages => $composableBuilder(
    column: $table.hostLanguages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerNight => $composableBuilder(
    column: $table.pricePerNight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suitableFor => $composableBuilder(
    column: $table.suitableFor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CampsitesTableAnnotationComposer
    extends Composer<_$CampsiteDatabase, $CampsitesTable> {
  $$CampsitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isCloseToWater => $composableBuilder(
    column: $table.isCloseToWater,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCampFireAllowed => $composableBuilder(
    column: $table.isCampFireAllowed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hostLanguages => $composableBuilder(
    column: $table.hostLanguages,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pricePerNight => $composableBuilder(
    column: $table.pricePerNight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<String> get suitableFor => $composableBuilder(
    column: $table.suitableFor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CampsitesTableTableManager
    extends
        RootTableManager<
          _$CampsiteDatabase,
          $CampsitesTable,
          CampsiteDbModel,
          $$CampsitesTableFilterComposer,
          $$CampsitesTableOrderingComposer,
          $$CampsitesTableAnnotationComposer,
          $$CampsitesTableCreateCompanionBuilder,
          $$CampsitesTableUpdateCompanionBuilder,
          (
            CampsiteDbModel,
            BaseReferences<
              _$CampsiteDatabase,
              $CampsitesTable,
              CampsiteDbModel
            >,
          ),
          CampsiteDbModel,
          PrefetchHooks Function()
        > {
  $$CampsitesTableTableManager(_$CampsiteDatabase db, $CampsitesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CampsitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CampsitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CampsitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<bool> isCloseToWater = const Value.absent(),
                Value<bool> isCampFireAllowed = const Value.absent(),
                Value<String> hostLanguages = const Value.absent(),
                Value<double> pricePerNight = const Value.absent(),
                Value<String> photo = const Value.absent(),
                Value<String> suitableFor = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CampsitesCompanion(
                id: id,
                label: label,
                latitude: latitude,
                longitude: longitude,
                createdAt: createdAt,
                isCloseToWater: isCloseToWater,
                isCampFireAllowed: isCampFireAllowed,
                hostLanguages: hostLanguages,
                pricePerNight: pricePerNight,
                photo: photo,
                suitableFor: suitableFor,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required double latitude,
                required double longitude,
                required String createdAt,
                required bool isCloseToWater,
                required bool isCampFireAllowed,
                required String hostLanguages,
                required double pricePerNight,
                required String photo,
                required String suitableFor,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CampsitesCompanion.insert(
                id: id,
                label: label,
                latitude: latitude,
                longitude: longitude,
                createdAt: createdAt,
                isCloseToWater: isCloseToWater,
                isCampFireAllowed: isCampFireAllowed,
                hostLanguages: hostLanguages,
                pricePerNight: pricePerNight,
                photo: photo,
                suitableFor: suitableFor,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CampsitesTableProcessedTableManager =
    ProcessedTableManager<
      _$CampsiteDatabase,
      $CampsitesTable,
      CampsiteDbModel,
      $$CampsitesTableFilterComposer,
      $$CampsitesTableOrderingComposer,
      $$CampsitesTableAnnotationComposer,
      $$CampsitesTableCreateCompanionBuilder,
      $$CampsitesTableUpdateCompanionBuilder,
      (
        CampsiteDbModel,
        BaseReferences<_$CampsiteDatabase, $CampsitesTable, CampsiteDbModel>,
      ),
      CampsiteDbModel,
      PrefetchHooks Function()
    >;
typedef $$CacheMetadataTableCreateCompanionBuilder =
    CacheMetadataCompanion Function({
      required String key,
      required DateTime lastUpdated,
      Value<int> itemCount,
      Value<int> rowid,
    });
typedef $$CacheMetadataTableUpdateCompanionBuilder =
    CacheMetadataCompanion Function({
      Value<String> key,
      Value<DateTime> lastUpdated,
      Value<int> itemCount,
      Value<int> rowid,
    });

class $$CacheMetadataTableFilterComposer
    extends Composer<_$CampsiteDatabase, $CacheMetadataTable> {
  $$CacheMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemCount => $composableBuilder(
    column: $table.itemCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheMetadataTableOrderingComposer
    extends Composer<_$CampsiteDatabase, $CacheMetadataTable> {
  $$CacheMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemCount => $composableBuilder(
    column: $table.itemCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheMetadataTableAnnotationComposer
    extends Composer<_$CampsiteDatabase, $CacheMetadataTable> {
  $$CacheMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);
}

class $$CacheMetadataTableTableManager
    extends
        RootTableManager<
          _$CampsiteDatabase,
          $CacheMetadataTable,
          CacheMetadataDbModel,
          $$CacheMetadataTableFilterComposer,
          $$CacheMetadataTableOrderingComposer,
          $$CacheMetadataTableAnnotationComposer,
          $$CacheMetadataTableCreateCompanionBuilder,
          $$CacheMetadataTableUpdateCompanionBuilder,
          (
            CacheMetadataDbModel,
            BaseReferences<
              _$CampsiteDatabase,
              $CacheMetadataTable,
              CacheMetadataDbModel
            >,
          ),
          CacheMetadataDbModel,
          PrefetchHooks Function()
        > {
  $$CacheMetadataTableTableManager(
    _$CampsiteDatabase db,
    $CacheMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CacheMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$CacheMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CacheMetadataTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<int> itemCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheMetadataCompanion(
                key: key,
                lastUpdated: lastUpdated,
                itemCount: itemCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required DateTime lastUpdated,
                Value<int> itemCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheMetadataCompanion.insert(
                key: key,
                lastUpdated: lastUpdated,
                itemCount: itemCount,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$CampsiteDatabase,
      $CacheMetadataTable,
      CacheMetadataDbModel,
      $$CacheMetadataTableFilterComposer,
      $$CacheMetadataTableOrderingComposer,
      $$CacheMetadataTableAnnotationComposer,
      $$CacheMetadataTableCreateCompanionBuilder,
      $$CacheMetadataTableUpdateCompanionBuilder,
      (
        CacheMetadataDbModel,
        BaseReferences<
          _$CampsiteDatabase,
          $CacheMetadataTable,
          CacheMetadataDbModel
        >,
      ),
      CacheMetadataDbModel,
      PrefetchHooks Function()
    >;

class $CampsiteDatabaseManager {
  final _$CampsiteDatabase _db;
  $CampsiteDatabaseManager(this._db);
  $$CampsitesTableTableManager get campsites =>
      $$CampsitesTableTableManager(_db, _db.campsites);
  $$CacheMetadataTableTableManager get cacheMetadata =>
      $$CacheMetadataTableTableManager(_db, _db.cacheMetadata);
}
