import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_eco_2/models/models.dart';

void main() {
  group('User Model Tests', () {
    final userJson = {
      'id': 'a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5',
      'email': 'test@example.com',
      'username': 'testuser',
      'avatar_url': 'https://example.com/avatar.png',
      'password_hash': 'hashed_password',
      'provider': 'local',
      'mfa_enabled': true,
      'plan_type': 'premium',
      'gender': 'male',
      'birth_day': '1995-05-15T00:00:00.000Z',
      'role': 'user',
      'reset_token_hash': 'reset_hash',
      'created_at': '2026-06-01T12:00:00.000Z',
      'updated_at': '2026-06-02T12:00:00.000Z',
      'deleted_at': null,
    };

    test('fromJson & toJson serialization', () {
      final user = User.fromJson(userJson);
      expect(user.id, 'a1a1a1a1-b2b2-c3c3-d4d4-e5e5e5e5e5e5');
      expect(user.email, 'test@example.com');
      expect(user.mfaEnabled, true);
      expect(user.gender, 'male');
      expect(user.birthDay, DateTime.parse('1995-05-15T00:00:00.000Z'));
      expect(user.deletedAt, isNull);

      final serialized = user.toJson();
      expect(serialized['id'], userJson['id']);
      expect(serialized['email'], userJson['email']);
      expect(serialized['birth_day'], userJson['birth_day']);
    });

    test('copyWith behaves correctly', () {
      final user = User.fromJson(userJson);
      final updatedUser = user.copyWith(username: 'newusername', mfaEnabled: false);
      expect(updatedUser.username, 'newusername');
      expect(updatedUser.mfaEnabled, false);
      expect(updatedUser.email, 'test@example.com');
    });
  });

  group('Session Model Tests', () {
    final sessionJson = {
      'id': 'session-uuid',
      'user_id': 'user-uuid',
      'refresh_token_hash': 'token-hash',
      'expires_at': '2026-06-10T12:00:00.000Z',
      'revoked_at': '2026-06-08T12:00:00.000Z',
      'created_at': '2026-06-07T12:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final session = Session.fromJson(sessionJson);
      expect(session.id, 'session-uuid');
      expect(session.revokedAt, isNotNull);

      final serialized = session.toJson();
      expect(serialized['revoked_at'], sessionJson['revoked_at']);
    });
  });

  group('Plan Model Tests', () {
    final planJson = {
      'id': 'plan-uuid',
      'name': 'standard_plan',
      'display_name': 'Standard Plan',
      'payment_frequency': 30,
      'price': 9.99,
      'plant_limit': 15,
      'ai_scans_monthly': 10,
      'has_co2_tracking': true,
      'has_advanced_stats': false,
      'active': true,
      'created_at': '2026-06-01T00:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final plan = Plan.fromJson(planJson);
      expect(plan.price, 9.99);
      expect(plan.hasCo2Tracking, true);

      final serialized = plan.toJson();
      expect(serialized['price'], 9.99);
    });
  });

  group('UserSubscription Model Tests', () {
    final subJson = {
      'id': 'sub-uuid',
      'user_id': 'user-uuid',
      'plan_id': 'plan-uuid',
      'status': 'active',
      'started_at': '2026-06-01T00:00:00.000Z',
      'expires_at': '2026-07-01T00:00:00.000Z',
      'cancelled_at': null,
    };

    test('fromJson & toJson serialization', () {
      final sub = UserSubscription.fromJson(subJson);
      expect(sub.status, 'active');
      expect(sub.expiresAt, isNotNull);
      expect(sub.cancelledAt, isNull);

      final serialized = sub.toJson();
      expect(serialized['cancelled_at'], isNull);
    });
  });

  group('PlantSpecies Model Tests', () {
    final speciesJson = {
      'id': 'species-uuid',
      'scientific_name': 'Monstera deliciosa',
      'common_name': 'Monstera',
      'category': 'interior',
      'light_requirement': 'indirect',
      'water_frequency_days': 7,
      'humidity_preference': 'high',
      'air_purification_score': 85,
      'min_temperature': 15,
      'max_temperature': 30,
      'created_at': '2026-06-01T00:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final species = PlantSpecies.fromJson(speciesJson);
      expect(species.scientificName, 'Monstera deliciosa');
      expect(species.waterFrequencyDays, 7);

      final serialized = species.toJson();
      expect(serialized['water_frequency_days'], 7);
    });
  });

  group('UserPlant Model Tests', () {
    final plantJson = {
      'id': 'plant-uuid',
      'user_id': 'user-uuid',
      'species_id': 'species-uuid',
      'nickname': 'Monty',
      'health_status': 'healthy',
      'acquired_at': '2026-06-02T00:00:00.000Z',
      'last_watered_at': '2026-06-06T00:00:00.000Z',
      'created_at': '2026-06-02T00:00:00.000Z',
      'updated_at': null,
      'deleted_at': null,
    };

    test('fromJson & toJson serialization', () {
      final plant = UserPlant.fromJson(plantJson);
      expect(plant.nickname, 'Monty');
      expect(plant.healthStatus, 'healthy');

      final serialized = plant.toJson();
      expect(serialized['nickname'], 'Monty');
    });
  });

  group('UserPlantTask Model Tests', () {
    final taskJson = {
      'id': 'task-uuid',
      'user_plant_id': 'plant-uuid',
      'task_type': 'riego',
      'next_due_at': '2026-06-13T00:00:00.000Z',
      'last_completed_at': '2026-06-06T00:00:00.000Z',
      'frequency_days': 7,
    };

    test('fromJson & toJson serialization', () {
      final task = UserPlantTask.fromJson(taskJson);
      expect(task.taskType, 'riego');
      expect(task.frequencyDays, 7);

      final serialized = task.toJson();
      expect(serialized['frequency_days'], 7);
    });
  });

  group('CareLog Model Tests', () {
    final logJson = {
      'id': 'log-uuid',
      'user_plant_id': 'plant-uuid',
      'task_type': 'poda',
      'performed_at': '2026-06-07T10:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final log = CareLog.fromJson(logJson);
      expect(log.taskType, 'poda');

      final serialized = log.toJson();
      expect(serialized['task_type'], 'poda');
    });
  });

  group('UserProgress Model Tests', () {
    final progressJson = {
      'user_id': 'user-uuid',
      'xp': 1250,
      'level': 5,
      'streak_days': 12,
      'seeds': 450,
      'updated_at': '2026-06-07T12:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final progress = UserProgress.fromJson(progressJson);
      expect(progress.xp, 1250);
      expect(progress.streakDays, 12);

      final serialized = progress.toJson();
      expect(serialized['seeds'], 450);
    });
  });

  group('XpLog Model Tests', () {
    final logJson = {
      'id': 'log-uuid',
      'user_id': 'user-uuid',
      'action_type': 'daily_watering',
      'xp_earned': 20,
      'created_at': '2026-06-07T08:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final log = XpLog.fromJson(logJson);
      expect(log.xpEarned, 20);

      final serialized = log.toJson();
      expect(serialized['xp_earned'], 20);
    });
  });

  group('SeedTransaction Model Tests', () {
    final txJson = {
      'id': 'tx-uuid',
      'user_id': 'user-uuid',
      'amount': -50,
      'reason': 'purchase_fertilizer',
      'created_at': '2026-06-07T15:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final tx = SeedTransaction.fromJson(txJson);
      expect(tx.amount, -50);

      final serialized = tx.toJson();
      expect(serialized['amount'], -50);
    });
  });

  group('Achievement Model Tests', () {
    final achJson = {
      'id': 'ach-uuid',
      'name': 'Green Thumb',
      'condition_type': 'plants_count',
      'condition_value': 5,
      'xp_reward': 100,
      'description': 'Keep 5 plants healthy.',
    };

    test('fromJson & toJson serialization', () {
      final ach = Achievement.fromJson(achJson);
      expect(ach.name, 'Green Thumb');

      final serialized = ach.toJson();
      expect(serialized['xp_reward'], 100);
    });
  });

  group('UserAchievement Model Tests', () {
    final userAchJson = {
      'id': 'ua-uuid',
      'user_id': 'user-uuid',
      'achievement_id': 'ach-uuid',
      'unlocked_at': '2026-06-07T19:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final ua = UserAchievement.fromJson(userAchJson);
      expect(ua.userId, 'user-uuid');

      final serialized = ua.toJson();
      expect(serialized['unlocked_at'], userAchJson['unlocked_at']);
    });
  });

  group('Co2Log Model Tests', () {
    final co2Json = {
      'id': 'co2-uuid',
      'user_id': 'user-uuid',
      'date': '2026-06-07',
      'co2_grams': 120.5,
      'created_at': '2026-06-07T23:59:59.000Z',
    };

    test('fromJson & toJson serialization', () {
      final log = Co2Log.fromJson(co2Json);
      expect(log.co2Grams, 120.5);
      expect(log.date.year, 2026);
      expect(log.date.month, 6);
      expect(log.date.day, 7);

      final serialized = log.toJson();
      expect(serialized['co2_grams'], 120.5);
      expect(serialized['date'], '2026-06-07');
    });
  });

  group('StoreItem Model Tests', () {
    final itemJson = {
      'id': 'item-uuid',
      'name': 'Super Pot',
      'seed_cost': 200,
      'item_type': 'pot',
      'active': true,
    };

    test('fromJson & toJson serialization', () {
      final item = StoreItem.fromJson(itemJson);
      expect(item.name, 'Super Pot');

      final serialized = item.toJson();
      expect(serialized['seed_cost'], 200);
    });
  });

  group('Room Model Tests', () {
    final roomJson = {
      'id': 'room-uuid',
      'user_id': 'user-uuid',
      'name': 'Living Room',
      'size_m2': 25.5,
      'light_level': 'high',
      'created_at': '2026-06-01T00:00:00.000Z',
      'deleted_at': null,
    };

    test('fromJson & toJson serialization', () {
      final room = Room.fromJson(roomJson);
      expect(room.name, 'Living Room');
      expect(room.sizeM2, 25.5);

      final serialized = room.toJson();
      expect(serialized['size_m2'], 25.5);
    });
  });

  group('RoomPlant Model Tests', () {
    final rpJson = {
      'room_id': 'room-uuid',
      'user_plant_id': 'plant-uuid',
    };

    test('fromJson & toJson serialization', () {
      final rp = RoomPlant.fromJson(rpJson);
      expect(rp.roomId, 'room-uuid');

      final serialized = rp.toJson();
      expect(serialized['user_plant_id'], 'plant-uuid');
    });
  });

  group('EnvironmentSnapshot Model Tests', () {
    final snapJson = {
      'id': 'snap-uuid',
      'room_id': 'room-uuid',
      'temperature': 22.4,
      'humidity': 55.0,
      'co2_level': 450.2,
      'created_at': '2026-06-07T12:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final snap = EnvironmentSnapshot.fromJson(snapJson);
      expect(snap.temperature, 22.4);
      expect(snap.humidity, 55.0);
      expect(snap.co2Level, 450.2);

      final serialized = snap.toJson();
      expect(serialized['temperature'], 22.4);
    });
  });

  group('EnvironmentalScore Model Tests', () {
    final scoreJson = {
      'id': 'score-uuid',
      'room_id': 'room-uuid',
      'score': 88.5,
      'calculated_at': '2026-06-07T12:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final score = EnvironmentalScore.fromJson(scoreJson);
      expect(score.score, 88.5);

      final serialized = score.toJson();
      expect(serialized['score'], 88.5);
    });
  });

  group('SnapshotScore Model Tests', () {
    final ssJson = {
      'id': 'ss-uuid',
      'snapshot_id': 'snap-uuid',
      'score_id': 'score-uuid',
    };

    test('fromJson & toJson serialization', () {
      final ss = SnapshotScore.fromJson(ssJson);
      expect(ss.snapshotId, 'snap-uuid');

      final serialized = ss.toJson();
      expect(serialized['score_id'], 'score-uuid');
    });
  });

  group('PlantIdentification Model Tests', () {
    final idJson = {
      'id': 'id-uuid',
      'user_id': 'user-uuid',
      'image_url': 'https://example.com/plant.jpg',
      'identified_species_id': 'species-uuid',
      'confidence_score': 0.96,
      'created_at': '2026-06-07T12:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final ident = PlantIdentification.fromJson(idJson);
      expect(ident.imageUrl, 'https://example.com/plant.jpg');
      expect(ident.confidenceScore, 0.96);

      final serialized = ident.toJson();
      expect(serialized['confidence_score'], 0.96);
    });
  });

  group('NotificationModel Tests', () {
    final notifJson = {
      'id': 'notif-uuid',
      'user_id': 'user-uuid',
      'type': 'riego_alert',
      'title': 'Need Water!',
      'reference_id': 'plant-uuid',
      'read_at': null,
      'sent_at': '2026-06-07T12:00:00.000Z',
    };

    test('fromJson & toJson serialization', () {
      final notif = NotificationModel.fromJson(notifJson);
      expect(notif.title, 'Need Water!');
      expect(notif.readAt, isNull);

      final serialized = notif.toJson();
      expect(serialized['reference_id'], 'plant-uuid');
    });
  });
}
