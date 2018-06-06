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
    
VARIABLES
    pieces_positions1, pieces_positions2, current_player
    
INVARIANT
    pieces_positions1 : pieces1 >-> POSITIONS & pieces_positions2 : pieces2 >-> POSITIONS & current_player : PLAYERS
    
INITIALISATION
    pieces_positions1, pieces_positions2  := {0 |-> (1,1), 1 |-> (1,3), 2 |-> (1,5), 3 |-> (1,7),
        4 |-> (2,2), 5 |-> (2,4), 6 |-> (2,6), 7 |-> (2,8),
        8 |-> (3,1), 9 |-> (3,3), 10 |-> (3,5), 11 |-> (3,7)},
    {0 |-> (8,2), 1 |-> (1,4), 2 |-> (1,6), 3 |-> (1,8),
        4 |-> (7,1), 5 |-> (2,3), 6 |-> (2,5), 7 |-> (2,7),
        8 |-> (6,2), 9 |-> (3,4), 10 |-> (3,6), 11 |-> (3,8)} ||
    current_player :: PLAYERS
    
OPERATIONS
    
    cp <-- actual_player = cp := current_player;
    
    move(pl,pc,rr,cc) =
    PRE pl : PLAYERS & pc : (0..11) & rr : (1..8) & cc : (1..8)
    THEN 
        IF pl = P1 
        THEN pieces_positions1 := {pc |-> (rr,cc)}
        ELSE pieces_positions2 := {pc |-> (rr,cc)}
        END
    END;
    
    ww <-- have_a_piece (rr, cc) =
    PRE rr : (1..8) & cc : (1..8)
    THEN
        IF pieces_positions1~[{(rr, cc)}] /= {} or pieces_positions2~[{(rr, cc)}] /= {}
        THEN ww := yes
        ELSE ww:= no
        END
    END
    
    fo,so <-- move_potions(pl, pc)=
    PRE pl : PLAYER, cp : (0..11)
    THEN 
        IF pl = P1
            IF pieces_positions1[pc]
        
        //    play(pl,pc,rr,cc) = 
        //        PRE pl : PLAYERS & pc : (0..11) & rr : (1..8) & cc : (1..8) & pl = current_player
        //        THEN
        //            IF is_checker(pc, pl) = no 
        //            THEN skip // Se ta aumentando p/ P1 ou diminuido p/ P2 entao (se pode andar entao anda)
        //            ELSE skip // se pode andar entao anda
        //            END
    END
    
    