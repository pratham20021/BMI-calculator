package com.bmi.service;

import com.bmi.model.BmiResponse;
import org.springframework.stereotype.Service;

@Service
public class BmiService {

    public BmiResponse calculate(double weight, double height) {
        double bmi = Math.round((weight / (height * height)) * 100.0) / 100.0;
        String category = getCategory(bmi);
        return new BmiResponse(bmi, category);
    }

    private String getCategory(double bmi) {
        if (bmi < 18.5) return "Underweight";
        if (bmi < 25.0) return "Normal";
        if (bmi < 30.0) return "Overweight";
        return "Obese";
    }
}
