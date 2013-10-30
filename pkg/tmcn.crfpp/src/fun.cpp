#include "fun.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

void trim_line(char *line)//get rid of '\r\n'
{
	size_t len=strlen(line);
	if(len && line[len-1]=='\n')
		line[len-1]=0;
	else
		return;
	len--;
	if(len && line[len-1]=='\r')
		line[len-1]=0;
}
bool split_string(char *str, const char *cut, vector<char *> &strs)
{
	char *p=str,*q;
	bool ret=false;
	while (q=strstr(p,cut))
	{
		*q=0;
		strs.push_back(p);
		p=q+strlen(cut);
		ret=true;
	}
	if(p) strs.push_back(p);
	return ret;
}



char* catch_string(char *str, char *head, char* tail, char* catched)
{
	char *p=str;
	char *q;
	q=strstr(str,head);
	if(!q)		return NULL;
	p=q+strlen(head);
	q=strstr(p,tail);
	if(!q)		return NULL;
	strncpy(catched,p,q-p);
	catched[q-p]=0;
	return q+strlen(tail);
}



char* catch_string(char *str, char* tail, char* catched)
// catch_string("12345","3",catched) => catched="12", return "45"
{
	char *q;
	q=strstr(str,tail);
	if(!q)
	{
		strcpy(catched,str);
		return NULL;
	}
	strncpy(catched,str,q-str);
	catched[q-str]=0;
	return q+strlen(tail);
}
