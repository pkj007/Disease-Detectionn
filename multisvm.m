function [result] = multisvm( T,C,test )


itr=1;
itrind=size(test,1);
result=[];
Cb=C;
Tb=T;
for tempind=1:itrind
    tst=test(tempind,:);
    C=Cb;
    T=Tb;
    u=unique(C);
    N=length(u);
    c4=[];
    c3=[];
    j=1;
    k=1;
    if(N>2)
        itr=1;
        classes=0;
        cond=max(C)-min(C);
        while((classes~=1)&&(itr<=length(u))&& size(C,2)>1 && cond>0)
            c1=(C==u(itr));
            newClass=c1;
            svmStruct = svmtrain(T,newClass,'kernel_function','rbf');
 
            svmStruct = svmtrain(T,newClass);
            classes = svmclassify(svmStruct,tst);
        
            % This is the loop for Reduction of Training Set
            for i=1:size(newClass,2)
                if newClass(1,i)==0;
                    c3(k,:)=T(i,:);
                    k=k+1;
                end
            end
        T=c3;
        c3=[];
        k=1;
        
            % This is the loop for reduction of group
            for i=1:size(newClass,2)
                if newClass(1,i)==0;
                    c4(1,j)=C(1,i);
                    j=j+1;
                end
            end
        C=c4;
        c4=[];
        j=1;
        
        cond=max(C)-min(C);  
                           
            if classes~=1
                itr=itr+1;
            end    
        end
    end

valt=Cb==u(itr);		
val=Cb(valt==1);		
val=unique(val);
result(tempind,:)=val;  
end

end


