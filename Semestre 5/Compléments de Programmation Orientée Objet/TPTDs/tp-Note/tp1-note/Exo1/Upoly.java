package Exo1;

public class Upoly extends Poly{
    
    Upoly (int [] coefs) {
        super(coefs) ; 
        if (coefs[coefs.length-1] != 1) throw new IllegalArgumentException() ; 
    }

    @Override
    public void setCoefs (int [] coefs) {
        if (coefs[coefs.length -1] == 1) super.setCoefs(coefs);
    }

    @Override
    public void setCoef (int deg , int val) {
        if (deg == getCoefs().length-1 && val != 1) return ; 
        super.setCoef(deg, val);
    }

}
