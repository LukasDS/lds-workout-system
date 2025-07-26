import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { WeightHistory } from './weight-history';

@Injectable({
  providedIn: 'root'
})
export class WeightHistoryRepository {
    private readonly apiUrl = "http://localhost:8080/weight-history";

    constructor(private http: HttpClient) {}

    getWeightHistories(): Observable<WeightHistory[]> {
      return this.http.get<WeightHistory[]>(this.apiUrl);
    }
  
}
