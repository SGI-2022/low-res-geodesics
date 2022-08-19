function[]= txt_to_obj(txt_name, obj_name)
    fileID = fopen(txt_name,'r');
    formatSpec = '%f';
    A = fscanf(fileID,formatSpec);
    
    num_verts = A(1);
    num_faces = A(2);
    
    verts=zeros(num_verts,3);
    faces=zeros(num_faces,3);
    
    i=3;
    j=1;
    
    while i<= num_verts*3+2
        verts(j,1)=A(i);
        verts(j,2)=A(i+1);
        verts(j,3)=A(i+2);
        i=i+3;
        j=j+1;
    end 
    
    j=1;
    while i<= size(A,1)
        faces(j,1)=A(i)+1;
        faces(j,2)=A(i+1)+1;
        faces(j,3)=A(i+2)+1;
        i=i+3;
        j=j+1;
    end
    
    writeOBJ(obj_name,verts,faces);
end