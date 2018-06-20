#include "stdio.h"
#include "Game.h"
// #include "Game_i.c"


//extern bool Players__pieces1_i[12];
void print_table(){
	printf("\n \t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8 \n");
	printf("  |-------------|---------------|---------------|---------------|---------------|---------------|---------------|---------------|\n");
	for (int32_t r = 8; r >= 1; r--){
		printf("%i ", r);
		for (int32_t c = 1; c <= 8; c++){
			int32_t pc = 0;
			Players__PLAYERS pl;
			Game__get_piece(r, c, &pc, &pl);
			if(pc == -1)
				printf("|\t\t");
			else if(pl = Players__P1)
				printf("|\t%i\t", pc);
			else if(pl = Players__P2)
				printf("|\t%i\t", pc);
			else 
				printf("fail\n");
			// printf("%i", pc);
		}

		// printf("|---|---|---|---|---|---|---|---|\n");
		printf("|\n  |-------------|---------------|---------------|---------------|---------------|---------------|---------------|---------------|\n");
	}
}

int main(int argc, char const *argv[])
{
	Game__INITIALISATION();
	Players__INITIALISATION();
	printf("STARTING...!\n");

	Players__PLAYERS pl;

	print_table();

	while(1){
		Game__get_current_player(&pl);
		if (pl == Players__P1){
			printf("Current_player: P1\n");
		}
		else if (pl == Players__P2){
			printf("Current_player: P2\n");
		}		

		printf("SELECT YOUR ACTION\n1- MOVE, 2- EAT\n");
		int o;
		scanf("%i", &o);

		switch (o){
			case 1:
				printf("Chose a piece to move\n");

				int32_t pc;

				scanf("%i", &pc);

				int32_t options [4];

				Game__move_options(pc, options);

				while((options[0] == 0) & (options[1] == 0) & (options[2] == 0) & (options[3] == 0)){
					printf("\nYou can't move this piece.\n Enter another piece\n");
					scanf("%i", &pc);
					Game__move_options(pc, options);
				}
			
				printf("move options: 1:(%i,%i) or 2:(%i,%i)\n", options[0], options[1], options[2], options[3]);

				int32_t op;
				scanf("%i", &op);

				if (op == 1){
					Game__move(options[0], options[1]);
				}
				else if (op == 2)
				{
					Game__move(options[2], options[3]);
				}

				print_table();

				break;

			case 2:
				printf("Choose a pice to eat (FIRST YOUR PIECE AND THEN THE TARGET)\n");
				int32_t tg, ct;
				scanf("%i %i", &ct, &tg);

				Game__eat(ct, tg);

				print_table();
		}
	}
	return 0;
}