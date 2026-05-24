import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workout/features/workout/data/firebase_workout_repository.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockTransaction extends Mock implements Transaction {}

class FakeSetOptions extends Fake implements SetOptions {}
class FakeDocumentReference extends Fake implements DocumentReference<Map<String, dynamic>> {}
class FakeDocumentReferenceObject extends Fake implements DocumentReference<Object?> {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockDocumentSnapshot mockSnapshot;
  late FirebaseWorkoutRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeSetOptions());
    registerFallbackValue(FakeDocumentReference());
    registerFallbackValue(FakeDocumentReferenceObject());
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(Timestamp.now());
    registerFallbackValue((Transaction transaction) async {});
    registerFallbackValue((Transaction transaction) async => null);
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();
    repository = FirebaseWorkoutRepository(mockFirestore);

    when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocument);

    // Default mock for runTransaction to avoid Null subtype errors
    when(() => mockFirestore.runTransaction<void>(any()))
        .thenAnswer((_) => Future.value());
    when(() => mockFirestore.runTransaction<Null>(any()))
        .thenAnswer((_) => Future.value(null));
  });

  group('FirebaseWorkoutRepository', () {
    test('watchCurrentWeight returns stream of double', () {
      when(() => mockDocument.snapshots()).thenAnswer((_) => Stream.fromIterable([mockSnapshot]));
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.get('currentWeight')).thenReturn(80.5);

      final stream = repository.watchCurrentWeight('Bench Press');

      expect(stream, emits(80.5));
    });

    test('watchCurrentWeight returns null if snapshot does not exist', () {
      when(() => mockDocument.snapshots()).thenAnswer((_) => Stream.fromIterable([mockSnapshot]));
      when(() => mockSnapshot.exists).thenReturn(false);

      final stream = repository.watchCurrentWeight('Bench Press');

      expect(stream, emits(null));
    });

    test('setCurrentWeight sets weight to null if weight is null', () async {
      when(() => mockDocument.set(any(), any())).thenAnswer((_) => Future.value());

      await repository.setCurrentWeight('Bench Press', null);

      verify(() => mockDocument.set({'currentWeight': null}, any())).called(1);
    });

    test('setCurrentWeight runs transaction if weight is provided', () async {
      final mockTransaction = MockTransaction();
      final mockHistoryCollection = MockCollectionReference();
      final mockHistoryDoc = MockDocumentReference();

      when(() => mockDocument.collection('history')).thenReturn(mockHistoryCollection);
      when(() => mockHistoryCollection.doc(any())).thenReturn(mockHistoryDoc);
      
      when(() => mockTransaction.set<Map<String, dynamic>>(any(), any(), any())).thenReturn(mockTransaction);
      when(() => mockTransaction.set<Map<String, dynamic>>(any(), any())).thenReturn(mockTransaction);

      when(() => mockFirestore.runTransaction<void>(any()))
          .thenAnswer((invocation) async {
        final handler = invocation.positionalArguments[0] as TransactionHandler<void>;
        return handler(mockTransaction);
      });
      when(() => mockFirestore.runTransaction<Null>(any()))
          .thenAnswer((invocation) async {
        final handler = invocation.positionalArguments[0] as TransactionHandler<Null>;
        return handler(mockTransaction);
      });

      await repository.setCurrentWeight('Bench Press', 90.0);

      // Verify either void or Null transaction was run
      final capturedTransaction = verify(() => mockFirestore.runTransaction<Null>(any())).called(1);
      
      verify(() => mockTransaction.set<Map<String, dynamic>>(mockDocument, {'currentWeight': 90.0}, any())).called(1);
      verify(() => mockTransaction.set<Map<String, dynamic>>(mockHistoryDoc, any())).called(1);
    });
  });
}
