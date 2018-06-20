#ifndef _Game_h
#define _Game_h

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
/* Clause IMPORTS */
#include "Players.h"

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */
typedef enum
{
    Game__P1,
    Game__P2
    
} Game__PLAYERS;
#define Game__PLAYERS__max 2
typedef enum
{
    Game__yes,
    Game__no
    
} Game__ANSWER;
#define Game__ANSWER__max 2

/* Clause CONCRETE_VARIABLES */


/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
/* Array and record constants */
extern void Game__INITIALISATION(void);

/* Clause OPERATIONS */

extern void Game__get_current_player(Players__PLAYERS *cp);
extern void Game__get_current_array(int32_t *ca);
extern void Game__get_piece(int32_t rr, int32_t cc, int32_t *pc, Players__PLAYERS *pl);
extern void Game__move(int32_t rr, int32_t cc);
extern void Game__move_options(int32_t pc, int32_t *oo);
extern void Game__eat(int32_t pc, int32_t tg);

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _Game_h */
