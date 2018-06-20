/* WARNING if type checker is not performed, translation could contain errors ! */

#include "Players.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

/* Array and record constants */
/* Clause CONCRETE_VARIABLES */

static bool Players__pieces1_i[12];
static bool Players__pieces2_i[12];
static bool Players__checkers1_i[12];
static bool Players__checkers2_i[12];
/* Clause INITIALISATION */
void Players__INITIALISATION(void)
{
    
    {
        int32_t ii;
        
        ii = 0;
        while(((ii) <= (11)))
        {
            Players__pieces1_i[ii] = true;
            Players__pieces2_i[ii] = true;
            Players__checkers1_i[ii] = false;
            Players__checkers2_i[ii] = false;
            ii = ii+1;
        }
    }
}

/* Clause OPERATIONS */

void Players__remove_piece(int32_t pc, Players__PLAYERS pl)
{
    {
        bool ck1;
        bool ck2;
        
        ck1 = Players__checkers1_i[pc];
        ck2 = Players__checkers2_i[pc];
        if((((((pc) >= (0)) &&
                    ((pc) <= (11))) &&
                (ck1 == false)) &&
            (ck2 == false)) &&
        (((pl == Players__P1) ||
                (pl == Players__P2))))
        {
            if(pl == Players__P1)
            {
                Players__pieces1_i[pc] = false;
            }
            else
            {
                Players__pieces2_i[pc] = false;
            }
        }
    }
}

void Players__remove_checker(int32_t pc, Players__PLAYERS pl)
{
    {
        bool ck1;
        bool ck2;
        
        ck1 = Players__checkers1_i[pc];
        ck2 = Players__checkers2_i[pc];
        if((((((pc) >= (0)) &&
                    ((pc) <= (11))) &&
                (ck1 == true)) ||
            (ck2 == true)) &&
        (((pl == Players__P1) ||
                (pl == Players__P2))))
        {
            if((pl == Players__P1) &&
            (ck1 == true))
            {
                Players__pieces1_i[pc] = false;
                Players__checkers1_i[pc] = false;
            }
            else
            {
                if(pl == Players__P2)
                {
                    Players__pieces2_i[pc] = false;
                    Players__checkers2_i[pc] = false;
                }
            }
        }
    }
}

void Players__promote_to_checker(int32_t pc, Players__PLAYERS pl)
{
    if((((pc) >= (0)) &&
        ((pc) <= (11))) &&
    (((pl == Players__P1) ||
            (pl == Players__P2))))
    {
        {
            bool pc1;
            bool pc2;
            bool ck1;
            bool ck2;
            
            pc1 = Players__pieces1_i[pc];
            ck1 = Players__checkers1_i[pc];
            pc2 = Players__pieces2_i[pc];
            ck2 = Players__checkers2_i[pc];
            if(((pl == Players__P1) &&
                (pc1 == true)) &&
            (ck1 == false))
            {
                Players__checkers1_i[pc] = true;
            }
            else
            {
                if(((pl == Players__P2) &&
                    (pc2 == true)) &&
                (ck2 == false))
                {
                    Players__checkers2_i[pc] = true;
                }
            }
        }
    }
}

void Players__is_checker(int32_t pc, Players__PLAYERS pl, Players__ANSWER *aa)
{
    if((((pc) >= (0)) &&
        ((pc) <= (11))) &&
    (((pl == Players__P1) ||
            (pl == Players__P2))))
    {
        {
            bool pc1;
            bool pc2;
            bool ck1;
            bool ck2;
            
            pc1 = Players__pieces1_i[pc];
            pc2 = Players__pieces2_i[pc];
            ck1 = Players__checkers1_i[pc];
            ck2 = Players__checkers2_i[pc];
            if(((((pl == Players__P1) &&
                        (pc1 == true)) &&
                    (ck1 == true))) ||
            ((((pl == Players__P2) &&
                        (pc2 == true)) &&
                    (ck2 == true))))
            {
                (*aa) = Players__yes;
            }
            else
            {
                (*aa) = Players__no;
            }
        }
    }
}

void Players__get_winner(Players__PLAYERS *ww)
{
    {
        int32_t ii;
        bool aa;
        int32_t jj;
        bool bb;
        
        aa = false;
        bb = false;
        ii = 0;
        jj = 0;
        while((((ii) < (12)) &&
            (aa == false)))
        {
            {
                bool tt;
                
                tt = Players__pieces1_i[ii];
                if(tt == true)
                {
                    aa = true;
                }
            }
            ii = ii+1;
        }
        if(aa == false)
        {
            (*ww) = Players__P2;
        }
        else
        {
            while((((jj) < (12)) &&
                (bb == false)))
            {
                {
                    bool rr;
                    
                    rr = Players__pieces2_i[jj];
                    if(rr == true)
                    {
                        bb = true;
                    }
                }
                jj = jj+1;
            }
            if(bb == false)
            {
                (*ww) = Players__P1;
            }
        }
    }
}

