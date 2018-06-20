/* WARNING if type checker is not performed, translation could contain errors ! */

#include "Game.h"

/* Clause IMPORTS */
#include "Players.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

/* Array and record constants */
/* Clause CONCRETE_VARIABLES */

static int32_t Game__row1[12];
static int32_t Game__column1[12];
static int32_t Game__row2[12];
static int32_t Game__column2[12];
static int32_t Game__current_piece;
static int32_t Game__current_array[4];
static Players__PLAYERS Game__current_player;
/* Clause LOCAL_OPERATIONS */

static void Game__have_a_piece(int32_t rr, int32_t cc, Players__ANSWER *ww);
static void Game__make_a_move(int32_t rr, int32_t cc);
/* Clause INITIALISATION */
void Game__INITIALISATION(void)
{
    
    unsigned int i = 0;
    Players__INITIALISATION();
    Game__current_player = Players__P1;
    for(i = 0; i <= 3;i++)
    {
        Game__current_array[i] = 0;
    }
    Game__current_piece = -1;
    {
        int32_t pc;
        int32_t rr;
        int32_t cc;
        int32_t rrm;
        int32_t ccm;
        
        pc = 0;
        rr = 1;
        cc = 1;
        rrm = -1;
        ccm = -1;
        while(((rr) <= (3)) &&
        ((pc) < (12)))
        {
            cc = 1;
            while(((cc) <= (8)) &&
            ((pc) < (12)))
            {
                rrm = rr % 2;
                ccm = cc % 2;
                if((((rrm == 0) &&
                        (ccm == 0))) ||
                (((rrm == 1) &&
                        (ccm == 1))))
                {
                    Game__row1[pc] = rr;
                    Game__column1[pc] = cc;
                    pc = pc+1;
                }
                cc = cc+1;
            }
            rr = rr+1;
        }
        pc = 0;
        rr = 8;
        cc = 1;
        while(((rr) >= (6)) &&
        ((pc) < (12)))
        {
            cc = 1;
            while(((cc) <= (8)) &&
            ((pc) < (12)))
            {
                rrm = rr % 2;
                ccm = cc % 2;
                if((((rrm == 0) &&
                        (ccm == 0))) ||
                (((rrm == 1) &&
                        (ccm == 1))))
                {
                    Game__row2[pc] = rr;
                    Game__column2[pc] = cc;
                    pc = pc+1;
                }
                cc = cc+1;
            }
            rr = rr-1;
        }
    }
}

/* Clause OPERATIONS */

void Game__get_piece(int32_t rr, int32_t cc, int32_t *pc, Players__PLAYERS *pl)
{
    {
        int32_t aw;
        Players__PLAYERS pw;
        
        aw = -1;
        pw = Players__P1;
        if(((((rr) >= (1)) &&
                ((rr) <= (8))) &&
            ((cc) >= (1))) &&
        ((cc) <= (8)))
        {
            {
                int32_t ii;
                int32_t rr1;
                int32_t cc1;
                int32_t rr2;
                int32_t cc2;
                
                ii = 0;
                rr1 = Game__row1[ii];
                cc1 = Game__column1[ii];
                rr2 = Game__row2[ii];
                cc2 = Game__column2[ii];
                aw = -1;
                while(((ii) < (12)) &&
                (aw == -1))
                {
                    if(((rr1 == rr) &&
                        (cc1 == cc)))
                    {
                        aw = ii;
                        pw = Players__P1;
                    }
                    else if(((rr2 == rr) &&
                        (cc2 == cc)))
                    {
                        aw = ii;
                        pw = Players__P2;
                    }
                    ii = ii+1;
                    rr1 = Game__row1[ii];
                    cc1 = Game__column1[ii];
                    rr2 = Game__row2[ii];
                    cc2 = Game__column2[ii];
                }
            }
        }
        (*pc) = aw;
        (*pl) = pw;
    }
}

void Game__have_a_piece(int32_t rr, int32_t cc, Players__ANSWER *ww)
{
    {
        Players__ANSWER aw;
        
        aw = Players__no;
        if(((((rr) >= (1)) &&
                ((rr) <= (8))) &&
            ((cc) >= (1))) &&
        ((cc) <= (8)))
        {
            {
                int32_t ii;
                int32_t rr1;
                int32_t cc1;
                int32_t rr2;
                int32_t cc2;
                
                ii = 0;
                rr1 = Game__row1[ii];
                cc1 = Game__column1[ii];
                rr2 = Game__row2[ii];
                cc2 = Game__column2[ii];
                while(((ii) < (12)) &&
                (aw == Players__no))
                {
                    if((((rr1 == rr) &&
                            (cc1 == cc))) ||
                    (((rr2 == rr) &&
                            (cc2 == cc))))
                    {
                        aw = Players__yes;
                    }
                    ii = ii+1;
                    rr1 = Game__row1[ii];
                    cc1 = Game__column1[ii];
                    rr2 = Game__row2[ii];
                    cc2 = Game__column2[ii];
                }
            }
        }
        (*ww) = aw;
    }
}

