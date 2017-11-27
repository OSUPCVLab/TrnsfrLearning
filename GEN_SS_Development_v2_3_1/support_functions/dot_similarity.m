function sim=dot_similarity(A,B)
if norm(A)>0&&norm(B)>0
    HP_max_limits=[1 200 10 20 1];
    A=A./HP_max_limits;
    B=B./HP_max_limits;
    sim=(A/norm(A))*(B/norm(B))';
else
   sim=0; 
end
end