/* Players
* Author: PedroArthur
* Creation date: 01/06/2018
*/
MACHINE
    Players
SETS
    PLAYERS = {P1, P2}; ANSWER = {yes, no}   
VARIABLES
    pieces1, pieces2, checkers1, checkers2
INVARIANT
    pieces1 <: (0..11) &  pieces2 <: (0..11) & checkers1 <: pieces1 & checkers2 <: pieces2
INITIALISATION 
    pieces1, pieces2, checkers1, checkers2 := (0..11),(0..11), {}, {}
    
OPERATIONS 
    remove_piece(pc,pl)=
    PRE pc:(0..11) & pc /: checkers1 & pc /: checkers2 & pl:PLAYERS
    THEN
        IF pl = P1
        THEN pieces1 := pieces1 - {pc}
        ELSE pieces2 := pieces2 - {pc}
        END
    END;
    
    remove_checker(pc,pl)=
    PRE pc:(0..11) & (pc:checkers1 or pc:checkers2) & pl:PLAYERS 
    THEN
        IF pl = P1 & pc : checkers1
        THEN pieces1, checkers1 := pieces1 - {pc}, checkers1 - {pc}
        ELSE pieces2, checkers2 := pieces2 - {pc}, checkers2 - {pc}
        END
    END;
    
    promote_to_checker(pc,pl)=
    PRE pc:(0..11) & pl:PLAYERS 
    THEN
        IF pl = P1 & pc:pieces1 & pc/:checkers1
        THEN checkers1 := checkers1 \/ {pc}
        ELSE IF pl = P2 & pc:pieces2 & pc/:checkers2
            THEN checkers2 := checkers2 \/ {pc}
            END
        END
    END;
    
    aa <-- is_checker(pc, pl)=
    PRE pc:(0..11) & pl:PLAYERS 
    THEN
        IF (pl = P1 & pc:pieces1 & pc:checkers1) or (pl = P2 & pc:pieces2 & pc:checkers2)
        THEN aa := yes
        ELSE
            aa := no
        END 
    END;
    
    ww <-- get_winner =
    PRE card(pieces1) = 0 or card(pieces2) = 0
    THEN
        IF card(pieces2) = 0
        THEN ww := P1
        ELSE IF card(pieces1) = 0
            THEN ww:= P2
            END
        END
    END
END
