function [results, results_all] = analyze_collinsfrank18

% Construct reward-complexity curve for Collins & Frank (2018) data.

load collinsfrank18.mat
beta = linspace(0.1,15,50);

% run Blahut-Arimoto
for s = 1:length(data)
    B = unique(data(s).learningblock);
    setsize = zeros(length(B),1);
    R_data =zeros(length(B),1);
    V_data =zeros(length(B),1);
    for b = 1:length(B)
        ix = data(s).learningblock==B(b);
        state = data(s).state(ix);
        c = data(s).corchoice(ix);
        action = data(s).action(ix);
        rt(b) = nanmean(data(s).rt(ix));
        ns = data(s).ns(ix);
        R_data(b) = mutual_information(state,action,0.1);
        V_data(b) = mean(data(s).reward(ix));

        S = unique(state);
        Q = zeros(length(S),3);
        Ps = zeros(1,length(S));
        clear ii pas
        for i = 1:length(S)
            ii = state==S(i);
            Ps(i) = mean(ii);
            a = c(ii); a = a(1);
            Q(i,a) = 1;
            for j = 1:3
                pas(i,j) = sum(state==i & action==j);
            end
        end
        pas = pas./nansum(pas,2);

        tt = unique(mean(Q,1));
        if length(tt)>1 && unique(ns)>1 && tt(end) >= 0.5    
            magnitude(b,s) = tt(end)-tt(end-1);
            tag(b,s) = 1;
        else
            magnitude(b,s) = NaN;
            tag(b,s) = 0;
        end

        if unique(ns)==2 && length(find(mean(Q,1)>0.4))>1
            pa_col = find(mean(Q,1)>0.4);
            rows(1) = find(Q(:,pa_col(1))==0);
            rows(2) = find(Q(:,pa_col(2))==0);
            pa_rows = rows;
            temp = nan(size(Q));
            for i = 1:length(rows)
                temp(rows(i),:) = Q(rows(i),:) == 0;
            end
            pref = temp; pref(pref<1) = NaN;
            pref(rows,pa_col) = NaN;
            temp2 = [pas(rows(1),pa_col(1)); pas(rows(2),pa_col(2))];
            a_pref(b,:) = mean([temp2, pas(pref>0)],1);

        else
            [~,pa_col]= max(mean(Q,1));
            rows = find(Q(:,pa_col)==0);
            pa_rows = find(Q(:,pa_col)==1);
            temp = nan(size(Q));
            for i = 1:length(rows)
                temp(rows(i),:) = Q(rows(i),:) ==0;
            end
            pref = temp; pref(pref<1) = NaN;
            pref(rows,pa_col) = NaN;
            if unique(ns)>1
                a_pref(b,:) = mean([pas(rows,pa_col), pas(pref>0)],1);
            else
                a_pref(b,:) = [NaN NaN];
            end
        end

        sub_idx = Q(rows,:); sub_idx(sub_idx==1) = NaN; sub_idx(sub_idx==0) = 1;
        tmp = pas(rows,:).*sub_idx;
        sub(b,1) = nanmean(tmp(:)); % suboptimal actions affected by highest P(A)
        
        sub_idx = Q(pa_rows,:); sub_idx(sub_idx==1) = NaN; sub_idx(sub_idx==0) = 1;
        tmp = pas(pa_rows,:).*sub_idx;
        sub(b,2) = nanmean(tmp(:)); % suboptimal actions NOT affected by highest P(A)

        [R(b,:),V(b,:)] = blahut_arimoto(Ps,Q,beta);
        setsize(b) = length(S);
        clear rows
    end % blocks

    for c = 1:max(setsize)
        results.pref(s,:,c) = nanmean(a_pref(setsize==c & tag(:,s),:),1);
        results.magnitude(s,:,c) = nanmean(magnitude(setsize==c & tag(:,s),s));
        results.sub(s,:,c) = nanmean(sub(setsize==c & tag(:,s),:));
        results.R(s,:,c) = nanmean(R(setsize==c,:));
        results.V(s,:,c) = nanmean(V(setsize==c,:));
        results.R_data(s,c) = nanmean(R_data(setsize==c));
        results.V_data(s,c) = nanmean(V_data(setsize==c));
        results.rt(s,c) = nanmean(rt(setsize==c));

        if nargout > 1
            results_all.R{s,c} = R(setsize==c,:);
            results_all.V{s,c} = V(setsize==c,:);
            results_all.R_data{s,c} = R_data(setsize==c,:);
            results_all.V_data{s,c} = V_data(setsize==c,:);
            results_all.RV_corr(s,c) = corr(R_data(setsize==c,:),V_data(setsize==c,:),'type','spearman');
        end
    end
    clear R V
end


% % compute bias
% R = squeeze(nanmean(results.R));
% V = squeeze(nanmean(results.V));
% for c = 1:max(setsize)
%     Vd2(:,c) =  interp1(R(:,c),V(:,c),results.R_data(:,c));
%     results.bias(:,c) = Vd2(:,c) - results.V_data(:,c);
%     results.V_interp(:,c) = Vd2(:,c);
% end
%
% % fit empirical reward-complexity curves with polynomial
% cond = [data.cond];
% for j = 1:2
%     results.bic = zeros(max(setsize),2);
%     results.aic = zeros(max(setsize),2);
%     for c = 1:max(setsize)
%         % takes only HC or SCZ
%         x = results.R_data(cond==j-1,c);
%         x = [ones(size(x)) x x.^2];
%         y = results.V_data(cond==j-1,c);
%         n = length(y); k = size(x,2);
%         [b,bint] = regress(y,x);
%         results.bci_sep(c,j,:) = diff(bint,[],2)/2;
%         results.b_sep(c,j,:) = b;
%         mse = mean((y-x*b).^2);
%         results.bic(c,1) = results.bic(c,1) + n*log(mse) + k*log(n);
%         results.aic(c,1) = results.bic(c,1) + n*log(mse) + k*2;
%
%         % takes both HC and SCZ
%         x = results.R_data(:,c);
%         x = [ones(size(x)) x x.^2];
%         y = results.V_data(:,c);
%         n = length(y); k = size(x,2);
%         [b,bint] = regress(y,x);
%         results.bci_joint(c,j,:) = diff(bint,[],2)/2;
%         results.b_joint(c,j,:) = b;
%         mse = mean((y-x*b).^2);
%         results.bic(c,2) = n*log(mse) + k*log(n);
%         results.aic(c,2) = n*log(mse) + k*2;
%
%     end
% end