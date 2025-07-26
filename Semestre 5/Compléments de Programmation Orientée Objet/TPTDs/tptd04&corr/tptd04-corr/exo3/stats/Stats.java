package stats;

public class Stats {
    /**
     * @param data Une série de données numériques.
     * @return La moyenne de la série de données en paramètre.
     */
    public static double average(DataSeries data) {
        var acc = 0d;
        for (int i = 0; i < data.length(); i++) acc += data.read(i);
        return acc / data.length();
    }

    /**
     * @param data Une série de données numériques.
     * @return L'écart-type de la série de données en paramètre.
     */
    public static double stddev(DataSeries data) {
        var average = average(data);
        var acc = 0d;
        for (int i = 0; i < data.length(); i++) {
            var dev = data.read(i) - average;
            acc += dev * dev;
        }
        return Math.sqrt(acc / data.length());
    }

}
