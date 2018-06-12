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
    pieces_positions1, pieces_positions2, current_player, current_array, current_piece
    
INVARIANT
    pieces_positions1 : pieces1 >-> POSITIONS & pieces_positions2 : pieces2 >-> POSITIONS & current_player : PLAYERS & current_array : (0..3)-->(0..8) & current_piece : (-1..11)
    
INITIALISATION
    pieces_positions1, pieces_positions2  := {0 |-> (1,1), 1 |-> (1,3), 2 |-> (1,5), 3 |-> (1,7),
        4 |-> (2,2), 5 |-> (2,4), 6 |-> (2,6), 7 |-> (2,8),
        8 |-> (3,1), 9 |-> (3,3), 10 |-> (3,5), 11 |-> (3,7)},
    {0 |-> (8,2), 1 |-> (8,4), 2 |-> (8,6), 3 |-> (8,8),
        4 |-> (7,1), 5 |-> (7,3), 6 |-> (7,5), 7 |-> (7,7),
        8 |-> (6,2), 9 |-> (6,4), 10 |-> (6,6), 11 |-> (6,8)} ||
    current_player :: PLAYERS || 
    current_array := (0..3) * {0} ||
    current_piece := -1
    
OPERATIONS
    
    cp <-- get_current_player = cp := current_player;
    
    ca <-- get_current_array = ca := current_array;   
    
    move(rr,cc) =
    PRE current_piece : (0..11) & rr : (1..8) & cc : (1..8) & (rr = current_array(0) or rr = current_array(2)) & (cc = current_array(1) or cc = current_array(3))
    THEN  current_array := (0..3) * {0} ||
        IF current_player = P1 & current_piece : pieces1
        THEN pieces_positions1 := pieces_positions1 <+ { current_piece |-> (rr,cc)} || current_player := P2 ||
            IF rr = 8
            THEN promote_to_checker(current_piece, current_player) 
            END
        ELSE 
            IF current_player = P2 & current_piece : pieces2
            THEN pieces_positions2 := pieces_positions2 <+ { current_piece |-> (rr,cc)} || current_player := P1 ||
                IF rr = 1
                THEN promote_to_checker(current_piece, current_player) 
                END
            END
        END ||
        current_piece := -1
        
    END;
    
    ww <-- have_a_piece (rr, cc) =
    PRE rr : (1..8) & cc : (1..8)
    THEN
        IF (rr, cc) : ran(pieces_positions1) or (rr, cc) : ran(pieces_positions2)
        THEN ww := yes
        ELSE ww:= no
        END
    END;
    
    oo <-- move_options(pc) =
    PRE pc : (0..11)
    THEN 
        current_piece := pc ||
        ANY xx, yy WHERE xx = pieces_positions1(pc) & yy = pieces_positions2(pc)
        THEN
            IF current_player = P1 & pc /: checkers1 & pc : pieces1
            THEN
                ANY aoo 
                WHERE aoo : (0..3) --> (0..8) &
                    (
                        (SECOND(xx) = 1                                                     // É a primeira coluna
                            & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions1)     // Se não tiver peça de P1
                            & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions2)     // Se não tiver peça de P2
                            & aoo = {0|->0, 1|->0, 2|->(FIRST(xx) + 1), 3|->(SECOND(xx) + 1)}) or           // Atribuição I
                        (SECOND(xx) = 8                                                     // É a última coluna
                            & (FIRST(xx) + 1, SECOND(xx) - 1) /: ran(pieces_positions1)     // Se não tiver peça de P1  
                            & (FIRST(xx) + 1, SECOND(xx) - 1) /: ran(pieces_positions2)     // Se não tiver peça de P2
                            & aoo = {0|->(FIRST(xx) + 1), 1|->(SECOND(xx) - 1), 2|->0, 3|->0}) or          // Atribuição II
                        (SECOND(xx):(2..7)                                                  // É qualquer coluna do meio
                            & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions1)     // A direita não tem peça de 1  
                            & (FIRST(xx) + 1, SECOND(xx)- 1) /: ran(pieces_positions1)      // A esquerda não tem peça de 1
                            & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions2)     // A direita não tem peça de 2
                            & (FIRST(xx) + 1, SECOND(xx)- 1) /: ran(pieces_positions2)      // A esquerda não tem peça de 2
                            & aoo = {0|->(FIRST(xx) + 1), 1|->(SECOND(xx) - 1), 2|->(FIRST(xx) + 1), 3|->(SECOND(xx) + 1)})or // Atribuição III
                        (SECOND(xx):(2..7)                                                  // Só possui peça na esquerda
                            & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions1)     // A direita não tem peça de 1
                            & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions2)     // A direita não tem peça de 2
                            & ((FIRST(xx) + 1, SECOND(xx)- 1) : ran(pieces_positions1)      // A esquerda tem peça de 1 ou
                                or (FIRST(xx) + 1, SECOND(xx)- 1) : ran(pieces_positions2)) // A esquerda tem peça de 2
                            & aoo = {0|->0, 1|->0, 2|->(FIRST(xx) + 1), 3|->(SECOND(xx) + 1)})or // Atribuição IV
                        (SECOND(xx):(2..7)                                                  // Só possui peça na direita
                            & ((FIRST(xx) + 1, SECOND(xx) + 1) : ran(pieces_positions1)     // A direita tem peça de 1 ou 
                                or (FIRST(xx) + 1, SECOND(xx) + 1) : ran(pieces_positions2))// A direita tem peça de 2
                            & (FIRST(xx) + 1, SECOND(xx)- 1) /: ran(pieces_positions1)      // A esquerda não tem peça de 1
                            & (FIRST(xx) + 1, SECOND(xx)- 1) /: ran(pieces_positions2)      // A esquerda não tem peça de 2
                            & aoo = {0|->(FIRST(xx) + 1), 1|->(SECOND(xx) - 1), 2|->0, 3|->0})or // Atribuição V
                        (not(
                                (SECOND(xx) = 1                                                       // É a primeira coluna
                                    & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions1)       // Se não tiver peça de P1
                                    & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions2)) or   // Se não tiver peça de P2
                                (SECOND(xx) = 8                                                       // É a última coluna
                                    & (FIRST(xx) + 1, SECOND(xx) - 1) /: ran(pieces_positions1)       // Se não tiver peça de P1  
                                    & (FIRST(xx) + 1, SECOND(xx) - 1) /: ran(pieces_positions2)) or   // Se não tiver peça de P2  
                                (SECOND(xx):(2..7)                                                    // É qualquer coluna do meio
                                    & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions1)       // A direita não tem peça de 1  
                                    & (FIRST(xx) + 1, SECOND(xx) - 1) /: ran(pieces_positions1)       // A esquerda não tem peça de 1
                                    & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions2)       // A direita não tem peça de 2
                                    & (FIRST(xx) + 1, SECOND(xx) - 1) /: ran(pieces_positions2)) or      // A esquerda não tem peça de 2
                                (SECOND(xx):(2..7)                                                    // Só possui peça na esquerda
                                    & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions1)       // A direita não tem peça de 1  
                                    & (FIRST(xx) + 1, SECOND(xx) + 1) /: ran(pieces_positions2)       // A direita não tem peça de 2
                                    & ((FIRST(xx) + 1, SECOND(xx) - 1) : ran(pieces_positions1)       // A esquerda tem peça de 1 ou
                                        or (FIRST(xx) + 1, SECOND(xx) - 1) : ran(pieces_positions2))) or  // A esquerda tem peça de 2
                                (SECOND(xx):(2..7)                                                    // Só possui peça na direita
                                    & ((FIRST(xx) + 1, SECOND(xx) + 1) : ran(pieces_positions1)       // A direita tem peça de 1 ou
                                        or (FIRST(xx) + 1, SECOND(xx) + 1) : ran(pieces_positions2))  // A direita tem peça de 2
                                    & (FIRST(xx) + 1, SECOND(xx) - 1) /: ran(pieces_positions1)        // A esquerda não tem peça de 1
                                    & (FIRST(xx) + 1, SECOND(xx) - 1) /: ran(pieces_positions2))       // A esquerda não tem peça de 2
                            )
                            & aoo = {0|->0, 1|->0, 2|->0, 3|->0}) // Não possui opções
                    )
                    
                THEN oo := aoo || current_array := aoo
                END
            ELSE
                IF current_player = P2 & pc /: checkers2 & pc : pieces2
                THEN
                    ANY aoo 
                    WHERE aoo : (0..3) --> (0..8) &
                        (
                            (SECOND(yy) = 1                                                          // É a primeira coluna
                                & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions1)          // Se não tiver peça de P1
                                & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions2)          // Se não tiver peça de P2
                                & aoo = {0|->0, 1|->0, 2|->(FIRST(yy) - 1), 3|->(SECOND(yy) + 1)}) or  // Atribuição I
                            (SECOND(yy) = 8                                                          // É a última coluna
                                & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions1)          // Se não tiver peça de P1  
                                & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions2)          // Se não tiver peça de P2
                                & aoo = {0|->(FIRST(yy) - 1), 1|->(SECOND(yy) - 1), 2|->0, 3|->0}) or   // Atribuição II
                            (SECOND(yy):(2..7)                                                       // É qualquer coluna do meio
                                & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions1)          // A direita não tem peça de 1  
                                & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions1)          // A esquerda não tem peça de 1
                                & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions2)          // A direita não tem peça de 2
                                & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions2)          // A esquerda não tem peça de 2
                                & aoo = {0|->(FIRST(yy) - 1), 1|->(SECOND(yy) - 1), 2|->(FIRST(yy) - 1), 3|->(SECOND(yy) + 1)}) or  // Atribuição III
                            (SECOND(yy):(2..7)                                                      // Só possui peça na esquerda
                                & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions1)         // A direita não tem peça de 1  
                                & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions2)         // A direita não tem peça de 2
                                & ((FIRST(yy) - 1, SECOND(yy) - 1) : ran(pieces_positions1)         // A esquerda tem peça de 1 ou
                                    or (FIRST(yy) - 1, SECOND(yy) - 1) : ran(pieces_positions2))    // A esquerda tem peça de 2
                                & aoo = {0|->0, 1|->0, 2|->(FIRST(yy) - 1), 3|->(SECOND(yy) + 1)}) or // Atribuição IV
                            (SECOND(yy):(2..7)                                                      // Só possui peça na direita
                                & ((FIRST(yy) - 1, SECOND(yy) + 1) : ran(pieces_positions1)         // A direita tem peça de 1 ou  
                                    or (FIRST(yy) - 1, SECOND(yy) + 1) : ran(pieces_positions2))    // A direita tem peça de 2
                                & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions1)         // A esquerda não tem peça de 1
                                & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions2)         // A esquerda não tem peça de 2
                                & aoo = {0|->(FIRST(yy) - 1), 1|->(SECOND(yy) - 1), 2|->0, 3|->0}) or // Atribuição V
                            (not(
                                    (SECOND(yy) = 1                                                       // É a primeira coluna
                                        & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions1)       // Se não tiver peça de P1
                                        & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions2)) or   // Se não tiver peça de P2
                                    (SECOND(yy) = 8                                                       // É a última coluna
                                        & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions1)       // Se não tiver peça de P1  
                                        & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions2)) or   // Se não tiver peça de P2
                                    (SECOND(yy):(2..7)                                                    // É qualquer coluna do meio
                                        & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions1)       // A direita não tem peça de 1  
                                        & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions1)       // A esquerda não tem peça de 1
                                        & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions2)       // A direita não tem peça de 2
                                        & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions2)) or   // A direita não tem peça de 1
                                    (SECOND(xx):(2..7)                                                    // Só possui peça na esquerda
                                        & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions1)       // A direita não tem peça de 1  
                                        & (FIRST(yy) - 1, SECOND(yy) + 1) /: ran(pieces_positions2)       // A direita não tem peça de 2
                                        & ((FIRST(yy) - 1, SECOND(yy) - 1) : ran(pieces_positions1)       // A esquerda tem peça de 1 ou
                                            or (FIRST(yy) + 1, SECOND(yy) - 1) : ran(pieces_positions2))) or  // A esquerda tem peça de 2
                                    (SECOND(yy):(2..7)                                                    // Só possui peça na direita
                                        & ((FIRST(yy) - 1, SECOND(yy) + 1) : ran(pieces_positions1)       // A direita tem peça de 1 ou 
                                            or (FIRST(yy) - 1, SECOND(yy) + 1) : ran(pieces_positions2))  // A direita tem peça de 2
                                        & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions1)       // A esquerda não tem peça de 1
                                        & (FIRST(yy) - 1, SECOND(yy) - 1) /: ran(pieces_positions2))      // A esquerda não tem peça de 2
                                )     
                                &  aoo = {0|->0, 1|->0, 2|->0, 3|->0}) // Não possui opções
                        )
                        
                    THEN oo := aoo || current_array := aoo 
                    END
                END
            END   
        END
    END;
    
    eat(pc, tg) =
    PRE  pc:(0..11) & tg:(0..11) & ((pc : pieces1 & tg : pieces2) or (pc : pieces2 & tg : pieces1))
    THEN
        //PARA O P1
        IF current_player = P1 & pc : pieces1 & tg : pieces2
        THEN
            // se tg estiver a esquerda
            IF (FIRST(pieces_positions1(pc)) + 1, SECOND(pieces_positions1(pc)) - 1) = (FIRST(pieces_positions2(tg)), SECOND(pieces_positions2(tg)))
            THEN
                //se não houver peça a esqueda para cima de tg
                IF (FIRST(pieces_positions2(tg)) + 1, SECOND(pieces_positions2(tg)) - 1) /: (ran(pieces_positions2) \/ ran(pieces_positions1)) 
                THEN
                    //move
                    pieces_positions1 := pieces_positions1 <+ { pc |-> (FIRST(pieces_positions1(pc)) + 2 , SECOND(pieces_positions1(pc)) - 2)} || current_player := P2 ||
                    remove_piece(tg,P2)|| pieces_positions2 := {tg} <<| pieces_positions2
                END
            ELSE
                // se tg estiver a direita
                IF (FIRST(pieces_positions1(pc)) + 1, SECOND(pieces_positions1(pc)) + 1) = (FIRST(pieces_positions2(tg)), SECOND(pieces_positions2(tg)))
                THEN
                    //se não houver peça a direita para cima de tg
                    IF (FIRST(pieces_positions2(tg)) + 1, SECOND(pieces_positions2(tg)) + 1) /: (ran(pieces_positions2) \/ ran(pieces_positions1)) 
                    THEN
                        //move
                        pieces_positions1 := pieces_positions1 <+ { pc |-> (FIRST(pieces_positions1(pc)) + 2 , SECOND(pieces_positions1(pc)) + 2)} || current_player := P2 ||
                        remove_piece(tg,P2)|| pieces_positions2 := {tg} <<| pieces_positions2 //||
                    END
                END
            END
            //////////////////////////////////////////////////////////
        ELSE
            //PARA O P2
            IF current_player = P2 & pc : pieces2 & tg : pieces1
            THEN
                // se tg estiver a esquerda
                IF (FIRST(pieces_positions2(pc)) - 1, SECOND(pieces_positions2(pc)) - 1) = (FIRST(pieces_positions1(tg)), SECOND(pieces_positions1(tg)))
                THEN
                    //se não houver peça a esuqeda para baixo de tg
                    IF (FIRST(pieces_positions1(tg)) - 1, SECOND(pieces_positions1(tg)) - 1) /: (ran(pieces_positions2) \/ ran(pieces_positions1)) 
                    THEN
                        //move
                        pieces_positions2 := pieces_positions2 <+ { pc |-> (FIRST(pieces_positions2(pc)) - 2 , SECOND(pieces_positions2(pc)) - 2)} || current_player := P1 ||
                        remove_piece(tg,P1)|| pieces_positions1 := {tg} <<| pieces_positions1 
                    END
                ELSE
                    // se tg estiver a direita
                    IF (FIRST(pieces_positions2(pc)) - 1, SECOND(pieces_positions2(pc)) + 1) = (FIRST(pieces_positions1(tg)), SECOND(pieces_positions1(tg)))
                    THEN
                        //se não houver peça a esuqeda para cima de tg
                        IF (FIRST(pieces_positions1(tg)) - 1, SECOND(pieces_positions1(tg)) + 1) /: (ran(pieces_positions2) \/ ran(pieces_positions1)) 
                        THEN
                            //move
                            pieces_positions2 := pieces_positions2 <+ { pc |-> (FIRST(pieces_positions2(pc)) - 2 , SECOND(pieces_positions2(pc)) + 2)} || current_player := P1 ||
                            remove_piece(tg,P1)|| pieces_positions1 := {tg} <<| pieces_positions1
                        END
                    END   
                END
            END
        END
    END
END 


