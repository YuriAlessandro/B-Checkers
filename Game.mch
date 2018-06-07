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
    pieces_positions1, pieces_positions2, current_player//, current_array
    
INVARIANT
    pieces_positions1 : pieces1 >-> POSITIONS & pieces_positions2 : pieces2 >-> POSITIONS & current_player : PLAYERS //& card(current_array) < 3
    
INITIALISATION
    pieces_positions1, pieces_positions2  := {0 |-> (1,1), 1 |-> (1,3), 2 |-> (1,5), 3 |-> (1,7),
        4 |-> (2,2), 5 |-> (2,4), 6 |-> (2,6), 7 |-> (2,8),
        8 |-> (3,1), 9 |-> (3,3), 10 |-> (3,5), 11 |-> (3,7)},
    {0 |-> (8,2), 1 |-> (1,4), 2 |-> (1,6), 3 |-> (1,8),
        4 |-> (7,1), 5 |-> (2,3), 6 |-> (2,5), 7 |-> (2,7),
        8 |-> (6,2), 9 |-> (3,4), 10 |-> (3,6), 11 |-> (3,8)} ||
    current_player :: PLAYERS //|| 
    //    current_array := (0..3) * {-1}
    
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
        IF (rr, cc) : ran(pieces_positions1) or (rr, cc) : ran(pieces_positions2)
        THEN ww := yes
        ELSE ww:= no
        END
    END;
    
    oo <-- move_potions(pl, pc) =
    PRE pl : PLAYERS & pc : (0..11)
    THEN 
        ANY xx, yy WHERE xx = pieces_positions1(pc) & yy = pieces_positions2(pc)
        THEN
            IF pl = P1 & pc /: checkers1 & pc : pieces1
            THEN
                ANY aoo 
                WHERE aoo : (0..3) --> (-1..8) &
                    (
                        ((SECOND(xx) = 1 & (( FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions1)))=> aoo = [-1, -1, (FIRST(xx) + 1), (SECOND(xx) + 1)] ) or // esquina coluna 1.
                        ((SECOND(xx) = 8 & (( FIRST(xx) + 1, SECOND(xx) - 1) /: ran(pieces_positions1)))=> aoo = [(FIRST(xx) + 1), (SECOND(xx)-1), -1, -1] ) or // esquina coluna 8.
                        ((SECOND(xx):(2..7) & (( FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions1)) & (( FIRST(xx) + 1, SECOND(xx)-1) /: ran(pieces_positions1))) => aoo = [(FIRST(xx) + 1), (SECOND(xx)-1), (FIRST(xx) + 1), (SECOND(xx)+1)]) or //colunas de 2 a 7
                         aoo = [-1, -1, -1, -1]
                    )
                    
                THEN oo := aoo 
                END 
            END   
        END
    END
    
END

