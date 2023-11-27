function results = analyze_data(fig,data,plt,sidx,bh)
% experiment-specific data analysis
%
% data - the loaded mat file
% sidx - specific subject indices
% bh - only plot the end of the block for optimal comparison with blahut-arimoto simulations

if nargin <4; sidx = 1:length(data); bh = 0; end
if nargin <5; bh = 0; end

DATA = data;
nSubj = length(data);
cmap = brewermap(3,'Set1'); cmap2 = brewermap(6,'Set2');

policy_update = {'complexity_limit','value_absolute','value_percent'};
opt_labels = {'Optimize capacity','Optimize aspiration','Optimize value max'};
beta = linspace(0.01,30,30);
Q_labels = {'Q1','Q2','Q3'};
clear R V
disp(['Analysis for:' fig])

switch fig
    case 'task1' % changing distributions
        Ps(1,:) = ones(1,3)/3;
        Ps(2,:) = [0.6 0.2 0.2];

        Q = {[0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8];             % p(s) manipulation
            [0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8]};

        sub = {[NaN 1 1; 1 NaN 1 ; 1 1 NaN];
            [NaN 1 1; 1 NaN 1 ; 1 1 NaN]};
        pref = {[NaN 1 1; 1 NaN 1; 1 1 NaN];
            [NaN 1 1; 1 NaN 1; 1 1 NaN]};

    case 'task2' % states with >1 optimal action
        Ps(1,:) = ones(1,3)/3;
        Ps(2,:) = ones(1,3)/3;

        Q = {[1 0.333 0.333;0.333 1 0.333;0.333 0.333 1]
            [1 0 0;1 1 0;1 0 1]};

        sub = {[NaN 1 1; 1 NaN 1 ; 1 1 NaN];
            [NaN 1 1; NaN NaN 1 ; NaN 1 NaN]};
        pref = {[NaN 1 1; 1 NaN 1; 1 1 NaN];
            [NaN 1 1; 1 1 NaN ; 1 NaN 1]};

    case 'task3' % time pressure
        Ps(1,:) = ones(1,3)/3;
        Ps(2,:) = ones(1,3)/3;

        Q = {[1 0.5 0;1 0.5 0;0.5 0 1];                  % time pressure
            [1 0.5 0;1 0.5 0;0.5 0 1]};

        sub = {[NaN 1 NaN; NaN 1 NaN; 1 NaN NaN];
            [NaN 1 NaN; NaN 1 NaN; 1 NaN NaN]};
        pref = [];

end % switch (which task)

%% plot
for i = 1:length(Q)
    [R(i,:),V(i,:),pa(:,:,i)] = blahut_arimoto(Ps(i,:),Q{i},beta);
end

task = num2str(fig(end))-'0';
if contains(fig,'test')
    task = 1;
end
for s = 1:length(sidx)
    data = DATA(sidx(s)).exp(task);
    if data.cond(1) == 1
        order(s,:) = [1];
    else
        order(s,:) = [2];
    end
    C = unique(data.cond)';
    for c = C

        clear pas
        ix = find(data.cond==C(c));
        if bh
            ix = ix(end-30:end);
        end
        state = data.s(ix);
        action = data.a(ix);
        reward = data.r(ix);
        RT = data.rt(ix);
        rt(s,c) = mean(RT);
        if isfield(data,'beta')
            BETA = data.beta(ix);
            beta_data(s,c) = mean(data.beta(ix));
        end
        R_data(s,c) = mutual_information(state, action ,0.1);
        V_data(s,c) = mean(reward);
        R_data_lb(s,c) = mutual_information(state(1:10), action(1:10) ,0.1);


        win = 30; % groups of 30 trials
        for q = 1:length(state)-win
            R_data_mov(s,q,c) = mutual_information(state(q:q+win-1), action(q:q+win-1),0.1);
            V_data_mov(s,q,c) = mean(reward(q:q+win-1));
            rt_mov(s,q,c) = mean(RT(q:q+win-1));
            if isfield(data,'beta')
                beta_mov(s,q,c) = mean(BETA(q:q+win-1));
            end
        end

        for i = 1:max(action)
            pa_data(c,i,s) = sum(action==i);
        end

        for i = 1:max(state)
            ps(i) = sum(state==i);
        end
        ps = ps./sum(ps);

        for i = 1:max(state)
            for j = 1:3
                pas(i,j) = sum(state==i & action==j);
            end
        end

        pas = pas./nansum(pas,2);
        PAS(:,:,s,c) = pas;

        % stochasticity
        stochasticity(s,c) = -ps*nansum(pas.*log2(pas),2);

        % suboptimal actions
        temp = (pas).*sub{c};
        suboptimal(s,:,c) = nanmean(temp,2)';

        % action bias pref
        if ~isempty(pref)
            temp = (pas).*pref{c};
            for st = 1:3
                temp_pref(st,:) = temp(st,~isnan(temp(st,:)));
            end
            a1_pref(:,:,s,c) = temp_pref;
        end


    end % condition
    if isfield(data,'gab')
        gab(:,:,s) = data.gab;
        sab(:,:,s) = data.sab;
    end
