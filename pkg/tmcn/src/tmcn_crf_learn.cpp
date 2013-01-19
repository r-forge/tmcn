#include <fstream>
#include <iostream>
#include "crf.h"
#include "R.h"
#include "Rmath.h"


void tmcn_crf_learn(char *templet_file, char *training_file, char *model_file,
		char *sigma, char *freq_thresh, char *thread_num, char *max_iter, 
		char *eta, char *algorithm, char *depth, char *prior)
{
	CRF *c=new CRF();
	c->set_para("sigma", sigma);
	c->set_para("freq_thresh", freq_thresh);
	c->set_para("thread_num", thread_num);
	c->set_para("max_iter", max_iter);
	c->set_para("eta", eta);
	c->set_para("algorithm", algorithm);
	c->set_para("depth", depth);
	c->set_para("prior", "0");
	c->learn(templet_file, training_file, model_file);
	delete c;
}

extern "C" {
    void CWrapper_crf_learn(char **templet_file, char **training_file, char **model_file,
    		char **sigma, char **freq_thresh, char **thread_num, char **max_iter, 
			char **eta, char **algorithm, char **depth, char **prior)
    {
    	char* p1 = *templet_file;
    	char* p2 = *training_file;
    	char* p3 = *model_file;
    	
        tmcn_crf_learn(*templet_file, *training_file, *model_file,
    		*sigma, *freq_thresh, *thread_num, *max_iter, 
			*eta, *algorithm, *depth, *prior);
    }
}

