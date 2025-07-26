package Exo2;

public class RingImmuable {

    public static abstract sealed class Poly permits Upoly{
        private int [] coefs ;

        Poly (int [] coefs) {
            this.coefs = new int[coefs.length] ; 
            for (int i = 0 ; i<coefs.length ; i++) {
                this.coefs[i] = coefs[i] ; 
            }
        }

        public int[] getCoefs() { // renvoyer une copie de coefs
            int [] res = new int[coefs.length] ; 
            for (int i = 0 ; i<res.length ; i++) {
                res[i] = coefs[i] ; 
            }
            return res ; 
        }

        @Override
        public String toString () {
            String res = coefs[0]+" + " ; 
            for (int i = 1; i < coefs.length-1; i++) {
                res+= coefs[i] + "X^" + i + " + " ; 
            }
            return res + coefs[coefs.length-1] + "X^" + (coefs.length-1) ; 
        }
    }

    public static final class Upoly extends Poly {
        
        Upoly(int [] coefs) {
            super(coefs) ; 
            if (coefs[coefs.length-1] != 1) throw new IllegalArgumentException("Les coefficients representent pas ceux"
            + " d'un polynome unitaire") ; 
        }
    }

}

