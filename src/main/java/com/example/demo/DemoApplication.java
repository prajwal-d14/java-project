package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;

@SpringBootApplication
@RestController
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @GetMapping("/")
    public String calendar() {
        YearMonth currentMonth = YearMonth.now();
        StringBuilder sb = new StringBuilder();

        sb.append("<h1>").append(currentMonth.getMonth()).append(" ").append(currentMonth.getYear()).append("</h1>");
        sb.append("<pre>");
        sb.append("Mon Tue Wed Thu Fri Sat Sun\n");

        LocalDate firstOfMonth = currentMonth.atDay(1);
        DayOfWeek firstDayOfWeek = firstOfMonth.getDayOfWeek();
        int dayValue = firstDayOfWeek.getValue(); // 1=Monday ... 7=Sunday

        for (int i = 1; i < dayValue; i++) {
            sb.append("    ");
        }

        for (int day = 1; day <= currentMonth.lengthOfMonth(); day++) {
            sb.append(String.format("%3d ", day));
            if ((day + dayValue - 1) % 7 == 0) {
                sb.append("\n");
            }
        }

        sb.append("</pre>");
        return sb.toString();
    }
}

