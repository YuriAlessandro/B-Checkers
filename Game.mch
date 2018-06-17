/* Game
* Author: PedroArthur
* Creation date: 04/06/2018
*/
MACHINE
    Game
    
    //INCLUDES
    //    Players
    
    //PROMOTES
    //    get_winner
    
SEES
    Table
    
SETS
    PLAYERS = {P1, P2}; ANSWER = {yes, no}   
    
VARIABLES
    pieces1, pieces2, checkers1, checkers2,
    pieces_positions1, pieces_positions2, current_player, current_array, current_piece
    
INVARIANT
    pieces1 <: (0..11) 
    & pieces2 <: (0..11)
    & checkers1 <: pieces1 
    & checkers2 <: pieces2
    & pieces_positions1 : pieces1 >-> POSITIONS 
    & pieces_positions2 : pieces2 >-> POSITIONS 
    & current_player : PLAYERS 
    & current_array : (0..3)-->(0..8) 
    & current_piece : (-1..11)
    
INITIALISATION
    pieces1, pieces2, checkers1, checkers2 := (0..11),(0..11), {}, {} ||
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
            THEN pieces1, checkers1 := pieces1 - {current_piece}, checkers1 - {current_piece} //promote_to_checker(current_piece, current_player) 
            END
        ELSIF current_player = P2 & current_piece : pieces2
        THEN pieces_positions2 := pieces_positions2 <+ { current_piece |-> (rr,cc)} || current_player := P1 ||
            IF rr = 1
            THEN pieces2, checkers2 := pieces2 - {current_piece}, checkers2 - {current_piece}//promote_to_checker(current_piece, current_player) 
            END
            
        END ||
        current_piece := -1
        
    END;
    
    oo <-- move_options(pc) =
    PRE pc : (0..11)
    THEN 
        current_piece := pc ||
        ANY xx, yy WHERE xx = pieces_positions1(pc) & yy = pieces_positions2(pc)
        THEN
            //PARA O P1
            IF current_player = P1 & pc /: checkers1 & pc : pieces1
            THEN
                ANY aoo 
                WHERE aoo : (0..3) --> (0..8) &
                    (
                        (prj2(NAT, NAT)(xx) = 1                                                     // É a primeira coluna
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions1)     // Se não tiver peça de P1
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions2)     // Se não tiver peça de P2
                            & aoo = {0|->0, 1|->0, 2|->(prj1(NAT, NAT)(xx) + 1), 3|->(prj2(NAT, NAT)(xx) + 1)}) or           // Atribuição I
                        (prj2(NAT, NAT)(xx) = 8                                                     // É a última coluna
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) - 1) /: ran(pieces_positions1)     // Se não tiver peça de P1  
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) - 1) /: ran(pieces_positions2)     // Se não tiver peça de P2
                            & aoo = {0|->(prj1(NAT, NAT)(xx) + 1), 1|->(prj2(NAT, NAT)(xx) - 1), 2|->0, 3|->0}) or          // Atribuição II
                        (prj2(NAT, NAT)(xx):(2..7)                                                  // É qualquer coluna do meio
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions1)     // A direita não tem peça de 1  
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx)- 1) /: ran(pieces_positions1)      // A esquerda não tem peça de 1
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions2)     // A direita não tem peça de 2
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx)- 1) /: ran(pieces_positions2)      // A esquerda não tem peça de 2
                            & aoo = {0|->(prj1(NAT, NAT)(xx) + 1), 1|->(prj2(NAT, NAT)(xx) - 1), 2|->(prj1(NAT, NAT)(xx) + 1), 3|->(prj2(NAT, NAT)(xx) + 1)})or // Atribuição III
                        (prj2(NAT, NAT)(xx):(2..7)                                                  // Só possui peça na esquerda
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions1)     // A direita não tem peça de 1
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions2)     // A direita não tem peça de 2
                            & ((prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx)- 1) : ran(pieces_positions1)      // A esquerda tem peça de 1 ou
                                or (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx)- 1) : ran(pieces_positions2)) // A esquerda tem peça de 2
                            & aoo = {0|->0, 1|->0, 2|->(prj1(NAT, NAT)(xx) + 1), 3|->(prj2(NAT, NAT)(xx) + 1)})or // Atribuição IV
                        (prj2(NAT, NAT)(xx):(2..7)                                                  // Só possui peça na direita
                            & ((prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) : ran(pieces_positions1)     // A direita tem peça de 1 ou 
                                or (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) : ran(pieces_positions2))// A direita tem peça de 2
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx)- 1) /: ran(pieces_positions1)      // A esquerda não tem peça de 1
                            & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx)- 1) /: ran(pieces_positions2)      // A esquerda não tem peça de 2
                            & aoo = {0|->(prj1(NAT, NAT)(xx) + 1), 1|->(prj2(NAT, NAT)(xx) - 1), 2|->0, 3|->0})or // Atribuição V
                        (not(
                                (prj2(NAT, NAT)(xx) = 1                                                       // É a primeira coluna
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions1)       // Se não tiver peça de P1
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions2)) or   // Se não tiver peça de P2
                                (prj2(NAT, NAT)(xx) = 8                                                       // É a última coluna
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) - 1) /: ran(pieces_positions1)       // Se não tiver peça de P1  
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) - 1) /: ran(pieces_positions2)) or   // Se não tiver peça de P2  
                                (prj2(NAT, NAT)(xx):(2..7)                                                    // É qualquer coluna do meio
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions1)       // A direita não tem peça de 1  
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) - 1) /: ran(pieces_positions1)       // A esquerda não tem peça de 1
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions2)       // A direita não tem peça de 2
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) - 1) /: ran(pieces_positions2)) or      // A esquerda não tem peça de 2
                                (prj2(NAT, NAT)(xx):(2..7)                                                    // Só possui peça na esquerda
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions1)       // A direita não tem peça de 1  
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) /: ran(pieces_positions2)       // A direita não tem peça de 2
                                    & ((prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) - 1) : ran(pieces_positions1)       // A esquerda tem peça de 1 ou
                                        or (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) - 1) : ran(pieces_positions2))) or  // A esquerda tem peça de 2
                                (prj2(NAT, NAT)(xx):(2..7)                                                    // Só possui peça na direita
                                    & ((prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) : ran(pieces_positions1)       // A direita tem peça de 1 ou
                                        or (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) + 1) : ran(pieces_positions2))  // A direita tem peça de 2
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) - 1) /: ran(pieces_positions1)        // A esquerda não tem peça de 1
                                    & (prj1(NAT, NAT)(xx) + 1, prj2(NAT, NAT)(xx) - 1) /: ran(pieces_positions2))       // A esquerda não tem peça de 2
                            )
                            & aoo = {0|->0, 1|->0, 2|->0, 3|->0}) // Não possui opções
                    )
                    
                THEN oo := aoo || current_array := aoo
                END
                //PARA O P2
            ELSIF current_player = P2 & pc /: checkers2 & pc : pieces2
            THEN
                ANY aoo 
                WHERE aoo : (0..3) --> (0..8) &
                    (
                        (prj2(NAT, NAT)(yy) = 1                                                          // É a primeira coluna
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions1)          // Se não tiver peça de P1
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions2)          // Se não tiver peça de P2
                            & aoo = {0|->0, 1|->0, 2|->(prj1(NAT, NAT)(yy) - 1), 3|->(prj2(NAT, NAT)(yy) + 1)}) or  // Atribuição I
                        (prj2(NAT, NAT)(yy) = 8                                                          // É a última coluna
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions1)          // Se não tiver peça de P1  
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions2)          // Se não tiver peça de P2
                            & aoo = {0|->(prj1(NAT, NAT)(yy) - 1), 1|->(prj2(NAT, NAT)(yy) - 1), 2|->0, 3|->0}) or   // Atribuição II
                        (prj2(NAT, NAT)(yy):(2..7)                                                       // É qualquer coluna do meio
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions1)          // A direita não tem peça de 1  
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions1)          // A esquerda não tem peça de 1
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions2)          // A direita não tem peça de 2
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions2)          // A esquerda não tem peça de 2
                            & aoo = {0|->(prj1(NAT, NAT)(yy) - 1), 1|->(prj2(NAT, NAT)(yy) - 1), 2|->(prj1(NAT, NAT)(yy) - 1), 3|->(prj2(NAT, NAT)(yy) + 1)}) or  // Atribuição III
                        (prj2(NAT, NAT)(yy):(2..7)                                                      // Só possui peça na esquerda
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions1)         // A direita não tem peça de 1  
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions2)         // A direita não tem peça de 2
                            & ((prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) : ran(pieces_positions1)         // A esquerda tem peça de 1 ou
                                or (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) : ran(pieces_positions2))    // A esquerda tem peça de 2
                            & aoo = {0|->0, 1|->0, 2|->(prj1(NAT, NAT)(yy) - 1), 3|->(prj2(NAT, NAT)(yy) + 1)}) or // Atribuição IV
                        (prj2(NAT, NAT)(yy):(2..7)                                                      // Só possui peça na direita
                            & ((prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) : ran(pieces_positions1)         // A direita tem peça de 1 ou  
                                or (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) : ran(pieces_positions2))    // A direita tem peça de 2
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions1)         // A esquerda não tem peça de 1
                            & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions2)         // A esquerda não tem peça de 2
                            & aoo = {0|->(prj1(NAT, NAT)(yy) - 1), 1|->(prj2(NAT, NAT)(yy) - 1), 2|->0, 3|->0}) or // Atribuição V
                        (not(
                                (prj2(NAT, NAT)(yy) = 1                                                       // É a primeira coluna
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions1)       // Se não tiver peça de P1
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions2)) or   // Se não tiver peça de P2
                                (prj2(NAT, NAT)(yy) = 8                                                       // É a última coluna
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions1)       // Se não tiver peça de P1  
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions2)) or   // Se não tiver peça de P2
                                (prj2(NAT, NAT)(yy):(2..7)                                                    // É qualquer coluna do meio
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions1)       // A direita não tem peça de 1  
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions1)       // A esquerda não tem peça de 1
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions2)       // A direita não tem peça de 2
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions2)) or   // A direita não tem peça de 1
                                (prj2(NAT, NAT)(xx):(2..7)                                                    // Só possui peça na esquerda
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions1)       // A direita não tem peça de 1  
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) /: ran(pieces_positions2)       // A direita não tem peça de 2
                                    & ((prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) : ran(pieces_positions1)       // A esquerda tem peça de 1 ou
                                        or (prj1(NAT, NAT)(yy) + 1, prj2(NAT, NAT)(yy) - 1) : ran(pieces_positions2))) or  // A esquerda tem peça de 2
                                (prj2(NAT, NAT)(yy):(2..7)                                                    // Só possui peça na direita
                                    & ((prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) : ran(pieces_positions1)       // A direita tem peça de 1 ou 
                                        or (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) + 1) : ran(pieces_positions2))  // A direita tem peça de 2
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions1)       // A esquerda não tem peça de 1
                                    & (prj1(NAT, NAT)(yy) - 1, prj2(NAT, NAT)(yy) - 1) /: ran(pieces_positions2))      // A esquerda não tem peça de 2
                            )     
                            &  aoo = {0|->0, 1|->0, 2|->0, 3|->0}) // Não possui opções
                    )
                    
                THEN oo := aoo || current_array := aoo 
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
            IF (prj1(NAT, NAT)(pieces_positions1(pc)) + 1, prj2(NAT, NAT)(pieces_positions1(pc)) - 1) = (prj1(NAT, NAT)(pieces_positions2(tg)), prj2(NAT, NAT)(pieces_positions2(tg)))
            THEN
                //se não houver peça a esqueda para cima de tg
                IF (prj1(NAT, NAT)(pieces_positions2(tg)) + 1, prj2(NAT, NAT)(pieces_positions2(tg)) - 1) /: (ran(pieces_positions2) \/ ran(pieces_positions1)) 
                THEN
                    //move
                    pieces_positions1 := pieces_positions1 <+ { pc |-> (prj1(NAT, NAT)(pieces_positions1(pc)) + 2 , prj2(NAT, NAT)(pieces_positions1(pc)) - 2)} || current_player := P2 ||
                    /*remove_piece(tg,P2)*/ pieces2 := pieces2 - {tg} || checkers2 := checkers2 - {tg} || 
                    pieces_positions2 := {tg} <<| pieces_positions2
                END
                // se tg estiver a direita
            ELSIF (prj1(NAT, NAT)(pieces_positions1(pc)) + 1, prj2(NAT, NAT)(pieces_positions1(pc)) + 1) = (prj1(NAT, NAT)(pieces_positions2(tg)), prj2(NAT, NAT)(pieces_positions2(tg)))
            THEN
                //se não houver peça a direita para cima de tg
                IF (prj1(NAT, NAT)(pieces_positions2(tg)) + 1, prj2(NAT, NAT)(pieces_positions2(tg)) + 1) /: (ran(pieces_positions2) \/ ran(pieces_positions1)) 
                THEN
                    //move
                    pieces_positions1 := pieces_positions1 <+ { pc |-> (prj1(NAT, NAT)(pieces_positions1(pc)) + 2 , prj2(NAT, NAT)(pieces_positions1(pc)) + 2)} || current_player := P2 ||
                    /*remove_piece(tg,P2)*/ pieces2 := pieces2 - {tg} || checkers2 := checkers2 - {tg} || 
                    pieces_positions2 := {tg} <<| pieces_positions2 //||
                END
            END
            //PARA O P2
        ELSIF current_player = P2 & pc : pieces2 & tg : pieces1
        THEN
            // se tg estiver a esquerda
            IF (prj1(NAT, NAT)(pieces_positions2(pc)) - 1, prj2(NAT, NAT)(pieces_positions2(pc)) - 1) = (prj1(NAT, NAT)(pieces_positions1(tg)), prj2(NAT, NAT)(pieces_positions1(tg)))
            THEN
                //se não houver peça a esuqeda para baixo de tg
                IF (prj1(NAT, NAT)(pieces_positions1(tg)) - 1, prj2(NAT, NAT)(pieces_positions1(tg)) - 1) /: (ran(pieces_positions2) \/ ran(pieces_positions1)) 
                THEN
                    //move
                    pieces_positions2 := pieces_positions2 <+ { pc |-> (prj1(NAT, NAT)(pieces_positions2(pc)) - 2 , prj2(NAT, NAT)(pieces_positions2(pc)) - 2)} || current_player := P1 ||
                    /* remove_piece(tg,P1) */ pieces1 := pieces1 - {tg} || checkers1 := checkers1 - {tg} || 
                    pieces_positions1 := {tg} <<| pieces_positions1 
                END
                // se tg estiver a direita
            ELSIF (prj1(NAT, NAT)(pieces_positions2(pc)) - 1, prj2(NAT, NAT)(pieces_positions2(pc)) + 1) = (prj1(NAT, NAT)(pieces_positions1(tg)), prj2(NAT, NAT)(pieces_positions1(tg)))
            THEN
                //se não houver peça a esuqeda para cima de tg
                IF (prj1(NAT, NAT)(pieces_positions1(tg)) - 1, prj2(NAT, NAT)(pieces_positions1(tg)) + 1) /: (ran(pieces_positions2) \/ ran(pieces_positions1)) 
                THEN
                    //move
                    pieces_positions2 := pieces_positions2 <+ { pc |-> (prj1(NAT, NAT)(pieces_positions2(pc)) - 2 , prj2(NAT, NAT)(pieces_positions2(pc)) + 2)} || current_player := P1 ||
                    /*remove_piece(tg,P1)*/ pieces1 := pieces1 - {tg} || checkers1 := checkers1 - {tg} || 
                    pieces_positions1 := {tg} <<| pieces_positions1
                END
            END   
        END
    END
END 