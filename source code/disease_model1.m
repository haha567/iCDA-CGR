% %-------这部分不必每次都跑，已经保存过了----------
% DirStr=['./data/MeshID.txt'];
% fidin=fopen(DirStr);             % 打开txt文件    
% 
% MeshID=cell(11241,2);  %保存MeshID内容，分成名字和结构两部分
% i=1;
% while ~feof(fidin)                                                       % 判断是否为文件末尾               
%     tline=fgetl(fidin); 
%     if tline 
%         SStr = regexp(tline, ';', 'split');
%         MeshID(i,1)=SStr(1);
%         MeshID(i,2)=SStr(2);
%         i=i+1;
%     end
% end
% fclose(fidin);
% %保持为MeshID.mat 


%-------这部分不必每次都跑，已经保存过了----------
load('CircR2Disease.mat');
load('Mesh_disease.mat');
load('MeshID_DV_all.mat');
load('MeshID.mat');













%先汇总下节点的结构序列
disease_Str=cell(4594,2); %保存节点的结构序列，4594为meshID中节点的数量
for i=1:4594
    i
   disease_Str(i,1)=strtrim(cellstr(Mesh_Disease(i)));
   for j=1:11241
       if strcmpi(disease_Str(i),MeshID(j,1))
           disease_Str(i,2)=strcat(disease_Str(i,2),MeshID(j,2),'-');
       end
   end
end

 Dise_Num=89;%疾病的数量
% 
 DV=cell(Dise_Num,10); %第一列保存节点的DV值，后面保存节点结构，一列代表一层，用星号隔开
% 
% 按层得到DV的节点
for i=1:Dise_Num
    i    
    j=3; %DV从第三列开始保存孩子节点，第二列保存自己
    DV=add_node(i,j,DV,disease{i,1},disease_Str,MeshID);
    DV(i,2)=strcat(disease(i,1),'*');
end










%此时得到的DV包含全部序列，要从头扫描，按层去掉重复的，这样就能实现最大化节点数
for i=1:Dise_Num
    i
    for j=3:10
        if isempty(DV{i,j})
            break;
        else
            Temp3=regexp(DV{i,j}, '*', 'split');
            [h3,l3] = size(Temp3);
            for k=1:l3  %去掉重复的
                for p=j:10  
                    if ~isempty(DV{i,p})
                        Temp5=regexp(DV{i,p}, '*', 'split');
                        [h5,l5]=size(Temp5);
                        for q=1:l5 %查找重的，连自己也删去，在后面添加自己
                            if strcmpi(Temp3(1,k),Temp5(1,q))
                                Temp5{1,q}=[]; %给cell赋空值
                            end
                        end
                        if p==j %在自己那层，加入
                            Temp5=[Temp5,Temp3(1,k)];
                        end
                        
                        %重新写入去重后的DV,每个DV值后面都加了个'*'
                        DV{i,p} = [];
                        [h6,l6]=size(Temp5);
                        for q=1:l6
                            if ~isempty(Temp5{1,q})
                                DV(i,p) = strcat(Temp5(1,q),'*',DV(i,p));
                            end
                        end
                    end
                    
                end
            end
        end
    end
end

%计算DV的值
for i=1:Dise_Num
     if isempty(DV{i,3}) 
        DV(i,1)=num2cell(1);
     else
        j=3;
        value=1;
        aa=0.5  %设的参数
        while  j<=10 && ~isempty(DV{i,j})
            Temp3 = regexp(DV{i,j}, '*', 'split'); %看去重后的DV（i,j）有几个节点
            [h3,l3] = size(Temp3);
            value = value + aa*(l3-1); %记录值
            aa=aa*0.5;  %每多一层，多乘个0.5
            j=j+1;
        end
        DV(i,1)=num2cell(value);
     end
end
%%%%%%%%%%%%%%%保存DV 


