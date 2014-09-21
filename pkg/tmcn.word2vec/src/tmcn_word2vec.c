#include "R.h"
#include "Rmath.h"
#include "word2vec.h"

void tmcn_word2vec(char *train_file0, char *output_file0, char *binary0)
{
	int i;
	binary = atoi(binary0);
	strcpy(train_file, train_file0);
	strcpy(output_file, output_file0);
	vocab = (struct vocab_word *)calloc(vocab_max_size, sizeof(struct vocab_word));
	vocab_hash = (int *)calloc(vocab_hash_size, sizeof(int));
	expTable = (real *)malloc((EXP_TABLE_SIZE + 1) * sizeof(real));
	for (i = 0; i < EXP_TABLE_SIZE; i++) {
    	expTable[i] = exp((i / (real)EXP_TABLE_SIZE * 2 - 1) * MAX_EXP); // Precompute the exp() table
		expTable[i] = expTable[i] / (expTable[i] + 1);                   // Precompute f(x) = x / (x + 1)
	}
	TrainModel();
}


void CWrapper_word2vec(char **train_file, char **output_file, char **binary)
{
    tmcn_word2vec(*train_file, *output_file, *binary);
}

