function [results, results_all] = analyze_collins14(data)

% Construct reward-complexity curve for Collins et al. (2014) data.

load collins14.mat
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

        if sum(mean(Q)>0.34)>0 && length(S)>2
            tag(b,s) = 1;
        else
            tag(b,s) = 0;
        end

       
        [~,Pa_type]= max(mean(Q,1));
        rows = find(Q(:,Pa_type)==0);
        temp = nan(size(Q));
        for i = 1:length(rows)
            temp(rows(i),:) = Q(rows(i),:)==0;
        end
        pref = temp; pref(pref<1) = NaN;
        pref(rows,Pa_type) = NaN;
        %magnitude(b,s) = max(mean(Q),1)-min(mean(Q),1);

        a_pref(b,:) = mean([pas(rows,Pa_type), pas(pref>0)],1);

        [R(b,:),V(b,:)] = blahut_arimoto(Ps,Q,beta);

        setsize(b) = length(S)-1;
        cond(s,b) = length(S);


    end % blocks

    %bins = [0:0.2:1];
    for c = 1:max(setsize)
        results.pref(s,:,c) = nanmean(a_pref(setsize==c & tag(:,s),:),1);

        %         tmp = magnitude(setsize==c & tag(:,s));
        %         for k = 1:length(tmp)
        %             for i = 1:length(bins)-1
        %                 if tmp(k)>bins(i) && tmp(k)<bins(i+1)
        %                     bin_idx(k) = i;
        %                 end
        %             end
        %         end
        %
        %         for k = unique(bin_idx)
        %             tmp2 = a_pref(setsize==c & tag(:,s),:);
        %             results.pref_bin(s,:,k,c) = nanmean(tmp2(bin_idx' == k,:),1);
        %         end

        results.R(s,:,c) = nanmean(R(setsize==c,:));
        results.V(s,:,c) = nanmean(V(setsize==c,:));
        results.R_data(s,c) = nanmean(R_data(setsize==c));
        results.V_data(s,c) = nanmean(V_data(setsize==c));


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

figure; hold on;
for c = 2:max(setsize)
    nexttile; hold on;
    b = barwitherr(sem(results.pref(:,:,c),1),mean(results.pref(:,:,c)));
    ylabel('P(A)'); set(gca,'XTick',[]);
    xticks([b.XEndPoints]); xticklabels({'A_1','A_2'})
    ylim([0 0.25]);
    title(['nS = ',num2str(c+1)])
    if c == 1
        legend('A_1','A_2')
    end
    d(c) = mean(results.pref(:,1,c)-results.pref(:,2,c));
    d_se(c) = sem(results.pref(:,1,c)-results.pref(:,2,c),1);
end
nexttile; hold on;
errorbar(3:6,d(2:end),d_se(2:end)./2,d_se(2:end)./2);
xlabel('Set size')
ylabel('\Delta P(A)')
title('P(A_1) - P(A_2)')
xticks([3:6])
axis([2 7 0 0.05])

figure; hold on;
cond = [data.cond];
for j = 0:1
    for c = 1:max(setsize)
        nexttile; hold on;
        b = barwitherr(sem(results.pref(cond==j,:,c),1),mean(results.pref(cond==j,:,c)));
        ylabel('P(A)'); set(gca,'XTick',[]);
        xticks([b.XEndPoints]); xticklabels({'A_1','A_2'})
        ylim([0 0.25]);
        title(['nS = ',num2str(c+1)])
        if c == 1
            legend('A_1','A_2')
        end
        d(j+1,c) = mean(results.pref(cond==j,1,c)-results.pref(cond==j,2,c));
        d_se(j+1,c) = sem(results.pref(cond==j,1,c)-results.pref(cond==j,2,c),1);
    end
end

set(gcf, 'Position',  [300, 400, 1400, 400])
exportgraphics(gcf,[pwd '/figures/raw/Collins14-Biases.pdf'], 'ContentType', 'vector');

cmap = brewermap(5,'Set2');
figure; hold on; colororder(cmap)
for j = 1:2
    errorbar(2:max(setsize)+1,d(j,:),d_se(j,:)/2,d_se(j,:)/2,'color',cmap(j,:));
end
xlabel('Set size')
ylabel('\Delta P(A)')
title('P(A_1) - P(A_2)')
legend('Healthy Controls','SCZ Patients')
axis([1 7 -0.02 0.08]);
xticks([2:6])
set(gcf, 'Position',  [300, 400, 400, 400])
exportgraphics(gcf,[pwd '/figures/raw/Collins14-BiasesSummary.pdf'], 'ContentType', 'vector');

% compute bias
R = squeeze(nanmean(results.R));
V = squeeze(nanmean(results.V));
for c = 1:max(setsize)
    Vd2(:,c) =  interp1(R(:,c),V(:,c),results.R_data(:,c));
    results.bias(:,c) = Vd2(:,c) - results.V_data(:,c);
    results.V_interp(:,c) = Vd2(:,c);
end

% fit empirical reward-complexity curves with polynomial
cond = [data.cond];
for j = 1:2
    results.bic = zeros(max(setsize),2);
    results.aic = zeros(max(setsize),2);
    for c = 1:max(setsize)
        % takes only HC or SCZ
        x = results.R_data(cond==j-1,c);
        x = [ones(size(x)) x x.^2];
        y = results.V_data(cond==j-1,c);
        n = length(y); k = size(x,2);
        [b,bint] = regress(y,x);
        results.bci_sep(c,j,:) = diff(bint,[],2)/2;
        results.b_sep(c,j,:) = b;
        mse = mean((y-x*b).^2);
        results.bic(c,1) = results.bic(c,1) + n*log(mse) + k*log(n);
        results.aic(c,1) = results.bic(c,1) + n*log(mse) + k*2;

        % takes both HC and SCZ
        x = results.R_data(:,c);
        x = [ones(size(x)) x x.^2];
        y = results.V_data(:,c);
        n = length(y); k = size(x,2);
        [b,bint] = regress(y,x);
        results.bci_joint(c,j,:) = diff(bint,[],2)/2;
        results.b_joint(c,j,:) = b;
        mse = mean((y-x*b).^2);
        results.bic(c,2) = n*log(mse) + k*log(n);
        results.aic(c,2) = n*log(mse) + k*2;

    end
end