#include <fstream>
#include <iostream>
#include "fun.h"
#include "crf.h"
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

//build learn
int main_learn(int argc, char *argv[]){
const char* learn_help="\
format:\n\
crf_learn template_file_name train_file_name model_file_name\n\
option type   default   meaning\n\
-c     double 1         Gaussian prior/L1 regularizer.\n\
-f     int    0         Frequency threshold.\n\
-p     int    1         Thread number. \n\
-i     int    10000     Max iteration number.\n\
-e     double 0.0001    Controls training precision.\n\
-a     int    0         Algorithm:\n\
                          0: CRFs\n\
                          1: Averaged Perceptron\n\
                          2: Passive Aggressive\n\
						  3: L1 CRFs\n\
-d     int    5         LBFGS depth.\n\
-m     int    0         0: fast train crf\n\
                        1: slow but requires less memory.\n\
";
//initial learning parameters
	char train_file[100]="";
	char templet_file[100]="";
	char model_file[100]="";
	char sigma[100]="1";		//-c
	char freq_thresh[100]="0";	//-f
	char thread_num[100]="1";	//-p
	char max_iter[100]="10000";	//-i
	char eta[100]="0.0001";	//-e
	char algorithm[100]="0";//-a
	char depth[100]="5";//-d
	char prior[100]="0";//-m
	//get learning parameters, and check
	int i=1;
	int step=0;//0: next load templet_file, 1: next load train_file, 2: next_load model_file
	while(i<argc){
		if(!strcmp(argv[i],"-h")){
			cout<<learn_help<<endl;
			return 0;
		}else if(!strcmp(argv[i],"-c")){
			if(i+1==argc){
				cout<<"-c parameter empty"<<endl;
				return 1;
			}
			strcpy(sigma,argv[i+1]);
			if(atof(sigma)<=0){
				cout<<"invalid -c parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(!strcmp(argv[i],"-f")){
			if(i+1==argc){
				cout<<"-f parameter empty"<<endl;
				return 1;
			}
			strcpy(freq_thresh,argv[i+1]);
			if(atoi(freq_thresh)<0){
				cout<<"invalid -f parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(!strcmp(argv[i],"-p")){
			if(i+1==argc){
				cout<<"-p parameter empty"<<endl;
				return 1;
			}
			strcpy(thread_num,argv[i+1]);
			if(atoi(thread_num)<0){
				cout<<"invalid -p parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(!strcmp(argv[i],"-m")){
			if(i+1==argc){
				cout<<"-m parameter empty"<<endl;
				return 1;
			}
			strcpy(prior,argv[i+1]);
			if(atoi(prior)<0 || atoi(prior)>1){
				cout<<"invalid -m parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(!strcmp(argv[i],"-i")){
			if(i+1==argc){
				cout<<"-i parameter empty"<<endl;
				return 1;
			}
			strcpy(max_iter,argv[i+1]);
			if(atoi(max_iter)<0){
				cout<<"invalid -i parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(!strcmp(argv[i],"-e")){
			if(i+1==argc){
				cout<<"-e parameter empty"<<endl;
				return 1;
			}
			strcpy(eta,argv[i+1]);
			if(atof(eta)<0){
				cout<<"invalid -e parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(!strcmp(argv[i],"-a")){
			if(i+1==argc){
				cout<<"-a parameter empty"<<endl;
				return 1;
			}
			strcpy(algorithm,argv[i+1]);
			if(atoi(algorithm)<0||atoi(algorithm)>3){
				cout<<"invalid -a parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(!strcmp(argv[i],"-d")){
			if(i+1==argc){
				cout<<"-d parameter empty"<<endl;
				return 1;
			}
			strcpy(depth,argv[i+1]);
			if(atoi(depth)<=0){
				cout<<"invalid -d parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(argv[i][0]=='-'){
			cout<<argv[i]<<": invalid parameter"<<endl;
			return 1;
		}else if(step==0){
			strcpy(templet_file,argv[i]);
			i++;
			step++;
		}else if(step==1){
			strcpy(train_file,argv[i]);
			i++;
			step++;
		}else if(step==2){
			strcpy(model_file,argv[i]);
			i++;
			step++;
		}
	}
	//check necessary parameters
	if(!templet_file[0]){
		cout<<"no template file"<<endl;
		return 1;
	}
	if(!train_file[0]){
		cout<<"no train file"<<endl;
		return 1;
	}
	if(!model_file[0]){
		cout<<"no model file"<<endl;
		return 1;
	}
	CRF *c=new CRF();
	c->set_para("sigma",sigma);
	c->set_para("freq_thresh",freq_thresh);
	c->set_para("max_iter",max_iter);
	c->set_para("thread_num",thread_num);
	c->set_para("eta",eta);
	c->set_para("algorithm",algorithm);
	c->set_para("depth",depth);
	c->set_para("prior",prior);
	c->learn(templet_file,train_file,model_file);
	delete c;
	return 0;
}
int main_test(int argc, char *argv[]){
const char* test_help="\
format:\n\
crf_test model_file_name key_file_name result_file_name\n\
option type   default   meaning\n\
-m     int    0         Whether output margin probability.\n\
-p     int    0         Whether output label sequence probability.\n\
-n     int    1         Output n best results.\n\
";
//initial testing parameters
	char model_file[100]="";
	char key_file[100]="";
	char result_file[100]="";
	char margin[100]="0";		//-m
	char seqp[100]="0";		//-p
	char nbest[100]="1";		//-n
	int i=1;
	int step=0;//0: next load model_file, 1: next load key_file,2: result_file
	while(i<argc){
		if(!strcmp(argv[i],"-m")){
			if(i+1==argc){
				cout<<"-m parameter empty"<<endl;
				return 1;
			}
			strcpy(margin,argv[i+1]);
			if(atoi(margin)!=0 && atoi(margin)!=1){
				cout<<"invalid -m parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(!strcmp(argv[i],"-p")){
			if(i+1==argc){
				cout<<"-p parameter empty"<<endl;
				return 1;
			}
			strcpy(seqp,argv[i+1]);
			if(atoi(seqp)!=0 && atoi(seqp)!=1){
				cout<<"invalid -p parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(!strcmp(argv[i],"-n")){
			if(i+1==argc){
				cout<<"-n parameter empty"<<endl;
				return 1;
			}
			strcpy(nbest,argv[i+1]);
			if(atoi(nbest)<1){
				cout<<"invalid -n parameter"<<endl;
				return 1;
			}
			i+=2;
		}else if(!strcmp(argv[i],"-h")){
			cout<<test_help<<endl;
			return 0;
		}else if(argv[i][0]=='-'){
			cout<<argv[i]<<": invalid parameter"<<endl;
			return 1;
		}else if(step==0){
			strcpy(model_file,argv[i]);
			i++;
			step++;
		}else if(step==1){
			strcpy(key_file,argv[i]);
			i++;
			step++;
		}else if(step==2){
			strcpy(result_file,argv[i]);
			i++;
			step++;
		}
	}
	//check necessary parameters
	if(!model_file[0]){
		cout<<"no model file"<<endl;
		return 1;
	}
	if(!key_file[0]){
		cout<<"no key file"<<endl;
		return 1;
	}if(!result_file[0]){
		cout<<"no result file"<<endl;
		return 1;
	}
	CRF *c=new CRF();
	c->set_para("margin",margin);
	c->set_para("seqp",seqp);
	c->set_para("nbest",nbest);
	c->load_model(model_file);
	test(c,model_file,key_file,result_file,atoi(margin),atoi(seqp),atoi(nbest));
	delete c;
	return 0;
}
int main(int argc, char *argv[])
{
	return main_test(argc,argv);
}
