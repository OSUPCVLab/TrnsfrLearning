function [combination_matrix]=breed(improve, alpha, parent1, parent2, limits, param_type_int, n_children, parent_pool_on, parent_pool)
if improve==0
    alpha=alpha*2;
else
    alpha=alpha/1.5;
end
if alpha<0.0001||alpha>2
   alpha=0.5; 
end

pp_size=size(parent_pool);
parents=pp_size(1);
param_range=limits(2,:)-limits(1,:);
dim=length(parent1);
children=zeros(n_children,dim);
if parent_pool_on==1
    
    parent_avg=(parent1+parent2)/2;
    parent_dist=abs(parent1-parent2);
    for i=1:dim
        if parent_avg(i)<parent_dist(i)
            parent_dist(i)=parent_avg(i);
        end
    end
    
    for i=1:floor(n_children/2)
        sim=1;
        iter=0;
        while sim>0.99
            iter=iter+1;
            rand_parent=floor(.5+rand(1,dim));
            children(i,:)=(rand_parent.*parent1+(1-rand_parent).*parent2)+alpha*param_range.*normrnd(0,1/3,1,dim);
            
            for j=1:dim
                if children(i,j)<limits(1,j)
                    children(i,j)=limits(1,j)+(limits(2,j)-limits(1,j))/2*rand();
                elseif children(i,j)>limits(2,j)
                    children(i,j)=limits(2,j)-(limits(2,j)-limits(1,j))/2*rand();
                end
                
                if param_type_int(j)==1
                    children(i,j)=ceil(children(i,j));
                end
            end
            sim1=dot_similarity(children(i,:),parent1);
            sim2=dot_similarity(children(i,:),parent2);
            sim=max(sim1,sim2);
            for ii=1:parents
                temp_sim=dot_similarity(children(i,:),parent_pool(ii,:));
                if temp_sim<sim
                   sim=temp_sim; 
                end
            end
        end
    end
    
    for i=floor(n_children/2)+1:n_children
        rand_parent_select=floor(parents*rand())+1;
        pparent1=parent_pool(rand_parent_select,:);
        rand_parent_select=floor(parents*rand())+1;
        pparent2=parent_pool(rand_parent_select,:);
        
        sim=1;
        iter=0;
        while sim>0.99
            iter=iter+1;
            rand_parent=floor(.5+rand(1,dim));
            children(i,:)=(rand_parent.*pparent1+(1-rand_parent).*pparent2)+alpha*param_range.*normrnd(0,1/3,1,dim);
            
            for j=1:dim
                if children(i,j)<limits(1,j)
                    children(i,j)=limits(1,j)+(limits(2,j)-limits(1,j))/2*rand();
                elseif children(i,j)>limits(2,j)
                    children(i,j)=limits(2,j)-(limits(2,j)-limits(1,j))/2*rand();
                end
                
                if param_type_int(j)==1
                    children(i,j)=ceil(children(i,j));
                end
            end
            
            sim1=dot_similarity(children(i,:),parent1);
            sim2=dot_similarity(children(i,:),parent1);
            sim=max(sim1,sim2);
            for ii=1:pp_size(1)
                temp_sim=dot_similarity(children(i,:),parent_pool(ii,:));
                if temp_sim>sim
                   sim=temp_sim; 
                end
            end
        end
    end
else    
    for i=1:n_children
        sim=1;
        iter=0;
        while sim>0.99
            iter=iter+1;
            rand_parent=floor(.5+rand(1,dim));
            children(i,:)=(rand_parent.*parent1+(1-rand_parent).*parent2)+alpha*param_range.*normrnd(0,1/3,1,dim);
            
            for j=1:dim
                if children(i,j)<limits(1,j)
                    children(i,j)=limits(1,j)+(limits(2,j)-limits(1,j))/2*rand();
                elseif children(i,j)>limits(2,j)
                    children(i,j)=limits(2,j)-(limits(2,j)-limits(1,j))/2*rand();
                end
                
                if param_type_int(j)==1
                    children(i,j)=ceil(children(i,j));
                end
            end
            sim1=dot_similarity(children(i,:),parent1);
            sim2=dot_similarity(children(i,:),parent1);
            sim=max(sim1,sim2);
        end
    end
end



combination_matrix=children;
end