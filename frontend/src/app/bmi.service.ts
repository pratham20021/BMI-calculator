import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface BmiRequest {
  weight: number;
  height: number;
}

export interface BmiResponse {
  bmi: number;
  category: string;
}

@Injectable({ providedIn: 'root' })
export class BmiService {
  private apiUrl = 'http://localhost:8080/api/calculate';

  constructor(private http: HttpClient) {}

  calculate(data: BmiRequest): Observable<BmiResponse> {
    return this.http.post<BmiResponse>(this.apiUrl, data);
  }
}
