function plot_sim(fig,plt,model,agent,learning)
% plot model simulations (manual simulations, blahut-arimoto estimates, NOT
% fitted parameters) for UNEQUAL STATE DISTRIBUTIONS

% model = 'capacity','value','vanilla'

if nargin <2; model = 'capacity'; end % capacity is default

nSubj = 100;
cmap = brewermap(3,'Set1'); cmap2 = brewermap(3,'Set2');
labels = {'Policy compression','XX','Standard RL & RLWM'};
beta = [0:0.4:5 6 7 8 10 20];
Q_labels = {'Q1','Q2','Q3'};

clear R V

switch fig
    case 'task1' % changing state distributions
        Ps(1,:) = ones(1,3)/3;
        Ps(2,:) = [0.6 0.2 0.2];

        Q = {[0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8]
            [0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8]};
        sub = {[NaN 1 1; 1 NaN 1 ; 1 1 NaN];
            [NaN 1 1; 1 NaN 1 ; 1 1 NaN]};
        pref = {[NaN 1 1; 1 NaN 1; 1 1 NaN];
            [NaN 1 1; 1 NaN 1; 1 1 NaN]};

    case 'task2' % states with >1 optimal action
        %Ps(1,:) = ones(1,3)/3;
        %Ps(2,:) = ones(1,3)/3;
        Q = {[1 0.33 0.33;0.33 1 0.33;0.33 0.33 1]
            [1 0 0;1 1 0;1 0 1]};

        sub = {[NaN 1 1; 1 NaN 1 ; 1 1 NaN];
            [NaN 1 1; NaN NaN 1; NaN 1 NaN]};
        pref = {[NaN 1 1; 1 NaN 1; 1 1 NaN];
            [NaN 1 1; 1 1 NaN; 1 NaN 1]};

        Ps{1} = ones(1,3)/3;
        Ps{2} = ones(1,6)/6;
         Q = {[1 0 0;1 1 0;1 0 1]
            [1 0 0;1 1 0;1 0 1;1 0 0;1 1 0;1 0 1]};
         sub = {[NaN 1 1; NaN NaN 1; NaN 1 NaN];
            [NaN 1 1; NaN NaN 1; NaN 1 NaN; NaN 1 1; NaN NaN 1; NaN 1 NaN]};
        pref = {[NaN 1 1; 1 1 NaN; 1 NaN 1];
            [NaN 1 1; 1 1 NaN; 1 NaN 1;NaN 1 1; 1 1 NaN; 1 NaN 1]};

    case 'task3' % time pressure
        Ps(1,:) = ones(1,3)/3;
        Ps(2,:) = ones(1,3)/3;
        Q = {[1 0.5 0;1 0.5 0;0.5 0 1]
            [1 0.5 0;1 0.5 0;0.5 0 1]};

        sub = {[NaN 1 NaN; NaN 1 NaN; 1 NaN NaN];
            [NaN 1 NaN; NaN 1 NaN; 1 NaN NaN]};
        pref = [];


    case 'test' % test
        Ps{1} = ones(1,3)/3;
        Ps{2} = ones(1,3)/3;
        Q = {[1 0 0;0 1 0;0 0 1]
            [1 0 0;1 0 0;1 0 0]};

        %sub = {[NaN 1 NaN; NaN 1 NaN; 1 NaN NaN];
        %    [NaN 1 NaN; NaN 1 NaN; 1 NaN NaN]};
        %pref = [];
end

beta_temp = linspace(0.01,30,100);
for c = 1:length(Q)
    %if model > 2 
    %    [R_temp,V_temp,pa_temp] = blahut_arimoto(Ps{1},Q{c},beta); % R = policy complexity, V = average reward
    %else
        [R_temp,V_temp,pa_temp] = blahut_arimoto(Ps{c},Q{c},beta); % R = policy complexity, V = average reward
    %end
    R(c,:) = interp1(beta,R_temp,linspace(0,30,100));
    V(c,:) = interp1(beta,V_temp,linspace(0,30,100));
    pa(:,:,c) = interp1(beta,pa_temp,linspace(0,30,100));

    if ~isempty(find(diff(R(c,:))<1e-3))
        x = find(diff(R(c,:))<1e-3);
        R(c,x) = linspace(R(c,end),log(3),length(x));
        V(c,x) = max(Q{c}(:));
        if model == 1 || model == 3
            agent.betastar(c) = beta_temp(find(R(c,:)>=agent.C(c),1));
        elseif model == 2
            agent.betastar(c) = beta_temp(find(V(c,:)>=agent.V,1));
        end
    end
end

beta = beta_temp;

