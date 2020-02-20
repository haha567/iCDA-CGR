
function  MeshID_str=add_node2(i,j,MeshID_str,node,disease_Str,MeshID)

    str=find_node(node,disease_Str,MeshID);
    if ~isempty(str{1,1}) 
        [hh3,ll3]=size(str);
        for aa=1:ll3  
           for bb=aa+1:ll3
               if strcmp(str(1,aa),str(1,bb))
                    str{1,bb}=[];
               end
           end
        end
        
        if ~isempty(MeshID_str{i,j})  
            Temp_a=regexp(MeshID_str{i,j},'*','split');
            [hh1,ll1]=size(Temp_a);
            for aa=1:ll1
                for bb=1:ll3
                    if strcmp(Temp_a(1,ll1),str(1,ll3))
                        str{1,ll3}=[];
                    end
                end
            end
        end
        for k=1:ll3
            if ~isempty(str{1,k}) 
                MeshID_str(i,j)=strcat(MeshID_str(i,j),'*',str(1,k));
            end
        end
        
        for k=1:ll3
            MeshID_str=add_node2(i,j+1,MeshID_str,str{1,k},disease_Str,MeshID);
        end
    end
end