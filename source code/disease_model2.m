load('MeshID.mat');
load('CircR2Disease.mat');
load('Mesh_disease.mat');
load('MeshID.mat');

MeshID_str=cell(4594,20); %第一，二列保存节点的名称，后面保存节点结构，一列代表一层，用逗号隔开


% %-------这部分不必每次都跑，已经保存过了----------
% %先汇总下节点的结构序列
disease_Str=cell(4594,2); %保存节点的结构序列
for i=1:4594  %meshID中疾病的数量
    i
   disease_Str(i,1)=strtrim(cellstr(Mesh_Disease(i,1)));
   for j=1:11241
       if strcmp(disease_Str(i),MeshID(j,1))
           disease_Str(i,2)=strcat(disease_Str(i,2),MeshID(j,2),'-');
       end
   end
end
% 
%-------这部分不必每次都跑，已经保存过了----------
%构建MeshID的结构MeshID_str
for i=1:4594
    i    
    j=3; %DV从第三列开始保存节点，第一列放节点名字，第二列放本层（就是自己）节点
    MeshID_str=add_node2(i,j,MeshID_str,Mesh_Disease{i,1},disease_Str,MeshID);
end
%加上第一，二列
for i=1:4594
    MeshID_str(i,1)=Mesh_Disease(i,1);
    MeshID_str(i,2)=Mesh_Disease(i,1);
end



%得到MeshID_str，对MeshID_str中各层去重

for i=1:4594
    i
    for j=3:20
        if ~isempty(MeshID_str{i,j})
            Temp3=regexp(MeshID_str{i,j}, '*', 'split');
            [h3,l3] = size(Temp3);
            for k=1:l3  %去掉重复的
                for p=j:20  
                    if ~isempty(MeshID_str{i,p})
                        tihuan=strcat('*',Temp3{1,k},'*');
                        Temp5=strcat('*',MeshID_str{i,p}, '*');%给字符串加个后缀，以免多删字符
                        Temp5=strrep(Temp5,tihuan,'*');
                        if p==j %在自己那层，加入
                            Temp5=strcat(Temp5,'*',Temp3{1,k});
                        end
                         %重新写入去重后的MeshID_str,每个MeshID_str值后面都加了个'*'
                        MeshID_str(i,p) = cellstr(Temp5);
                     end
                    
                end
            end
        end
        
    end  
end
%去除多余的*
for i=1:4594
    i
    for j=3:20
        if ~isempty(MeshID_str{i,j})
             Temp_tihuan=regexp(MeshID_str{i,j}, '*', 'split'); %去除多余的*
             Temp6='';
             [h0,ll0]=size(Temp_tihuan);
             for pp=1:ll0
                if  ~isempty(Temp_tihuan{1,pp})
                    Temp6=strcat(Temp_tihuan{1,pp},'*',Temp6);
                end
             end
            MeshID_str(i,j) = cellstr(Temp6);
        end
    end
end
%保存MeshID_str
    


% 
 Dise_Num=89;
%记录疾病在多少个DAG图中
disease_num=zeros(Dise_Num,1);
for i=1:Dise_Num
    i
   for j=1:4594
      for k=2:20
          if ~isempty(MeshID_str{j,k}) 
              Temp=regexp(MeshID_str{j,k}, '*', 'split');%分开每层节点
              [h,l]=size(Temp);
              for p=1:l
                if strcmp(disease(i),Temp(1,p))
                    disease_num(i)=disease_num(i)+1;
                end
              end
          end
      end
  end
end
%计算-log2(节点个数/总数)
for i=1:Dise_Num
    if disease_num(i,1) ~=0
        disease_num(i,2)=-log2(disease_num(i,1)/4594);
    else
        disease_num(i,2)=0;
    end
end
% %保存disease_num


%给出两个疾病，找它们的共同节点，算出数
load('disease_model1_DV.mat');
SS=zeros(Dise_Num,Dise_Num);
value_Same=0;

for i=1:Dise_Num
    i
    for j=1:Dise_Num
        %如果疾病i或疾病j不在MeshID_str中，SS(i,j)=0
        if isempty(DV{i,3})|| isempty(DV{j,3})
            SS(i,j)=0;
        else
             %找到两个疾病下各自的孩子节点
            dis1_str='';
            dis2_str='';
            for k=2:10
                if ~isempty(DV{i,k})
                    dis1_str=strcat(dis1_str,DV{i,k});
                end
            end
            for k=2:10
                if ~isempty(DV{j,k})
                    dis2_str=strcat(dis2_str,DV{j,k});
                end
            end
            
             %按mesh计算
            dis1=regexp(dis1_str,'*','split');  %疾病1的所有孩子节点
            dis2=regexp(dis2_str,'*','split');  %疾病2的所有孩子节点
            %找相同节点
            [h5,l5] = size(dis1);
            [h6,l6] = size(dis2);
            for p=1:l5-1
                for q=1:l6-1  
                    if strcmpi(dis1(1,p),dis2(1,q))
                        for k=1:Dise_Num  %相同的疾病，在disease_num中找值
                            if strcmp(dis1(1,p),disease(k,1))
                                value_Same=disease_num(k,2);
                                break;
                            end
                        end
                        SS(i,j)=2*value_Same/(DV{i,1}+DV{j,1});
                    end
                end
            end

        end
        
        %如果同一个疾病（对角线），i=j，赋值为1
        if i==j
            SS(i,j)=1;
        end
    end
end
%保存SS