% predicted dependant variables
clear b stochasticity
for c = 1:length(Q)
    if model == 1 || model == 3
        idx(c) = find(R(c,:)>agent.C(c),1);
        b(c) = beta(idx(c)); % find the beta that corresponds with a capacity limit C
        complex(c) = R(c,idx(c));
    elseif model == 2
        if V(c,end)<agent.V
            idx(c) = length(V(c,:));
        else
            idx(c) = find(V(c,:)>=agent.V,1);
        end
        b(c) = beta(idx(c)); % find the beta that corresponds with an aspiration level R
        complex(c) = R(c,idx(c));
    end
    b = [3 3];

    % construct the optimal policy for each condition
    if model < 3
        d = b(c)*(Q{c}*learning) + log(pa(idx(c),:,c))*learning;
    elseif model == 4
        d = 50*(Q{c}*learning);
    elseif model == 3
        d = b(c)*(Q{c}*learning);
    end
    logpolicy = d - logsumexp(d,2);
    policy = exp(logpolicy);
    policy = policy./sum(policy,2);
    exprew(c) = Ps{c}*sum(policy.*Q{c},2);

    %PAS(:,:,c) = policy;

    % calculate RT
    if model == 3
        rt(c) = 200+1160*mean(complex);
    else
        rt(c) = 200+1160*abs(complex(c));
    end

    % calculate the choice stochasticity (entropy of optimal policy)
    stochasticity(c) = -Ps{c}*nansum(policy.*log2(policy),2);

    % avg probability of choosing suboptimal actions under the optimal policy
    temp = (policy).*sub{c};%./pa(idx(c),:,c)
    %p_suboptimal(:,:,c) = nanmean(temp,2)';
    p_suboptimal(:,:,c) = nanmean(temp(:))

    % action bias pref
    if ~isempty(pref)
        temp = (policy).*pref{c};
        for s = 1:3
            a1_pref(s,:,c) = temp(s,~isnan(temp(s,:)));
        end
    end
end

