%递归函数，给DV加节点
function  DV=add_node(i,j,DV,node,disease_Str,MeshID)
    %j
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
        
        if ~isempty(DV{i,j})  
            Temp_a=regexp(DV{i,j},'*','split');
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
                DV(i,j)=strcat(DV(i,j),'*',str(1,k));
            end
        end

        for k=1:ll3
            DV=add_node(i,j+1,DV,str{1,k},disease_Str,MeshID);
        end
    end
end