#include<bits/stdc++.h>

using namespace std;

void obj_to_txt(string obj_name, string txt_name){
	ifstream obj_file;
  
	obj_file.open(obj_name,ios::in);
	
	int num_verts=0, num_faces=0, format=0, rep=0;
	string line;
	
	while(getline(obj_file,line)){
		if(line[0]=='v' && line[1]==' ')
			num_verts++;
		else if (line[0]=='f' && line[1]==' '){
			num_faces++;
			for(auto a:line)
				if(a=='/')
					rep++;
		}
	}
	
	if(rep == 3*num_faces)
		format=1;
	else if(rep == 6*num_faces)
		format=2;
	
			
	obj_file.close();
	
	ofstream txt_file;
	
	obj_file.open(obj_name,ios::in);				
	txt_file.open (txt_name,ios::out);
	
	txt_file<<num_verts<<" "<<num_faces<<endl;
	
	vector<string> vertex;
	vector<string> faces;
	vector< tuple<int,int,int> > vec;
	
	int cnt=0;
	
	string type;
	while(obj_file>>type){
		if(type == "v"){
			float x,y,z;
			obj_file>>x>>y>>z;
			txt_file<<x<<'	'<<y<<'	'<<z<<endl;
		}
		else if(type == "f"){
			cnt++;
			int x,y,z,aux;
			char aux_c;
			
			if(format==1)
				obj_file>>x>>aux_c>>aux>>y>>aux_c>>aux>>z>>aux_c>>aux;
			else if (format==2)
				obj_file>>x>>aux_c>>aux>>aux_c>>aux>>y>>aux_c>>aux>>aux_c>>aux>>z>>aux_c>>aux>>aux_c>>aux;
			else
				obj_file>>x>>y>>z;
			
			vector<int> arr = {x,y,z};
			sort(arr.begin(), arr.end());
		 
			tuple<int,int,int> t(arr[0],arr[1],arr[2]);
			vec.push_back(t);
		}	
	}
	
	sort(vec.begin(),vec.end());
	
	for(auto a:vec)
		txt_file<<get<0>(a)-1<<" "<<get<1>(a)-1<< " "<< get<2>(a)-1<< endl;
	
	obj_file.close();
	txt_file.close();
}

int main () {
	obj_to_txt("bunny.obj","bunny.txt");
	return 0;
}
