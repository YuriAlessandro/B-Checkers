/* Game
* Author: PedroArthur
* Creation date: 04/06/2018
*/
MACHINE
    Game
    
INCLUDES
    Players
    
PROMOTES
    get_winner
    
SEES
    Table
    
CONSTANTS
    FIRST, SECOND
    
PROPERTIES 
    FIRST = %(tt, cc). (tt : (1..8) & cc: (1..8) | tt) &
    SECOND = %(tt, cc). (tt : (1..8) & cc: (1..8) | cc)
    
VARIABLES
    pieces_positions1, pieces_positions2, current_player, current_array
    
INVARIANT
    pieces_positions1 : pieces1 >-> POSITIONS & pieces_positions2 : pieces2 >-> POSITIONS & current_player : PLAYERS & card(current_array) < 3
    
INITIALISATION
    pieces_positions1, pieces_positions2  := {0 |-> (1,1), 1 |-> (1,3), 2 |-> (1,5), 3 |-> (1,7),
        4 |-> (2,2), 5 |-> (2,4), 6 |-> (2,6), 7 |-> (2,8),
        8 |-> (3,1), 9 |-> (3,3), 10 |-> (3,5), 11 |-> (3,7)},
    {0 |-> (8,2), 1 |-> (1,4), 2 |-> (1,6), 3 |-> (1,8),
        4 |-> (7,1), 5 |-> (2,3), 6 |-> (2,5), 7 |-> (2,7),
        8 |-> (6,2), 9 |-> (3,4), 10 |-> (3,6), 11 |-> (3,8)} ||
    current_player :: PLAYERS || 
    current_array := (0..3) * {-1}
    
OPERATIONS
    
    cp <-- get_current_player = cp := current_player;
    
    move(pl,pc,rr,cc) =
    PRE pl : PLAYERS & pc : (0..11) & rr : (1..8) & cc : (1..8)
    THEN 
        IF pl = P1 
        THEN pieces_positions1 := { pc |-> (rr,cc)}
        ELSE pieces_positions2 := { pc |-> (rr,cc)}
        END
    END;
    
    ww <-- have_a_piece (rr, cc) =
    PRE rr : (1..8) & cc : (1..8)
    THEN
        IF pieces_positions1~[{(rr, cc)}] /= {} or pieces_positions2~[{(rr, cc)}] /= {}
        THEN ww := yes
        ELSE ww:= no
        END
    END;
    
    oo <-- move_potions(pl, pc) =
    PRE pl : PLAYERS & pc : (0..11)
    THEN 
        ANY xx, yy, aoo WHERE xx : pieces_positions1[{pc}] & yy : pieces_positions2[{pc}] & aoo = {0|-> -1, 1|-> -1, 2|-> -1, 3|-> -1}
        THEN
            IF pl = P1
            THEN
                IF pieces_positions1~[{(FIRST(xx) + 1, SECOND(xx) + 1)}] = {}
                THEN aoo := aoo <+ {0 |-> 0}
                END
            ELSE
                IF pieces_positions2~[{(FIRST(yy) - 1, SECOND(yy) + 1)}] = {}
                THEN skip // posso ir pra direita
                END
            END
            // rr = FST(pieces_positions1[pc]) + 1 // cc = second(pieces_positions1[pc])
        END
     END
        
        //    
        //    tt <-- test(pl, pc) = 
        //    PRE pl : PLAYERS & pc : (0..11)
        //    THEN
        //        ANY xx, yy WHERE xx: pieces_positions1[{pc}] & yy:pieces_positions2[{pc}]
        //        THEN
        //            IF pl = P1
        //            THEN tt := FIRST(xx)
        //            ELSE tt := SECOND(xx)
        //            END
        //        END
        //    END
        //    
        //    play(pl,pc,rr,cc) = 
        //        PRE pl : PLAYERS & pc : (0..11) & rr : (1..8) & cc : (1..8) & pl = current_player
        //        THEN
        //            IF is_checker(pc, pl) = no 
        //            THEN skip // Se ta aumentando p/ P1 ou diminuido p/ P2 entao (se pode andar entao anda)
        //            ELSE skip // se pode andar entao anda
        //            END
    END
    
    