void Game__make_a_move(int32_t rr, int32_t cc)
{
    unsigned int i = 0;
    {
        if(((((rr) >= (1)) &&
                ((rr) <= (8))) &&
            ((cc) >= (1))) &&
        ((cc) <= (8)))
        {
            for(i = 0; i <= 3;i++)
            {
                Game__current_array[i] = 0;
            }
            if(((Game__current_player == Players__P1) &&
                ((Game__current_piece) >= (0))) &&
            ((Game__current_piece) <= (11)))
            {
                Game__row1[Game__current_piece] = rr;
                Game__column1[Game__current_piece] = cc;
                Game__current_player = Players__P2;
                if(rr == 8)
                {
                    Players__promote_to_checker(Game__current_piece, Game__current_player);
                }
            }
            else
            {
                if(((Game__current_player == Players__P2) &&
                    ((Game__current_piece) >= (0))) &&
                ((Game__current_piece) <= (11)))
                {
                    Game__row2[Game__current_piece] = rr;
                    Game__column2[Game__current_piece] = cc;
                    Game__current_player = Players__P1;
                    if(rr == 1)
                    {
                        Players__promote_to_checker(Game__current_piece, Game__current_player);
                    }
                }
            }
            Game__current_piece = -1;
        }
    }
}

void Game__get_current_player(Players__PLAYERS *cp)
{
    (*cp) = Game__current_player;
}

void Game__get_current_array(int32_t *ca)
{
    memmove(ca,Game__current_array,4 * sizeof(int32_t));
}

void Game__move(int32_t rr, int32_t cc)
{
    unsigned int i = 0;
    {
        if(((((rr) >= (1)) &&
                ((rr) <= (8))) &&
            ((cc) >= (1))) &&
        ((cc) <= (8)))
        {
            for(i = 0; i <= 3;i++)
            {
                Game__current_array[i] = 0;
            }
            if(((Game__current_player == Players__P1) &&
                ((Game__current_piece) >= (0))) &&
            ((Game__current_piece) <= (11)))
            {
                Game__row1[Game__current_piece] = rr;
                Game__column1[Game__current_piece] = cc;
                Game__current_player = Players__P2;
                if(rr == 8)
                {
                    Players__promote_to_checker(Game__current_piece, Game__current_player);
                }
            }
            else
            {
                if(((Game__current_player == Players__P2) &&
                    ((Game__current_piece) >= (0))) &&
                ((Game__current_piece) <= (11)))
                {
                    Game__row2[Game__current_piece] = rr;
                    Game__column2[Game__current_piece] = cc;
                    Game__current_player = Players__P1;
                    if(rr == 1)
                    {
                        Players__promote_to_checker(Game__current_piece, Game__current_player);
                    }
                }
            }
            Game__current_piece = -1;
        }
    }
}

