function pdf = LBA(t, A, b, v, sv)
% Generates defective PDF for responses (ie. normalised by
% probability of this node winning race)
%
% pdf = LBA_n1PDF(t, A, b, v, sv)


N = size(v,2);

if N > 2
    for i = 2:N
        %tmp(:,i-1) = LBA_tcdf(t,A(:,i),b,v(:,i),sv);
        tmp(:,i-1) = LBA_tcdf(t,A,b,v(:,i),sv);
    end
    G = prod(1-tmp,2);
else
    G = 1-LBA_tcdf(t,A,b,v(:,2),sv);
end
%pdf = G.*LBA_tpdf(t,A(:,1),b,v(:,1),sv);
pdf = G.*LBA_tpdf(t,A,b,v(:,1),sv);