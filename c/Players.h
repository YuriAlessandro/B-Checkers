#ifndef _Players_h
#define _Players_h

#include <stdint.h>
#include <stdbool.h>
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */
typedef enum
{
    Players__P1,
    Players__P2
    
} Players__PLAYERS;
#define Players__PLAYERS__max 2
typedef enum
{
    Players__yes,
    Players__no
    
} Players__ANSWER;
#define Players__ANSWER__max 2

/* Clause CONCRETE_VARIABLES */


/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
/* Array and record constants */
extern void Players__INITIALISATION(void);

/* Clause OPERATIONS */

extern void Players__remove_piece(int32_t pc, Players__PLAYERS pl);
extern void Players__remove_checker(int32_t pc, Players__PLAYERS pl);
extern void Players__promote_to_checker(int32_t pc, Players__PLAYERS pl);
extern void Players__is_checker(int32_t pc, Players__PLAYERS pl, Players__ANSWER *aa);
extern void Players__get_winner(Players__PLAYERS *ww);

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _Players_h */
