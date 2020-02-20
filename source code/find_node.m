
function str  = find_node(node,disease_Str,MeshID)
    for i=1:4594 
        if strcmpi(node,disease_Str(i,1))
           Temp1=regexp(disease_Str{i,2}, '-', 'split'); 
           [h1,l1] = size(Temp1);
           node_num=cell(1,l1-1); 
           str=cell(1,l1-1);
           for j=1:l1-1
                Temp2=regexp(Temp1{1,j}, '\.', 'split');
                [h2,l2] = size(Temp2);
                for k=1:l2-1   
                    if k==1
                        node_num(j) = Temp2(1,k);
                    else
                        node_num(j) = strcat(node_num(j),'.',Temp2(1,k));
                    end
                end
                for k=1:11241
                   if  strcmpi(node_num(j),MeshID(k,2))
                       str(1,j)=MeshID(k,1);
                   end
                end
           end  
           break;
           
        else
         str=cell(1,1);   
        end
        
    end
end