%-------DV_all是从MeshID_str来的，这部分不必每次都跑，已经保存过了----------
%计算DV_all的值，DV_all是从MeshID_str.mat来的
for i=1:4594
     if isempty(DV_all{i,3}) 
        DV_all(i,1)=num2cell(1);  
     else
        j=3;
        value=1;
        aa=0.5  %设的参数
        while ~isempty(DV_all{i,j})
            Temp3 = regexp(DV_all{i,j}, '*', 'split'); %看去重后的DV_all（i,j）有几个节点
            [h3,l3] = size(Temp3);
            value = value + aa*(l3-1); %记录值
            aa=aa*0.5;  %每多一层，多乘个0.5
            j=j+1;
        end
        DV_all(i,1)=num2cell(value);
     end
end
%%%%%%%%%%%%保存DV_all



% 
S=zeros(Dise_Num,Dise_Num); %最终的矩阵
%给出两个疾病，找它们的共同节点，算出数
for i=1:Dise_Num
    i
    for j=1:Dise_Num
        if i==14 && j==12
           aaa=[]; 
        end
        %如果疾病i或疾病j不在DV中，S(i,j)=0
        if isempty(DV{i,3})|| isempty(DV{j,3})
            S(i,j)=0;
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
                        value_Same=0;  %初始化相同节点的计算值
                        value_Same1=0;  %初始化相同节点的计算值
                        value_Same2=0;  %初始化相同节点的计算值
                        for k=1:4594  %相同的疾病，计算值
                            if strcmpi(dis1(1,p),disease_Str(k,1))
%                                 jj=2;%从第一层找（以零开始）
%                                 aa=0.5;  %设的参数
%                                 value5=0;
%                                 while ~isempty(DV_all{k,jj})
%                                     Temp5 = regexp(DV_all{k,jj},'*','split'); %重新看去重后的DV（i,j）有几个节点
%                                     [h7,l7] =  size(Temp5);
%                                     value5 = value5 + aa*(l7-1); %记录值
%                                     aa=aa*0.5;  %每多一层，多乘个0.5
%                                     jj=jj+1;
%                                 end
%                                 value_Same=value5;
                                  value_Same=0.5*DV_all{k,1}; %用DV_all中的值，不用再计算了
                                  break;
                            end
                        end
                        %看节点1在该疾病的第几层，在全局mesh中
                        [bool,inx1]=ismember(disease{i,1},disease_Str(:,1));
                        if inx1 > 0
                            C_num=2; %初始化在第一层
                            for r=2:10
                                if ~isempty(DV_all{inx1,r})
                                    Temp6 = regexp(DV_all{inx1,r},'*','split');
                                    [h8,l8]=size(Temp6);
                                    for rr=1:l8
                                        if strcmpi(dis1(1,p),Temp6(1,rr))
                                            C_num=r;
                                            break;
                                        end
                                    end 
                                end
                            end
                           value_Same1=0.5^(C_num-3)*value_Same; 
                        end
             
                         %看节点2在该疾病网络的第几层
                        [bool,inx2]=ismember(disease{j,1},disease_Str(:,1));
                        if inx2 > 0
                            C_num2=2; %初始化在第一层
                            for r2=2:10
                                if ~isempty(DV_all{inx2,r2}) && inx2~=0
                                    Temp7 = regexp(DV_all{inx2,r2},'*','split');
                                    [h9,l9]=size(Temp7);
                                    for rr=1:l9
                                        if strcmpi(dis2(1,q),Temp7(1,rr))
                                            C_num2=r2;
                                            break;
                                        end
                                    end 
                                end
                            end
                           value_Same2=0.5^(C_num2-3)*value_Same;
                        end
                        
                        value_s=(value_Same1+value_Same2)/(DV{i,1}+DV{j,1});
                        if S(i,j)<value_s  %%只保留最大层的
                            S(i,j)=value_s;
                            break;    %%找到最大层的跳出
                        end
                       break;
                    end
                end
            end
        end
        
        %如果同一个疾病（对角线），i=j，赋值为1
        if i==j
            S(i,j)=1;
        end
    end
end
%%%%%%%%%%%%%%%保存S

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


