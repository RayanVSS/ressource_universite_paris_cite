package Exo2;

public class UpolyImmuable extends Poly {
    
    UpolyImmuable (int [] coefs) {
        super(coefs) ; 
        if (coefs[coefs.length-1] != 1) throw new IllegalArgumentException("Les coefficients representent pas ceux"
        + " d'un polynome unitaire") ; 
    }
}
