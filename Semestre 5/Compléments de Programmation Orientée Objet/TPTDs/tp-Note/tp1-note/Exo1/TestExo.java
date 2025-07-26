package Exo1;

public class TestExo {
    
    public static void main(String[] args) {
        /* Question 3 */
        // int [] coefs = {1,3,4,1} ; 
        // Upoly c = new Upoly(coefs) ; 
        // System.out.println(c);
        // int [] coefs2 = {1,2,2} ; 
        // c.setCoefs(coefs2);
        // System.out.println(c);
        // c n'est plus un Upoly

        /* Question 4 */
        // Non , cela résoud pas notre probleme
        // car , on peut acceder aux coefs avec un getteur puis 
        // modifier le champs à notre guise
        // ce qui ne garentit pas la véracité de notre invariant

        /* Question 5 */
        // Pre-Conditionnement : 
            // 'Upoly' est un sous-type de 'Poly' seulement
            // il hérite de ses méthodes 'public' ainsi que de son atribut 'coefs' qui sera masqué
            // mais accessible et modifiable grace au 'getteur' et 'setteur'
        // Post-Conditionnement :
            // 'Upoly' reste toujours un sous-type de 'Poly'
            // avant chaque création d'une instance de 'Upoly'
            // on vérifie que coefs represente bien des coefficients d'un poly unitaire
            // on redéfinit aussi tous les setteurs hérités de 'Poly' pour préserver notre invariant

    }
}
