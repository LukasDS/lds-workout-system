import { Component } from '@angular/core';
import { WeightHistoryRepository } from '../weight-history-repository';
import { WeightHistory } from '../weight-history';
import { TimelineChart } from '../timeline-chart/timeline-chart';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [TimelineChart],
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
