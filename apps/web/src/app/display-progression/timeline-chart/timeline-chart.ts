import { AfterViewInit, Component, ElementRef, Input, OnChanges, OnDestroy, SimpleChanges, ViewChild } from '@angular/core';
import { WeightHistory } from '../weight-history';

@Component({
  selector: 'app-timeline-chart',
  standalone: true,
  templateUrl: './timeline-chart.html',
  styleUrl: './timeline-chart.scss'
})
export class TimelineChart implements AfterViewInit, OnChanges, OnDestroy {
  @Input() weightHistories: WeightHistory[] = [];
  @ViewChild('plot', { static: true }) plotEl!: ElementRef<HTMLDivElement>;
  private isPlotlyInitialized = false;

  private getPlotlyTraces(weightHistories: WeightHistory[]): Partial<Plotly.PlotData>[] {
    return weightHistories.map((history, index) => {
      const sortedEntries = [...history.entries].sort(
        (a, b) => a.timestamp.getTime() - b.timestamp.getTime()
      );      
      const weightProgressionTrace: Partial<Plotly.PlotData> = {
        type: 'scatter',
        mode: 'lines+markers',
        name: history.weightName,
        x: sortedEntries.map(entry => entry.timestamp.toISOString()),
        y: sortedEntries.map(entry => entry.value),
        line: { shape: 'hv' },
        visible: index === 0 ? true : 'legendonly',
        hovertemplate: 'Weight: %{y}kg<br>%{x|%e %b %Y}<extra></extra>'
      };

      return weightProgressionTrace;
    });
  }

  private async renderPlot(): Promise<void> {
    const traces = this.getPlotlyTraces(this.weightHistories);
    const Plotly = (await import('plotly.js-dist-min')).default;
    Plotly.newPlot(this.plotEl.nativeElement, traces, {
      title: { text: 'Weight Progression Chart' },
      autosize: true,
      xaxis: {
        title: { text: 'Date' },
        dtick: 'M1',
        tickformat: '%b %Y',
        ticklabelmode: 'period'
      },
      yaxis: { title: { text: 'Weight (kg)' } }
    }, { responsive: true });
  }

  ngAfterViewInit(): void {
    const isWindowLoadedAndNotSSR = typeof window !== 'undefined';
    if (isWindowLoadedAndNotSSR) {
      this.renderPlot();
      this.isPlotlyInitialized = true;
    }
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (this.isPlotlyInitialized && changes['weightHistories']) {
      this.renderPlot();
    }
  }

  async ngOnDestroy(): Promise<void> {
    const isWindowLoadedAndNotSSR = typeof window !== 'undefined';
    if (isWindowLoadedAndNotSSR && this.plotEl) {
      const Plotly = (await import('plotly.js-dist-min')).default;
      Plotly.purge(this.plotEl.nativeElement);
    }
  }
}