void Game__move_options(int32_t pc, int32_t *oo)
{
    unsigned int i = 0;
    {
        {
            int32_t aoo[4];
            
            for(i = 0; i <= 3;i++)
            {
                aoo[i] = 0;
            }
            if(((pc) >= (0)) &&
            ((pc) <= (11)))
            {
                Game__current_piece = pc;
                {
                    int32_t rr1;
                    int32_t cc1;
                    int32_t rr2;
                    int32_t cc2;
                    Players__ANSWER pcul1;
                    Players__ANSWER pcur1;
                    Players__ANSWER pcul2;
                    Players__ANSWER pcur2;
                    Players__ANSWER pcdl1;
                    Players__ANSWER pcdr1;
                    Players__ANSWER pcdl2;
                    Players__ANSWER pcdr2;
                    
                    rr1 = Game__row1[pc];
                    cc1 = Game__column1[pc];
                    rr2 = Game__row2[pc];
                    cc2 = Game__column2[pc];
                    Game__have_a_piece(rr1+1, cc1-1, &pcul1);
                    Game__have_a_piece(rr1+1, cc1+1, &pcur1);
                    Game__have_a_piece(rr2+1, cc2-1, &pcul2);
                    Game__have_a_piece(rr2+1, cc2+1, &pcur2);
                    Game__have_a_piece(rr1-1, cc1+1, &pcdl1);
                    Game__have_a_piece(rr1-1, cc1-1, &pcdr1);
                    Game__have_a_piece(rr2-1, cc2+1, &pcdl2);
                    Game__have_a_piece(rr2-1, cc2-1, &pcdr2);
                    if(((Game__current_player == Players__P1) &&
                        ((rr1) != (0))) &&
                    ((cc1) != (0)))
                    {
                        if((cc1 == 1) &&
                        (pcur1 == Players__no))
                        {
                            aoo[0] = 0;
                            aoo[1] = 0;
                            aoo[2] = (rr1+1);
                            aoo[3] = (cc1+1);
                        }
                        else if((cc1 == 8) &&
                        (pcul1 == Players__no))
                        {
                            aoo[0] = (rr1+1);
                            aoo[1] = (cc1-1);
                            aoo[2] = 0;
                            aoo[3] = 0;
                        }
                        else if(((((cc1) >= (2)) &&
                                ((cc1) <= (7))) &&
                            (pcur1 == Players__no)) &&
                        (pcul1 == Players__no))
                        {
                            aoo[0] = (rr1+1);
                            aoo[1] = (cc1-1);
                            aoo[2] = (rr1+1);
                            aoo[3] = (cc1+1);
                        }
                        else if(((((cc1) >= (2)) &&
                                ((cc1) <= (7))) &&
                            (pcur1 == Players__no)) &&
                        (pcul1 == Players__yes))
                        {
                            aoo[0] = 0;
                            aoo[1] = 0;
                            aoo[2] = (rr1+1);
                            aoo[3] = (cc1+1);
                        }
                        else if(((((cc1) >= (2)) &&
                                ((cc1) <= (7))) &&
                            (pcur1 == Players__yes)) &&
                        (pcul1 == Players__no))
                        {
                            aoo[0] = (rr1+1);
                            aoo[1] = (cc1-1);
                            aoo[2] = 0;
                            aoo[3] = 0;
                        }
                        else
                        {
                            aoo[0] = 0;
                            aoo[1] = 0;
                            aoo[2] = 0;
                            aoo[3] = 0;
                        }
                    }
                    else if(((Game__current_player == Players__P2) &&
                        ((rr1) != (0))) &&
                    ((cc1) != (0)))
                    {
                        if((cc2 == 1) &&
                        (pcdr2 == Players__no))
                        {
                            aoo[0] = 0;
                            aoo[1] = 0;
                            aoo[2] = (rr2-1);
                            aoo[3] = (cc2+1);
                        }
                        else if((cc2 == 8) &&
                        (pcdl2 == Players__no))
                        {
                            aoo[0] = (rr2-1);
                            aoo[1] = (cc2-1);
                            aoo[2] = 0;
                            aoo[3] = 0;
                        }
                        else if(((((cc2) >= (2)) &&
                                ((cc1) <= (7))) &&
                            (pcdr2 == Players__no)) &&
                        (pcdl2 == Players__no))
                        {
                            aoo[0] = (rr2-1);
                            aoo[1] = (cc2-1);
                            aoo[2] = (rr2-1);
                            aoo[3] = (cc2+1);
                        }
                        else if(((((cc2) >= (2)) &&
                                ((cc2) <= (7))) &&
                            (pcdr2 == Players__no)) &&
                        (((pcdl1 == Players__yes) ||
                                (pcdl2 == Players__no))))
                        {
                            aoo[0] = 0;
                            aoo[1] = 0;
                            aoo[2] = (rr2-1);
                            aoo[3] = (cc2+1);
                        }
                        else if(((((cc2) >= (2)) &&
                                ((cc2) <= (7))) &&
                            (pcdr2 == Players__yes)) &&
                        (pcdl2 == Players__no))
                        {
                            aoo[0] = (rr2-1);
                            aoo[1] = (cc2-1);
                            aoo[2] = 0;
                            aoo[3] = 0;
                        }
                        else
                        {
                            aoo[0] = 0;
                            aoo[1] = 0;
                            aoo[2] = 0;
                            aoo[3] = 0;
                        }
                    }
                    memmove(Game__current_array,aoo,4 * sizeof(int32_t));
                }
            }
            memmove(oo,aoo,4 * sizeof(int32_t));
        }
    }
}

