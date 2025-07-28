import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TimelineChart } from './timeline-chart';

describe('TimelineChart', () => {
  let component: TimelineChart;
  let fixture: ComponentFixture<TimelineChart>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TimelineChart]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TimelineChart);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
