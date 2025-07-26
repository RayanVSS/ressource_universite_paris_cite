package stats;

/**
 * Série de données statistiques
 */
public interface DataSeries {
    /**
     * Lit et retourne le i-ème élément de la série.
     * @param i L'indice de la donnée à lire.
     * @return La donnée lue.
     */
    double read(int i);

    /**
     * @return Le nombre d'éléments dans la série.
     */
    int length();
}
