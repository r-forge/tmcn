#ifndef FUN_H
#define FUN_H
#include <vector>
#include <algorithm>
#include <math.h>
using namespace std;
#define MINUS_LOG_EPSILON  50


bool split_string(char *str, const char *cut, vector<char *> &strs);
char* catch_string(char *str, char *head, char* tail,char* catched);//catch the first substring catched between head and tail in str
char* catch_string(char *str, char* tail, char* catched);//catch the first substring before tail
void trim_line(char *line);//get rid of '\r\n'

template <class T> inline T _min(T x, T y) { return(x < y) ? x : y; }
template <class T> inline T _max(T x, T y) { return(x > y) ? x : y; }

inline double log_sum_exp(double x,double y)
{
    double vmin = _min(x, y);
    double vmax = _max(x, y);
    if (vmax > vmin + MINUS_LOG_EPSILON) {
      return vmax;
    } else {
      return vmax + log(exp(vmin - vmax) + 1.0);
    }
}




template <class T, class cmp_func>
bool vector_search(vector<T> &v, const T & s, int &index, int &insert_pos, cmp_func cmp)
{
	pair<typename vector< T >::const_iterator, typename vector< T >::const_iterator> ip;
	ip = equal_range( v.begin( ), v.end( ), s , cmp);
	index=ip.first-v.begin();
	insert_pos=ip.second-v.begin();
	if ( ip.first == ip.second )//not found
		return false;
	return true;
}



template <class T>
bool vector_search(vector<T> &v, const T & s, int &index, int &insert_pos)
{
	pair<typename vector< T >::const_iterator,typename vector< T >::const_iterator> ip;
	ip = equal_range( v.begin( ), v.end( ), s );
	index=ip.first-v.begin();
	insert_pos=ip.second-v.begin();
	if ( ip.first == ip.second )//not found
	{
		return false;
	}
	return true;
}

template <class T>
bool vector_insert(vector<T> &v, const T & s, int index)
{
	if(index>v.size())return false;
	typename vector<T>::iterator t=v.begin()+index;
	v.insert(t,s);
	return true;
}
#endif