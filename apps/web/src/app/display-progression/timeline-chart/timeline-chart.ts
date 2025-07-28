import { AfterViewInit, Component, ElementRef, Input, OnChanges, OnDestroy, SimpleChanges, ViewChild } from '@angular/core';
import { WeightHistory } from '../weight-history';

@Component({
  selector: 'app-timeline-chart',
  standalone: true,
  templateUrl: './timeline-chart.html',
  styleUrl: './timeline-chart.scss'
})
export class TimelineChart implements OnChanges, OnDestroy {
  @Input() weightHistories: WeightHistory[] = [];

  private _plotEl?: ElementRef<HTMLDivElement>;

  @ViewChild('plot', { static: false }) set plotElSetter(el: ElementRef<HTMLDivElement> | undefined) {
    this._plotEl = el;
    this.tryRenderPlot();
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['weightHistories'] && this.weightHistories.length > 0) {
      this.tryRenderPlot();
    }
  }

  private async tryRenderPlot(): Promise<void> {
    if (this._plotEl && this.weightHistories?.length > 0) {
      await this.renderPlot();
    }
  }

  private getPlotlyTraces(weightHistories: WeightHistory[]): Partial<Plotly.PlotData>[] {
    return weightHistories.map((history, index) => {
      const sortedEntries = [...history.entries].sort(
        (a, b) => a.timestamp.getTime() - b.timestamp.getTime()
      );      
      const weightProgressionTrace: Partial<Plotly.PlotData> = {
        type: 'scatter',
        mode: 'lines+markers',
        name: history.weightName,
        x: sortedEntries.map(entry => entry.timestamp),
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
    const Plotly = await import('plotly.js-dist-min');
    Plotly.newPlot(this._plotEl!.nativeElement, traces, {
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

  async ngOnDestroy(): Promise<void> {
    if (typeof window !== 'undefined' && this._plotEl) {
      const Plotly = await import('plotly.js-dist-min');
      Plotly.purge(this._plotEl.nativeElement);
    }
  }
}
