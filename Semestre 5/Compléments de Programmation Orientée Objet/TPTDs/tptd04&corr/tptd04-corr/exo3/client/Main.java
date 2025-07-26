package client;

import stats.Stats;

import java.util.List;

public class Main {
    public static void main(String[] args) {
        var series = new ListAdapter(List.of(64.51, 138.89, -25.5, 22.87));
        System.out.printf("Moyenne : %f, écart-type : %f.", Stats.average(series), Stats.stddev(series));
    }
}
