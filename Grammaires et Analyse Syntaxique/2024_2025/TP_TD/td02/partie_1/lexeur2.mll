{
open Token
}

let digit=['0'-'9']
let other=[^'0'-'9']

rule lexeur = parse
        | digit as s {DIGIT(int_of_char s - int_of_char '0')}
        | other {OTHER}
        | eof {EOF}
        | _  {exit 0}

            
