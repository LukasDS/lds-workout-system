package io.github.lukasds.weight_history_service.config;

import java.io.IOException;
import java.io.InputStream;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

@Configuration
public class FirebaseConfig {
  @Bean
  public FirebaseApp FirebaseApp() throws IOException {
    if (FirebaseApp.getApps().isEmpty() == false) {
      return FirebaseApp.getInstance();
    }

    InputStream serviceAccount = new ClassPathResource("serviceAccountKey.json").getInputStream();

    String projectId = System.getProperty("firebase.project.id");
    FirebaseOptions options = FirebaseOptions.builder()
      .setCredentials(GoogleCredentials.fromStream(serviceAccount))
      .setDatabaseUrl("https://" + projectId + "firebaseio.com")
      .build();

    return FirebaseApp.initializeApp(options);
  }
}