end % subject
R_data_mov(R_data_mov<0.01) = NaN;
V_data_mov(V_data_mov<0.01) = NaN;
rt_mov(rt_mov<0.01) = NaN;
if isfield(data,'beta')
    beta_mov(beta_mov<0.01) = NaN;
end

pa_data =  pa_data./sum(pa_data,2);
lb = max(R_data,[],2);
%save(['lb_exp' num2str(eix) '.mat'],'lb')

switch plt
    case 'main'
        %% main plots
        % reward complexity curve
        figure; nexttile; hold on; colororder(cmap(1:length(Q),:))
        plot(R',V');
        plot(R_data,V_data,'.','MarkerSize',20)
        for i = 1:length(Q)
            plot(mean(R_data(:,i)),mean(V_data(:,i)),'o','MarkerSize',20,'MarkerFaceColor',cmap(i,:),'MarkerEdgeColor','k')
        end
        if contains(fig,'task1')
            xlim([0 1]); ylim([0.2 0.8])
        elseif contains(fig,'task2')
            xlim([0 1]); ylim([0.2 1])
        else
            xlim([0 1]); ylim([0 1])
        end
        legend(Q_labels(1:length(Q)), 'location','Southeast')
        ylabel('Average reward')
        xlabel('Policy complexity')

        % avg complexity
        nexttile; hold on;colororder(cmap(1:length(Q),:));
        b = barwitherr(sem(R_data,1),mean(R_data));
        ylabel('Policy complexity'); set(gca,'XTick',[]);
        xticks([b.XEndPoints]); xticklabels(Q_labels)
        ylim([0 0.5])
        [h,p,ci,stats] = ttest(R_data(:,1),R_data(:,2));
        disp(['Policy complexity: t('  num2str(stats.df) ')=' num2str(stats.tstat) ', p=' num2str(p)])
        cd = mean(R_data(:,1)-R_data(:,2))/std(R_data(:,1)-R_data(:,2));
        disp(['Cohens d:', num2str(cd)])

        % avg reward
        nexttile; hold on;
        b = barwitherr(sem(V_data,1),mean(V_data));
        ylabel('Average reward'); set(gca,'XTick',[]);
        xticks([b.XEndPoints]); xticklabels(Q_labels)
        if contains(fig,'task1')
            ylim([0.3 0.6])
        else
            ylim([0.5 1])
        end
        [h,p,ci,stats] = ttest(V_data(:,1),V_data(:,2));
        disp(['Average reward: t('  num2str(stats.df) ')=' num2str(stats.tstat) ', p=' num2str(p)])
        cd = mean(V_data(:,1)-V_data(:,2))/std(V_data(:,1)-V_data(:,2));
        disp(['Cohens d:', num2str(cd)])

        % stochasticity
        nexttile; hold on;
        b = barwitherr(sem(stochasticity,1),mean(stochasticity));
        ylabel('Stochasticity H(A|S)'); set(gca,'XTick',[]);
        xticks([b.XEndPoints]); xticklabels(Q_labels)
        ylim([0.5 2])
        [h,p,ci,stats] = ttest(stochasticity(:,1),stochasticity(:,2));
        disp(['Stochasticity: t('  num2str(stats.df) ')=' num2str(stats.tstat) ', p=' num2str(p)])
        cd = mean(stochasticity(:,1)-stochasticity(:,2))/std(stochasticity(:,1)-stochasticity(:,2));
        disp(['Cohens d:', num2str(cd)])


        % RT
        nexttile; hold on; colororder(cmap(1:length(Q),:))
        barwitherr(sem(rt,1),mean(rt))
        ylabel('RT (ms)'); set(gca,'XTick',[])
        xticks([b.XEndPoints]); xticklabels(Q_labels); ylim([200 800]);
        [h,p,ci,stats] = ttest(rt(:,1),rt(:,2));
        disp(['RT: t('  num2str(stats.df) ')=' num2str(stats.tstat) ', p=' num2str(p)])
        cd = nanmean(rt(:,1)-rt(:,2))/std(rt(:,1)-rt(:,2));
        disp(['Cohens d:', num2str(cd)])

        % beta vs policy complexity
        %         nexttile; hold on; colororder(cmap(1:length(Q),:))
        %         plot(R',beta)
        %         m = mean(R_data);
        %         for c = 1:length(Q)
        %             ix = find(R(c,:)>=m(c),1); % find closest theoretical complexity value match
        %             if isempty(ix)
        %                 plot(R(c,end),30,'.','MarkerSize',40)
        %             else
        %                 plot(m(c),beta(ix),'.','MarkerSize',40)
        %             end
        %         end
        %         if isfield(data,'beta')
        %             for c = 1:length(Q)
        %                 plot(nanmean(R_data(:,c))',nanmean(beta_data(:,c))','o','MarkerSize',20)
        %             end
        %         end
        %         ylabel('\beta'); xlabel('Policy complexity')
        %         ylim([0 10]);

        sgtitle('Data','FontSize',25)
        set(gcf, 'Position',  [0, 100, 1300, 250])



    case 'suboptimal'
        figure; hold on;
        % suboptimal actions
        nexttile; hold on; colororder(cmap2)
        for s = 1:max(state)
            b = barwitherr(squeeze(sem(suboptimal(:,s,:),1))',s,squeeze(nanmean(suboptimal(:,s,:)))');
            b(1).FaceColor = cmap2(s,:); b(1).EdgeColor = [1 1 1]; b(1).LineWidth = 0.01;
            b(2).FaceColor = [1 1 1]; b(2).EdgeColor = cmap2(s,:); b(2).LineWidth = 4; hold on;
        end
        legend(Q_labels(1:length(Q)),'box','off');
        xticks(1:3); xticklabels({'S_1','S_2','S_3'});
        ylim([0 0.5])
        ylabel('p(suboptimal action)');

        nexttile; hold on; colororder(cmap2)
        barwitherr(sem(suboptimal(:,:,2)-suboptimal(:,:,1),1),mean(suboptimal(:,:,2)-suboptimal(:,:,1)));
        ylabel('\Delta p(a)');box off;
        title('Q2-Q1');
        xticks([]); %xticklabels({'S_1','S_2','S_3'});
        ylim([-0.2 0.2])
        set(gcf, 'Position',  [0, 400, 700, 250])

        % stats & effect size
        for s = 1:3
            disp(['State ' num2str(s)])
            [h,p,ci,stats] = ttest(suboptimal(:,s,2),suboptimal(:,s,1));
            disp(['\Delta P(A): t('  num2str(stats.df) ')=' num2str(stats.tstat) ', p=' num2str(p)])
            cd = mean(suboptimal(:,s,2)-suboptimal(:,s,1))/std(suboptimal(:,s,2)-suboptimal(:,s,1));
            disp(['Cohens d:' num2str(cd)])
        end

        results.bias = suboptimal(:,:,2)-suboptimal(:,:,1);

    case 'action_biases'
        % action biases
        %if ~isempty(pref)
        for c = 1:length(Q)
            nexttile; hold on;
            for s = 1:3
                b = barwitherr(sem(a1_pref(s,:,:,c),3),s,mean(a1_pref(s,:,:,c),3));
                if c==1
                    b(1).EdgeColor = [1 1 1]; b(1).FaceColor = cmap2(s,:); b(1).LineWidth = 0.1;
                    b(2).EdgeColor = [1 1 1]; b(2).FaceColor = cmap2(s,:); b(2).LineWidth = 0.1;
                else
                    b(1).FaceColor = [1 1 1]; b(1).EdgeColor = cmap2(s,:); b(1).LineWidth = 3;
                    b(2).FaceColor = [1 1 1]; b(2).EdgeColor = cmap2(s,:); b(2).LineWidth = 3;
                end
                hold on;
            end
            if contains(fig,'task2')
                ylim([0 0.75])
            else
                ylim([0 0.5])
            end
            ylabel('P(a)');
            title(['Q' num2str(c)],'Color',cmap(c,:));set(gca,'XColor',cmap(c,:)-0.1);set(gca,'YColor',cmap(c,:)-0.1)
            xticks(1:3); xticklabels({'S_1','S_2','S_3'});
            legend({'a_{1}','a_{2}'},'box','off');
        end

        % t stats & effect size
        for s = 1:3
            disp(['State ' num2str(s)])
            [h,p,ci,stats] = ttest(squeeze(a1_pref(s,1,:,2)),squeeze(a1_pref(s,2,:,2)));
            disp(['\Delta P(A): t('  num2str(stats.df) ')=' num2str(stats.tstat) ', p=' num2str(p)])

            cd = mean(squeeze(a1_pref(s,1,:,2))-squeeze(a1_pref(s,2,:,2)))/std(squeeze(a1_pref(s,1,:,2))-squeeze(a1_pref(s,2,:,2)));
            disp(['Cohens d:' num2str(cd)])
            results.bias(:,s) = squeeze(a1_pref(s,1,:,2))-squeeze(a1_pref(s,2,:,2));
        end

        % Q2-Q1
        %         nexttile;
        %         for s = 1:3
        %             b = barwitherr(sem(a1_pref(s,:,:,2)-a1_pref(s,:,:,1),3),s,mean(a1_pref(s,:,:,2)-a1_pref(s,:,:,1),3));
        %             b(1).EdgeColor = [1 1 1]; b(1).FaceColor = cmap2(s,:); b(1).LineWidth = 0.1;
        %             b(2).EdgeColor = [1 1 1]; b(2).FaceColor = cmap2(s,:); b(2).LineWidth = 0.1;
        %             hold on; box off;
        %         end
        %         ylabel('p(a)');
        %         title('Q2-Q1');
        %         xticks(1:3); xticklabels({'S_1','S_2','S_3'});
        %         if contains(fig,'task2')
        %             ylim([-0.25 0.6])
        %         else
        %             ylim([-0.2 0.2])
        %         end
        % cohen's d (for each state)
        for s = 1:3
            temp = squeeze(a1_pref(s,:,:,2)-a1_pref(s,:,:,1))';
            d(s) = mean(temp(:,1)-temp(:,2))./std(temp(:,1)-temp(:,2));
        end
        %disp(['Cohens d for Q2-Q1:', num2str(d)])
        set(gcf, 'Position',  [0, 100, 600, 250])


    case 'dynamic'
        figure; hold on;
        nexttile; hold on; colororder(cmap(1:length(Q),:))
        for c = 1:length(Q)
            x = nanmean(R_data_mov(:,:,c)); y = nanmean(V_data_mov(:,:,c));
            x = x(x>0); y = y(y>0);
            plot(x,y,'-o')
            pt(1) = plot(x(1),y(1),'k.','MarkerSize',30);
            pt(2) = plot(x(end),y(end),'ko','MarkerSize',9,'MarkerFaceColor',[1 1 1]);
        end
        plot(R',V')
        legend(pt,{'Start','End'},'Location','SouthEast');
        ylabel('Average reward'); xlabel('Policy complexity');
        if task == 1
            axis([0 1 0.4 0.8])
        elseif task==2
            axis([0 1 0 1])
        elseif task==3
            axis([0 0.65 0 1])
        end

        nexttile; hold on
        for c = 1:length(Q)
            shadedErrorBar([],nanmean(R_data_mov(:,:,c)),sem(R_data_mov(:,:,c),1),{'Color',cmap(c,:)},1)
        end
        ylabel('Policy complexity'); xlabel('Trials');
        if task == 1
            axis([0 120 0.15 0.5])
        elseif task==2
            axis([0 60 0.15 0.5])
        elseif task==3
            axis([0 60 0.15 0.5])
        end

        nexttile; hold on
        for c = 1:length(Q)c
            shadedErrorBar([],nanmean(V_data_mov(:,:,c)),sem(V_data_mov(:,:,c),1),{'Color',cmap(c,:)},1)
        end
        ylabel('Average reward'); xlabel('Trials');
        if task == 1
            axis([0 120 0.4 0.65])
        elseif task==2
            axis([0 60 0.5 1])
        elseif task==3
            axis([0 60 0.55 0.8])
        end

        % RT dynamic
        nexttile; hold on; colororder(cmap(1:length(Q),:))
        for c = 1:length(Q)
            shadedErrorBar([],nanmean(rt_mov(:,:,c)),sem(rt_mov(:,:,c),1),{'Color',cmap(c,:)},1)
        end
        ylabel('RT (ms)'); xlabel('Trials'); axis tight;
        if task == 1
            axis([0 120 400 650])
        elseif task==2
            axis([0 60 300 650])
        elseif task==3
            axis([0 60 250 650])
        end
        %         % RT vs complexity
        %         nexttile; hold on; colororder(cmap(1:length(Q),:))
        %         for c = 1:length(Q)
        %             x = nanmean(R_data_mov(:,:,c)); y = nanmean(rt_mov(:,:,c));
        %             x = x(x>0); y = y(y>0);
        %             plot(x,y,'-o')
        %             pt(1) = plot(x(1),y(1),'k.','MarkerSize',30);
        %             pt(2) = plot(x(end),y(end),'ko','MarkerSize',9,'MarkerFaceColor',[1 1 1]);
        %         end
        %         ylabel('RT (ms)'); xlabel('Policy complexity');
        %         if eix == 1
        %             axis([0.15 0.5 400 650])
        %         elseif eix==2
        %             axis([0.15 0.5 300 650])
        %         elseif eix==3
        %             axis([0.15 0.5 250 650])
        %         end

        % RT vs complexity (mean)
        nexttile; hold on; colororder(cmap(1:length(Q),:))
        for c = 1:length(Q)
            plot(R_data(:,c),rt(:,c),'.','MarkerSize',20);
            [r,p]= corr(R_data(:,c),rt(:,c));
            disp(['Q' num2str(c) ' Pearsons correlation, r=' num2str(r) ', p='  num2str(p)])
        end
        lsline
        ylabel('RT (ms)'); xlabel('Policy complexity');
        if task == 1
            axis([0 log(3) 0 1500])
        elseif task==2
            axis([0 log(3) 0 1500])
        elseif task==3
            axis([0 log(3) 0 1500])
        end

        sgtitle(fig,'FontSize',25)
        set(gcf, 'Position',  [200, 100, 1300, 250])
        pause(1)

    case 'beta'
        figure; hold on
        for c = 1:length(Q)
            shadedErrorBar([],nanmean(beta_mov(:,:,c)),sem(beta_mov(:,:,c),1),{'Color',cmap(c,:)},1)
        end
        ylabel('Estimated \beta'); xlabel('Trials');ylim([0 max(mean(beta_data))+10])


    case 'stats'
        %% statistical tests
        % do complexity and reward change between conditions within a task?
        figure; hold on; nexttile; hold on;colororder(cmap(1:length(Q),:));
        b = barwitherr(sem(R_data,1),mean(R_data));
        scatterbar(b,R_data,true);
        [h,p,ci,stats] = ttest(R_data(:,1)-R_data(:,2));
        disp(['Is the policy complexity difference between Q1 and Q2 significant?', num2str(h)])
        disp(['p-value:', num2str(p)])
        ylabel('policy complexity'); set(gca,'XTick',[]); ylim([0 1])
        xticks([b.XEndPoints]); xticklabels(Q_labels)

        nexttile; hold on;colororder(cmap(1:length(Q),:));
        b = barwitherr(sem(V_data,1),mean(V_data));
        scatterbar(b,V_data,true);
        [h,p,ci,stats] = ttest(V_data(:,1)-V_data(:,2));
        disp(['Is the average reward difference between Q1 and Q2 significant?', num2str(h)])
        disp(['p-value:', num2str(p)])
        ylabel('average reward'); set(gca,'XTick',[]); ylim([0 1])
        xticks([b.XEndPoints]); xticklabels(Q_labels)
        set(gcf, 'Position',  [500, 750, 780, 220])
        sgtitle('All participants')

    case 'gab'
        figure;
        subplot 211
        h = heatmap({'a_1','a_2','a_3'},{'Q_1','Q_2'},nanmean(gab,3));
        title('General action bias (physical)')
        h.FontSize = 20;
        h.ColorbarVisible = false;
        subplot 212
        barwitherr(sem(gab,3),nanmean(gab,3)); box off
        legend('a_1','a_2','a_3'); ylabel('p(a)')
        temp = squeeze(mean(gab,1))';
        [h,p] = ttest(temp(:,1)-temp(:,2));
        [h,p] = ttest(temp(:,1)-temp(:,3));
        [h,p] = ttest(temp(:,2)-temp(:,3));

        % subplot 222
        % h = heatmap({'a_1','a_2','a_3'},{'Q_1','Q_2'},mean(sab,3));
        % title('Subjective action bias (remapped)')
        % h.FontSize = 20;
        % h.ColorbarVisible = false;
        % sgtitle(fig,'FontSize',25)
        % subplot 224
        % barwitherr(sem(sab,3),mean(sab,3)); box off
        % legend('a_1','a_2','a_3')

        set(gcf, 'Position',  [300, 300, 500, 600])
    case 'heatmap'
        figure;
        for c = 1:length(Q)
            subplot(1,3,c)
            h = heatmap({'a_1','a_2','a_3'},{'s_1','s_2','s_3'},squeeze(nanmean(PAS(:,:,:,c),3)) );
            title(['Q' num2str(c)])
            h.FontSize = 20;
            h.ColorbarVisible = false;
        end
        subplot 133
        h = heatmap({'a_1','a_2','a_3'},{'s_1','s_2','s_3'},squeeze(nanmean(PAS(:,:,:,2),3))-squeeze(nanmean(PAS(:,:,:,1),3)));
        h.FontSize = 20;
        h.ColorbarVisible = false;
        title(['Q2-Q1'])

        set(gcf, 'Position',  [300, 300, 1000, 300])
    case 'optimizers'
        if length(sidx)==length(DATA)
            % separate by aspiration optimizers
            diff_V = V_data(:,1)-V_data(:,2);
            idx_v = find(abs(diff_V) < 0.05);
            figure; hold on;
            nexttile; hold on;colororder(cmap(1:length(Q),:));
            b = barwitherr(sem(R_data(idx_v,:),1),mean(R_data(idx_v,:)));
            scatterbar(b,R_data(idx_v,:),true);
            [h,p] = ttest(R_data(idx_v,1)-R_data(idx_v,2));
            disp(['Is the policy complexity difference between Q1 and Q2 significant?', num2str(h)])
            disp(['p-value:', num2str(p)])
            ylabel('policy complexity'); set(gca,'XTick',[]); ylim([0 1])
            xticks([b.XEndPoints]); xticklabels(Q_labels)

            nexttile; hold on;colororder(cmap(1:length(Q),:));
            b = barwitherr(sem(V_data(idx_v,:),1),mean(V_data(idx_v,:)));
            scatterbar(b,V_data(idx_v,:),true);
            [h,p] = ttest(V_data(idx_v,1)-V_data(idx_v,2));
            disp(['Is the average reward difference between Q1 and Q2 significant?', num2str(h)])
            disp(['p-value:', num2str(p)])
            ylabel('average reward'); set(gca,'XTick',[]); ylim([0 1])
            xticks([b.XEndPoints]); xticklabels(Q_labels)
            sgtitle('Participants who optimize for value')
            set(gcf, 'Position',  [900, 450, 780, 220])

            % separate by capacity optimizers
            diff_R = R_data(:,1)-R_data(:,2);
            idx_c = find(abs(diff_R) < 0.05);
            figure; hold on;
            nexttile; hold on;colororder(cmap(1:length(Q),:));
            b = barwitherr(sem(R_data(idx_c,:),1),mean(R_data(idx_c,:)));
            scatterbar(b,R_data(idx_c,:),true);
            [h,p] = ttest(R_data(idx_c,1)-R_data(idx_c,2));
            disp(['Is the policy complexity difference between Q1 and Q2 significant?', num2str(h)])
            disp(['p-value:', num2str(p)])
            ylabel('policy complexity'); set(gca,'XTick',[]); ylim([0 1])
            xticks([b.XEndPoints]); xticklabels(Q_labels)

            nexttile; hold on;colororder(cmap(1:length(Q),:));
            b = barwitherr(sem(V_data(idx_c,:),1),mean(V_data(idx_c,:)));
            scatterbar(b,V_data(idx_c,:),true);
            [h,p] = ttest(V_data(idx_c,1)-V_data(idx_c,2));
            disp(['Is the average reward difference between Q1 and Q2 significant?', num2str(h)])
            disp(['p-value:', num2str(p)])
            ylabel('average reward'); set(gca,'XTick',[]); ylim([0 1])
            xticks([b.XEndPoints]); xticklabels(Q_labels)
            sgtitle('Participants who optimize for capacity')
            set(gcf, 'Position',  [100, 450, 780, 220])

            % are participants the same across exps? that optimize for capacity / value?
            disp(['Capacity optimizers:' num2str(idx_c')])
            disp(['Value optimizers:' num2str(idx_v')])
        end
        % is the polynomial fit different? empirical estimate of curves
        figure; hold on;
        results.bic = zeros(length(Q),2);
        results.aic = zeros(length(Q),2);
        for c = 1:length(Q)
            % independent model (curves / conditions are different)
            x = R_data(:,c);
            x = [ones(size(x)) x x.^2];
            y = V_data(:,c);
            n = length(y); k = size(x,2);
            [b,bint] = regress(y,x);
            results.bci_sep(c,:) = diff(bint,[],2)/2;
            results.b_sep(c,:) = b;
            mse = mean((y-x*b).^2);
            results.bic(c,1) = results.bic(c,1) + n*log(mse) + k*log(n);
            results.aic(c,1) = results.bic(c,1) + n*log(mse) + k*2;

            % joint model (curves / conditions are same)
            x = R_data(:);
            x = [ones(size(x)) x x.^2];
            y = V_data(:);
            n = length(y); k = size(x,2);
            [b,bint] = regress(y,x);
            results.bci_joint(c,:) = diff(bint,[],2)/2;
            results.b_joint(c,:) = b;
            mse = mean((y-x*b).^2);
            results.bic(c,2) = n*log(mse) + k*log(n);
            results.aic(c,2) = n*log(mse) + k*2;
        end
        nexttile; hold on; colororder(cmap(1:length(Q),:))
        m = results.b_sep;
        err = results.bci_sep;
        h = barerrorbar(m',err'); h(1).FaceColor = cmap(1,:); h(2).FaceColor = cmap(2,:);
        ylabel('Parameter value');
        xticks(h(1).XData)
        set(gca,'XTickLabel',{'\beta_0' '\beta_1' '\beta_2'},'YLim',[-3 3]);
        legend(Q_labels{1:length(Q)})

        nexttile; hold on;
        bar(results.bic(:,1)-results.bic(:,2),'FaceColor',[0 0 0]); % positive values favor joint model over independent
        xticks(1:length(Q)); xticklabels(Q_labels(1:length(Q)))
        ylabel('\Delta BIC');
        set(gcf, 'Position',  [500, 150, 780, 220])
        if results.bic(:,1)-results.bic(:,2)>0
            sgtitle('No difference between empirical curves')
        else
            sgtitle('**Significant difference between empirical curves**')
        end


        %% psychiatric data
    case 'psych'
        if isfield(DATA,'MDQ')
            figure; hold on;colororder(cmap)
            subplot 331; hold on;
            plot([DATA(sidx).MDQ]', R_data, '.','MarkerSize',20)
            lsline
            ylabel('Policy complexity')

            subplot 332; hold on;
            plot([DATA(sidx).BSDS]', R_data, '.','MarkerSize',20)
            lsline

            subplot 333; hold on;
            plot([DATA(sidx).POMS2A]', R_data, '.','MarkerSize',20)
            lsline;xlim([10 60])

            subplot 334; hold on;
            plot([DATA(sidx).MDQ]', V_data, '.','MarkerSize',20)
            lsline
            ylabel('Average reward')

            subplot 335; hold on;
            plot([DATA(sidx).BSDS]', V_data, '.','MarkerSize',20)
            lsline

            subplot 336; hold on;
            plot([DATA(sidx).POMS2A]', V_data, '.','MarkerSize',20)
            lsline; xlim([10 60])

            subplot 337; hold on;
            plot([DATA(sidx).MDQ]', log(rt), '.','MarkerSize',20)
            lsline
            ylabel('Response time (log ms)')
            xlabel('Mood Diagnostic Questionnaire')

            subplot 338; hold on;
            plot([DATA(sidx).BSDS]', log(rt), '.','MarkerSize',20)
            lsline
            xlabel('Bipolar Spectrum Diagnostic Scale')

            subplot 339; hold on;
            plot([DATA(sidx).POMS2A]', log(rt), '.','MarkerSize',20)
            lsline; xlim([10 60])
            xlabel('Profile of Mood States')


            [r,p] = corr([DATA(sidx).MDQ]', R_data); if p<0.05; disp(p); end
            [r,p] = corr([DATA(sidx).BSDS]', R_data); if p<0.05; disp(p); end
            [r,p] = corr([DATA(sidx).POMS2A]', R_data); if p<0.05; disp(p); end

            [r,p] = corr([DATA(sidx).MDQ]', V_data); if p<0.05; disp(p); end
            [r,p] = corr([DATA(sidx).BSDS]', V_data); if p<0.05; disp(p); end
            [r,p] = corr([DATA(sidx).POMS2A]', V_data); if p<0.05; disp(p); end

            [r,p] = corr([DATA(sidx).MDQ]', log(rt)); if p<0.05; disp(p); end
            [r,p] = corr([DATA(sidx).BSDS]', log(rt)); if p<0.05; disp(p); end
            [r,p] = corr([DATA(sidx).POMS2A]', log(rt)); if p<0.05; disp(p); end

            set(gcf, 'Position',  [200, 100, 1000, 700])
            sgtitle(fig,'FontSize',25)
        end
end % switch plt

%% save data
results.R_data = R_data;
results.V_data = V_data;
results.R_data_max = max(max(R_data_mov,[],2),[],3);
results.stochasticity = stochasticity;
results.suboptimal = suboptimal;
end


