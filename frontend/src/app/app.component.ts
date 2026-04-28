import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { BmiService, BmiResponse } from './bmi.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  weight: number | null = null;
  height: number | null = null;
  result: BmiResponse | null = null;
  errorMessage = '';
  loading = false;

  constructor(private bmiService: BmiService) {}

  calculate() {
    this.result = null;
    this.errorMessage = '';

    if (!this.weight || !this.height || this.weight <= 0 || this.height <= 0) {
      this.errorMessage = 'Please enter valid positive values for weight and height.';
      return;
    }

    this.loading = true;
    this.bmiService.calculate({ weight: this.weight, height: this.height }).subscribe({
      next: (data) => {
        this.result = data;
        this.loading = false;
      },
      error: () => {
        this.errorMessage = 'Could not connect to the server. Make sure the backend is running on port 8080.';
        this.loading = false;
      }
    });
  }

  getCategoryClass(): string {
    return this.result?.category ?? '';
  }
}
