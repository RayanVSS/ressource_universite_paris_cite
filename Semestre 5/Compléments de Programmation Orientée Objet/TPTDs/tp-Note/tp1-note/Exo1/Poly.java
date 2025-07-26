package Exo1;

public class Poly {
    private int [] coefs ;

    Poly (int [] coefs) {
        this.coefs = coefs ; 
    }

    public int[] getCoefs() {
        return coefs;
    }

    public void setCoefs(int[] coefs) {
        this.coefs = coefs;
    }

    public void setCoef (int deg , int val) {
        if (deg >= coefs.length) return ; 
        coefs[deg] = val ; 
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