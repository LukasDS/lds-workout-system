import { Component } from '@angular/core';
import { WeightHistoryRepository } from '../weight-history-repository';
import { Observable } from 'rxjs';
import { WeightHistory } from '../weight-history';

@Component({
  selector: 'app-home',
  imports: [],
  templateUrl: './home.html',
  styleUrl: './home.scss'
})
export class Home {
  weightHistories: WeightHistory[] = [];

  constructor(private weightHistoryRepository: WeightHistoryRepository) { }

  ngOnInit() {
    this.loadWeightHistories();
  }

  loadWeightHistories() {
    this.weightHistoryRepository.getWeightHistories().subscribe(data => {
      this.weightHistories = data;
    })
  }
}