void Game__eat(int32_t pc, int32_t tg)
{
    Game__current_piece = pc;
    {
        int32_t rr1;
        int32_t cc1;
        int32_t rr2;
        int32_t cc2;
        int32_t trr1;
        int32_t tcc1;
        int32_t trr2;
        int32_t tcc2;
        Players__ANSWER tgul2;
        Players__ANSWER tgur2;
        Players__ANSWER tgdl1;
        Players__ANSWER tgdr1;
        Players__ANSWER tgul1;
        Players__ANSWER tgur1;
        Players__ANSWER tgdl2;
        Players__ANSWER tgdr2;
        int32_t r1u;
        int32_t c1l;
        int32_t c1r;
        int32_t r2d;
        int32_t c2l;
        int32_t c2r;
        
        rr1 = Game__row1[pc];
        cc1 = Game__column1[pc];
        rr2 = Game__row2[pc];
        cc2 = Game__column2[pc];
        trr1 = Game__row1[tg];
        tcc1 = Game__column1[tg];
        trr2 = Game__row2[tg];
        tcc2 = Game__column2[tg];
        Game__have_a_piece(trr2+1, tcc2-1, &tgul2);
        Game__have_a_piece(trr2+1, tcc2+1, &tgur2);
        Game__have_a_piece(trr1+1, tcc1-1, &tgul1);
        Game__have_a_piece(trr1+1, tcc1+1, &tgur1);
        Game__have_a_piece(trr1-1, tcc1+1, &tgdl2);
        Game__have_a_piece(trr1-1, tcc1-1, &tgdr2);
        Game__have_a_piece(trr1-1, tcc1+1, &tgdl1);
        Game__have_a_piece(trr1-1, tcc1-1, &tgdr1);
        r1u = rr1+1;
        c1l = cc1-1;
        c1r = cc1+1;
        r2d = rr2-1;
        c2l = cc2-1;
        c2r = cc2+1;
        if((((((pc) >= (0)) &&
                    ((pc) <= (11))) &&
                ((tg) >= (0))) &&
            ((tg) <= (11))) &&
        ((((((((rr1) != (0)) &&
                                ((cc1) != (0))) &&
                            ((trr2) != (0))) &&
                        ((tcc2) != (0)))) ||
                ((((((rr2) != (0)) &&
                                ((cc2) != (0))) &&
                            ((trr1) != (0))) &&
                        ((tcc1) != (0)))))))
        {
            if(((((Game__current_player == Players__P1) &&
                        ((rr1) != (0))) &&
                    ((cc1) != (0))) &&
                ((trr2) != (0))) &&
            ((tcc2) != (0)))
            {
                if((r1u == trr2) &&
                (c1l == tcc2))
                {
                    if((tgul1 == Players__no) &&
                    (tgul2 == Players__no))
                    {
                        Game__make_a_move(trr2+1, tcc2-1);
                        Players__remove_piece(tg, Players__P2);
                        Game__row2[tg] = 0;
                        Game__column2[tg] = 0;
                    }
                }
                else if((r1u == trr2) &&
                (c1r == tcc2))
                {
                    if((tgur1 == Players__no) &&
                    (tgur2 == Players__no))
                    {
                        Game__make_a_move(trr2+1, tcc2+1);
                        Players__remove_piece(tg, Players__P2);
                        Game__row2[tg] = 0;
                        Game__column2[tg] = 0;
                    }
                }
            }
            else if(((((Game__current_player == Players__P2) &&
                        ((rr2) != (0))) &&
                    ((cc2) != (0))) &&
                ((trr1) != (0))) &&
            ((tcc1) != (0)))
            {
                if((r2d == trr2) &&
                (c2l == tcc2))
                {
                    if((tgdl1 == Players__no) &&
                    (tgdl2 == Players__no))
                    {
                        Game__make_a_move(trr2-1, tcc2-1);
                        Players__remove_piece(tg, Players__P2);
                        Game__row2[tg] = 0;
                        Game__column2[tg] = 0;
                    }
                }
                else if((r2d == trr2) &&
                (c2r == tcc2))
                {
                    if((tgdr1 == Players__no) &&
                    (tgdr2 == Players__no))
                    {
                        Game__make_a_move(trr2+1, tcc2-1);
                        Players__remove_piece(tg, Players__P2);
                        Game__row2[tg] = 0;
                        Game__column2[tg] = 0;
                    }
                }
            }
        }
    }
}

