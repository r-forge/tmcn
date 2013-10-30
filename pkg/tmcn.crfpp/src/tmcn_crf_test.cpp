#include <fstream>
#include <iostream>
#include "fun.h"
#include "crf.h"
#include "R.h"
#include "Rmath.h"


using namespace std;
void test(CRF *c, char *model_file, char *key_file, char *result_file, int margin, int seqp, int nbest){
	vector < vector < string > > table;
	int total=0;
	int error=0;
	ifstream fin;
	fin.open(key_file);
	if(!fin.is_open()){
		cout<<"can not open key_file: "<<key_file<<endl;
		return;
	}
	ofstream fout;
	fout.open(result_file);
	char line[100000];
	int i,j,k;
	while(!fin.eof()){
		fin.getline(line,99999);
		if(line[0]){
			vector < string > row;
			char *p=line,*q;
			while(q=strstr(p,"\t"))
			{
				*q=0;
				row.push_back(p);
				p=q+1;
			}
			row.push_back(p);
			table.push_back(row);
		}else if(table.size()){
L0:
			//convert to ext_table, val_table
			vector<vector<vector<string> > > ext_table(table.size());//split each unit by " "
			vector<vector<vector<double> > > val_table(table.size());
			for(i=0;i<table.size();i++){
				ext_table[i].resize(table[i].size());
				if(c->is_real)
					val_table[i].resize(table[i].size());

				for(j=0;j<table[i].size();j++){
					char unit[100000];
					strcpy(unit,table[i][j].c_str());
					vector<char *> units;
					vector<double> uvals;//unit values
					split_string(unit," ",units);
					for(k=0;k<units.size();)
					{
						if(!units[k][0])
							units.erase(units.begin()+k);
						else
						{
							if(c->is_real)
							{
								if(j+1<table[i].size())
								{
									char *q=strrchr(units[k],':');
									if(q==units[k])//	:0.5
									{
										units.erase(units.begin()+k);
										continue;
									}
									*q=0;
									q++;
									uvals.push_back(atof(q));
								}else{
									uvals.push_back(0);
								}
							}
							k++;
						}
					}
					ext_table[i][j].resize(units.size());
					if(c->is_real)
					{
						val_table[i][j].resize(units.size());
						val_table[i][j]=uvals;
					}
					for(k=0;k<units.size();k++)
						ext_table[i][j][k]=units[k];
					
				}
			}
			vector < vector < string > > y;
			vector < double > sequencep;
			vector < vector < double > > nodep;
			c->tag(ext_table,val_table,y,sequencep,nodep);
			if(seqp){
				for(i=0;i < sequencep.size()-1 ; i++)
					fout<<sequencep[i]<<"\t";
				fout<<sequencep[i]<<endl;
			}
			int table_rows=y[0].size();
			int table_cols=table[0].size();
			total+=table_rows;
			for(i=0;i < table_rows ; i++)
			{
				if(table[i].back()!=y[0][i])
					error++;
				for(j=0;j < table_cols;j++)
					fout<<table[i][j].c_str()<<"\t";
				for(j=0;j < y.size()-1;j++)
					fout<<y[j][i].c_str()<<"\t";
				fout<<y[j][i].c_str();
				if(margin){
					fout<<"\t";
					for(j=0;j < nodep[0].size()-1; j++)
						fout<<nodep[i][j]<<"\t";
					fout<<nodep[i][j];
				}
				fout<<endl;
			}
			table.clear();
			fout<<endl;
		}
	}
	if(table.size())
		goto L0;
	fin.close();
	fout.close();
	cout<<"label precision:"<<(1-(double)error/total)<<endl;
}

void tmcn_crf_test(char *model_file, char *key_file, char *result_file, 
		char *margin, char *seqp, char *nbest)
{
	CRF *c=new CRF();
	c->set_para("margin",margin);
	c->set_para("seqp",seqp);
	c->set_para("nbest",nbest);
	c->load_model(model_file);
	test(c,model_file,key_file,result_file,atoi(margin),atoi(seqp),atoi(nbest));
	delete c;
}

extern "C" {
    void CWrapper_crf_test(char **model_file, char **key_file, char **result_file,
    		char **margin, char **seqp, char **nbest)
    {

        tmcn_crf_test(*model_file, *key_file, *result_file,
    		*margin, *seqp, *nbest);
    }
}

