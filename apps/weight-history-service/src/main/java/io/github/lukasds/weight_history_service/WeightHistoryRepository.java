package io.github.lukasds.weight_history_service;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.cloud.FirestoreClient;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;


import org.springframework.stereotype.Repository;

@Repository
public class WeightHistoryRepository {
  public List<WeightHistoryModel> getWeightHistories() throws ExecutionException, InterruptedException {
    Firestore db = FirestoreClient.getFirestore();
    CollectionReference exercises = db.collection("lukas_exercises");
    ApiFuture<QuerySnapshot> future = exercises.get();
    List<QueryDocumentSnapshot> exerciseDocs = future.get().getDocuments();

    var weightHistories = new ArrayList<WeightHistoryModel>();

    for (QueryDocumentSnapshot exerciseDoc : exerciseDocs) {
      String weightName = exerciseDoc.getId();

      CollectionReference history = exercises.document(weightName)
        .collection("history");

      ApiFuture<QuerySnapshot> historyFuture = history.get();
      List<QueryDocumentSnapshot> historyEntryDocs = historyFuture.get().getDocuments();

      var weightHistoryEntries = new ArrayList<WeightHistoryEntryModel>();
      for (QueryDocumentSnapshot historyEntryDoc : historyEntryDocs) {
        Double value = historyEntryDoc.getDouble("weight");
        if (value == null) {
          // Skip entries without a value
          continue;
        }
        Date timestamp = historyEntryDoc.getDate("date");
        var weightHistoryEntry = new WeightHistoryEntryModel(value, timestamp);
        weightHistoryEntries.add(weightHistoryEntry);
      }

      var weightHistory = new WeightHistoryModel(weightName, weightHistoryEntries);
      weightHistories.add(weightHistory);
    }

    return weightHistories; 
  }
}