switch plt
    case 'heatmap'
        % heatmap of condition
        figure; hold on;
        for c = 1:length(Q)
            subplot(1,2,c)
            h = heatmap({'a_1','a_2','a_3'},{'s_1','s_2','s_3'},Q{c});
            title(['Q' num2str(c)])
            h.FontSize = 20;
            h.ColorbarVisible = false;
        end
        set(gcf, 'Position',  [300, 300, 700, 300])

        % heatmap of policy
        % figure;
        % for c = 1:length(Q)
        %     subplot(1,2,c)
        %     h = heatmap({'a_1','a_2','a_3'},{'s_1','s_2','s_3'},PAS(:,:,c));
        %     title(['Q' num2str(c)])
        %     h.FontSize = 20;
        %     h.ColorbarVisible = false;
        % end
        % set(gcf, 'Position',  [300, 300, 700, 300])

    case 'main' % basic measures
        figure; hold on; nexttile; hold on; colororder(cmap(1:length(Q),:));

        plot(R',V')
        for c = 1:length(Q)
            plot(R(c,idx(c)),V(c,idx(c)),'.','MarkerSize',40)
        end
        ylabel('Average reward'); xlabel('Policy complexity');
        legend(Q_labels(1:length(Q)), 'location','Southeast')
        if contains(fig,'task1')
            xlim([0 1]); ylim([0.2 0.8])
        elseif contains(fig,'task2')
            xlim([0 1]); ylim([0.2 1])
        else
            xlim([0 1]); ylim([0 1])
        end

        % avg complexity
        nexttile; hold on;
        colororder(cmap(1:length(Q),:));
        for c = 1:length(Q); bar(c,complex(c)); end
        if contains(fig,'task1')
            ylim([0 0.5])
        else
            ylim([0 1])
        end
        ylabel('Policy complexity');
        xticks(1:length(Q));xticklabels(Q_labels)

        % avg reward
        nexttile; hold on;
        for c = 1:length(Q); bar(c,exprew(c)); end
        if contains(fig,'task1')
            ylim([0.3 0.6])
        else
            ylim([0.5 1])
        end
        ylabel('Average reward');
        xticks(1:length(Q));xticklabels(Q_labels)

        % stochasticity
        nexttile; hold on;
        for c = 1:length(Q); bar(c,stochasticity(c)); end
        ylim([0.5 2])
        ylabel('Stochasticity H(A|S)');
        xticks(1:length(Q));xticklabels(Q_labels)

        % RT
        nexttile; hold on; colororder(cmap(1:length(Q),:))
        for c = 1:length(Q); bar(c,rt(c)); end
        ylabel('RT (ms)'); set(gca,'XTick',[])
        xticks(1:length(Q));xticklabels(Q_labels); ylim([200 800])

        % beta & policy complexity
        %         nexttile; hold on;
        %         plot(R',beta)
        %         for c = 1:length(Q)
        %             plot(R(c,idx(c)),b(c),'.','MarkerSize',40)
        %         end
        %         ylabel('\beta'); xlabel('Policy complexity')
        %         ylim([0 10])
        sgtitle(labels{model},'FontSize',25)

        set(gcf, 'Position',  [10, 400, 1300, 250])

    case 'suboptimal'
        % suboptimal actions
        %figure; hold on;
        nexttile; hold on; colororder(cmap2)
        for s = 1:3
            hold on;
            b = bar(s,squeeze(p_suboptimal(:,s,:)));
            b(1).FaceColor = cmap2(s,:); b(1).EdgeColor = [1 1 1]; b(1).LineWidth = 0.01;
            b(2).FaceColor = [1 1 1]; b(2).EdgeColor = cmap2(s,:); b(2).LineWidth = 4; hold on;
        end

        legend(Q_labels(1:length(Q)),'box','off');
        xticks(1:3); xticklabels({'S_1','S_2','S_3'});
        ylim([0 0.5]);
        ylabel('p(suboptimal action)');

        nexttile; hold on;
        for s = 1:3
            hold on;
            b = bar(s,squeeze(p_suboptimal(:,s,2) - p_suboptimal(:,s,1)));
            b(1).FaceColor = cmap2(s,:); b(1).EdgeColor = [0.5 0.5 0.5]; b(1).LineWidth = 0.01; hold on;
        end
        xticks(1:3); xticklabels({'S_1','S_2','S_3'});

        ylim([-0.2 0.2])

        title('Q2-Q1');
        ylabel('\Delta p(a)');

        set(gcf, 'Position',  [0, 400, 700, 250])


    case 'action_biases'
        %figure; hold on;
        if ~isempty(pref)
            % action biases
            for c = 1:length(Q)
                nexttile; hold on; colororder(cmap2)
                for s = 1:3
                    b = bar(s,a1_pref(s,:,c));
                    if c==1
                        b(1).EdgeColor = [1 1 1]; b(1).FaceColor = cmap2(s,:); b(1).LineWidth = 0.1;
                        b(2).EdgeColor = [1 1 1]; b(2).FaceColor = cmap2(s,:); b(2).LineWidth = 0.1;
                    else
                        b(1).FaceColor = [1 1 1]; b(1).EdgeColor = cmap2(s,:); b(1).LineWidth = 3;
                        b(2).FaceColor = [1 1 1]; b(2).EdgeColor = cmap2(s,:); b(2).LineWidth = 3;
                    end

                end
                if contains(fig,'task2')
                    ylim([0 0.75])
                else
                    ylim([0 0.5])
                end
                ylabel('P(a)');
                title(['Q' num2str(c)],'Color',cmap(c,:));set(gca,'XColor',cmap(c,:)-0.1);set(gca,'YColor',cmap(c,:)-0.1)
                xticks(1:3); xticklabels({'S_1','S_2','S_3'});
            end


            %             nexttile;
            %             for s = 1:3
            %                 b = bar(s,a1_pref(s,:,2)-a1_pref(s,:,1));
            %                 b(1).EdgeColor = [1 1 1]; b(1).FaceColor = cmap2(s,:); b(1).LineWidth = 0.1;
            %                 b(2).EdgeColor = [1 1 1]; b(2).FaceColor = cmap2(s,:); b(2).LineWidth = 0.1;
            %                 hold on; box off;
            %             end
            %             ylabel('p(a)');
            %             title('Q2-Q1');
            %             xticks(1:3); xticklabels({'S_1','S_2','S_3'});
            %             if contains(fig,'task2')
            %                 ylim([-0.25 0.6])
            %             else
            %                 ylim([-0.2 0.2])
            %             end

            set(gcf, 'Position',  [0, 500, 1500, 250])
        else

            set(gcf, 'Position',  [0, 500, 600, 250])
        end
        %sgtitle(labels{model},'FontSize',25)

end % end plt

% heatmap of policy
% figure;
% for c = 1:length(Q)
%     subplot(1,2,c)
%     h = heatmap({'a_1','a_2','a_3'},{'s_1','s_2','s_3'},PAS(:,:,c));
%     title(['Q' num2str(c)])
%     h.FontSize = 20;
%     h.ColorbarVisible = false;
% end
% set(gcf, 'Position',  [300, 300, 700, 300])

% if ~isempty(pref)
%     % action biases plotted a different way
%     for s = 1:3
%
%         for c = 1:length(Q)
%         nexttile; hold on;
%
%             b = bar(s,squeeze(a1_pref(s,1,:)));
%             b = bar(s,squeeze(a1_pref(s,2,:)));
%             b(1).FaceColor = [1 1 1]; b(1).EdgeColor = cmap2(s,:); b(1).LineWidth = 3;
%             b(2).FaceColor = [1 1 1]; b(2).EdgeColor = cmap2(s,:); b(2).LineWidth = 3;
%             %hatchfill2(b(1),'single','HatchAngle',0,'hatchcolor', cmap2(s,:));
%             %hatchfill2(b(2),'cross','HatchAngle',-45,'hatchcolor',cmap2(s,:));
%         end
%         ylim([0 0.7])
%         ylabel('p(a)');
%         title(['Q' num2str(c)],'Color',cmap(c,:));set(gca,'XColor',cmap(c,:)-0.1);set(gca,'YColor',cmap(c,:)-0.1)
%         xticks(1:3); xticklabels({'S_1','S_2','S_3'});
%
%     end
%     set(gcf, 'Position',  [0, 0+opt*100, 1000, 250])
% else
%
%     set(gcf, 'Position',  [0, 0+opt*100, 300, 250])
% end
% sgtitle(opt_labels{opt},'FontSize',25)

end