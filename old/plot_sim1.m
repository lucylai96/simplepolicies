function plot_sim2(fig,opt,sim,bh)
% plot model simulations (manual simulations, blahut-arimoto estimates, NOT
% fitted parameters) for UNEQUAL STATE DISTRIBUTIONS
%
% opt is whether you are optimizing 1:capacity 2:aspiration or 3: value max
% sim is whether you are simulating data too

if nargin <2; opt = 1; end % capacity is default
if nargin <3; sim = 0; end
if nargin <4; bh = false; end

nSubj = 100;
cmap = brewermap(3,'Set1'); cmap2 = brewermap(3,'Set2');
policy_update = {'capacity','value','capacityvalue','value_percent','complexity_gradient','value_gradient'};
pu = policy_update{opt};
opt_labels = {'Optimize capacity','Optimize aspiration','Optimize value percent'};

beta = linspace(0.01,30,10);
Q_labels = {'Q1','Q2','Q3'};

%% TO-DO %%
% Make input choice to plot simulations with if statement
% Set the C and V level in inputs

clear R V

agent.C = [0.35 0.35];
agent.V = 0.98;

switch fig
    case 'exp1' % states with >1 optimal action
        Ps(1,:) = ones(1,3)/3;
        Ps(2,:) = ones(1,3)/3;
        Q = {[1 0.3333 0.3333;0.3333 1 0.3333;0.3333 0.3333 1]        % 1 optimal action per state
            [1 0 0;1 1 0;1 0 1]};                   % 2 optimal actions per state

        %Q = {[0.9 0.3 0.3;0.3 0.9 0.3;0.3 0.3 0.9]        % 1 optimal action per state
        %    [0.9 0 0;0.9 0.9 0;0.9 0 0.9]};                   % 2 optimal actions per state
        sub = {[NaN 1 1; 1 NaN 1 ; 1 1 NaN];
            [NaN 1 1; NaN NaN 1; NaN 1 NaN]};
        pref = {[NaN 1 1; 1 NaN 1; 1 1 NaN];
            [NaN 1 1; 1 1 NaN; 1 NaN 1]};
        agent.C = [0.25 0.25];

    case 'exp2' % states share optimal actions
        Ps(1,:) = ones(1,3)/3;
        Ps(2,:) = ones(1,3)/3;
        %Q = {[1 0.5 0;0 1 0.5;0.5 0 1];         % each state has its own optimal action
        %    [1 0.5 0;1 0.5 0;0.5 0 1]};         % 2 states with same optimal action
        Q = {[1 0.7 0;0 1 0.7;0.7 0 1];         % each state has its own optimal action
            [1 0.7 0;1 0.7 0;0.7 0 1]};         % 2 states with same optimal action
        %Q = {[1 0.3 0;0 1 0.3;0.3 0 1];         % each state has its own optimal action
        %   [1 0.3 0;1 0.3 0;0.3 0 1]};         % 2 states with same optimal action

        sub = { [NaN 1 NaN; NaN NaN 1; 1 NaN NaN];
            [NaN 1 NaN; NaN 1 NaN; 1 NaN NaN]};
        pref = [];

    case 'exp3' % time pressure
        Ps(1,:) = ones(1,3)/3;
        Ps(2,:) = ones(1,3)/3;
        Q = {[1 0.5 0;1 0.5 0;0.5 0 1]        % 2 states with same optimal action
            [1 0.5 0;1 0.5 0;0.5 0 1]};       % 2 states with same optimal action
        %Q = {[1 0.7 0;1 0.7 0;0.7 0 1]        % 2 states with same optimal action
        %    [1 0.7 0;1 0.7 0;0.7 0 1]};       % 2 states with same optimal action
        sub = {[NaN 1 NaN; NaN 1 NaN; 1 NaN NaN];
            [NaN 1 NaN; NaN 1 NaN; 1 NaN NaN]};
        %pref = {[1 1 NaN; 1 1 NaN; 1 NaN 1];
        %    [1 1 NaN; 1 1 NaN; 1 NaN 1]};
        pref = [];
        agent.C = [0.3 0.15];

        %pilot4
        Q = {[1 0.7 0;1 0.7 0;0.7 0 1]        % 2 states with same optimal action
            [1 0.7 0;1 0.7 0;0.7 0 1]};       % 2 states with same optimal action
        %Q = {[1 0.5 0;1 0 0.5;0.5 0 1]        % 2 states with same optimal action
        %    [1 0.5 0;1 0 0.5;0.5 0 1]};       % 2 states with same optimal action

        sub = {[NaN 1 NaN; NaN 1 NaN; 1 NaN NaN];
            [NaN 1 NaN; NaN 1 NaN; 1 NaN NaN]};

        pref = [];

    case 'exp4' % changing state distributions
        Ps(1,:) = ones(1,3)/3;
        Ps(2,:) = [0.6 0.2 0.2];
        Q = {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]        % 1 optimal action per state
            [1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]};       % 1 optimal action per state
        % Q = {[1 0 0; 0.25 0.5 0.25;0.25 0.25 0.5];
        %    [1 0 0; 0.25 0.5 0.25;0.25 0.25 0.5]};         % this one is better for the big p(s) exp, same for the other exp
      
       Q = {[1 0.3 0.3;0.3 1 0.3;0.3 0.3 1]        % 1 optimal action per state
            [1 0.3 0.3;0.3 1 0.3;0.3 0.3 1]};       % 1 optimal action per state
        
        %Q = {[1 0.7 0.7;0.7 1 0.7;0.7 0.7 1]        % 1 optimal action per state
        %    [1 0.7 0.7;0.7 1 0.7;0.7 0.7 1]};       % 1 optimal action per state
        sub = {[NaN 1 1; 1 NaN 1 ; 1 1 NaN];
            [NaN 1 1; 1 NaN 1 ; 1 1 NaN]};
        pref = {[NaN 1 1; 1 NaN 1; 1 1 NaN];
            [NaN 1 1; 1 NaN 1; 1 1 NaN]};
agent.V = 0.9;
end

beta_temp = linspace(0.01,30,100);
for c = 1:length(Q)
    [R_temp,V_temp,pa_temp] = blahut_arimoto(Ps(c,:),Q{c},beta); % R = policy complexity, V = average reward
    R(c,:) = interp1(beta,R_temp,linspace(0,30,100));
    V(c,:) = interp1(beta,V_temp,linspace(0,30,100));
    pa(:,:,c) = interp1(beta,pa_temp,linspace(0,30,100));

    if ~isempty(find(diff(R(c,:))<1e-3))
        x = find(diff(R(c,:))<1e-3);
        R(c,x) = linspace(R(c,end),log(3),length(x));
        V(c,x) = max(Q{c}(:));
        if opt == 1
            agent.betastar(c) = beta_temp(find(R(c,:)>=agent.C(c),1));
        elseif opt == 2
            agent.betastar(c) = beta_temp(find(V(c,:)>=agent.V,1));
        end
    end
end

beta = beta_temp;
%% no simulation -  cost model
clear b stochasticity
for c = 1:length(Q)
    if opt == 1
        idx(c) = find(R(c,:)>agent.C(c),1);
        b(c) = beta(idx(c)); % find the beta that corresponds with a capacity limit C
        complex(c) = R(c,idx(c));
    elseif opt == 2
        if V(c,end)<agent.V
            idx(c) = length(V(c,:));
        else
            idx(c) = find(V(c,:)>=agent.V,1);
        end
        b(c) = beta(idx(c)); % find the beta that corresponds with an aspiration level R
        complex(c) = R(c,idx(c));

    end
    % construct the optimal policy for each condition
    d = b(c)*(Q{c}*0.5) + log(pa(idx(c),:,c))*0.5;
    logpolicy = d - logsumexp(d,2);
    policy = exp(logpolicy);    % softmax policy
    policy = policy./sum(policy,2);
    exprew(c) = Ps(c,:)*sum(policy.*Q{c},2);

    PAS(:,:,c) = policy;

    % calculate RT
    rt(c) = 200+1160*abs(complex(c));

    % calculate the choice stochasticity (entropy of optimal policy) H(A|S)
    stochasticity(c) = -Ps(c,:)*nansum(policy.*log2(policy),2);

    % avg probability of choosing suboptimal actions under the optimal policy
    temp = policy.*sub{c};
    p_suboptimal(:,:,c) = nanmean(temp,2)';

    % action bias pref
    if ~isempty(pref)
        temp = policy.*pref{c};
        for s = 1:3
            a1_pref(s,:,c) = temp(s,~isnan(temp(s,:)));
        end
    end
end

figure; hold on; nexttile; hold on; colororder(cmap(1:length(Q),:));
plot(R',V')
for c = 1:length(Q)
    plot(R(c,idx(c)),V(c,idx(c)),'.','MarkerSize',40)
end
ylabel('Average reward'); xlabel('Policy complexity');
legend(Q_labels(1:length(Q)), 'location','Southeast')
xlim([0 1]); ylim([0 1])

% avg complexity
nexttile; hold on;
colororder(cmap(1:length(Q),:));
for c = 1:length(Q); bar(c,complex(c)); end
ylim([0 1])
ylabel('policy complexity');
xticks(1:length(Q));xticklabels(Q_labels)

% avg reward
nexttile; hold on;
for c = 1:length(Q); bar(c,exprew(c)); end
ylim([0.5 1])
ylabel('average reward');
xticks(1:length(Q));xticklabels(Q_labels)

% stochasticity
nexttile; hold on;
for c = 1:length(Q); bar(c,stochasticity(c)); end
ylim([0 2])
ylabel('stochasticity H(A|S)');
xticks(1:length(Q));xticklabels(Q_labels)

% RT
nexttile; hold on; colororder(cmap(1:length(Q),:))
for c = 1:length(Q); bar(c,rt(c)); end
ylabel('RT (ms)'); set(gca,'XTick',[])
xticks(1:length(Q));xticklabels(Q_labels); ylim([0 1000])

% beta & policy complexity
nexttile; hold on;
plot(R',beta)
for c = 1:length(Q)
    plot(R(c,idx(c)),b(c),'.','MarkerSize',40)
end
ylabel('\beta'); xlabel('policy complexity')
ylim([0 10])
sgtitle(opt_labels{opt},'FontSize',25)

set(gcf, 'Position',  [0, 0+opt*100, 1500, 250])


figure;
for c = 1:length(Q)
    subplot(1,2,c)
    h = heatmap({'a_1','a_2','a_3'},{'s_1','s_2','s_3'},PAS(:,:,c));
    title(['Q' num2str(c)])
    h.FontSize = 20;
    h.ColorbarVisible = false;
end
set(gcf, 'Position',  [300, 300, 700, 300])

figure; hold on; colororder(cmap2)
% suboptimal actions
nexttile; hold on;
for s = 1:3
    hold on;
    b = bar(s,squeeze(p_suboptimal(:,s,:)));
    b(1).FaceColor = cmap2(s,:); b(1).EdgeColor = [1 1 1]; b(1).LineWidth = 0.01;
    b(2).FaceColor = [1 1 1]; b(2).EdgeColor = cmap2(s,:); b(2).LineWidth = 4; hold on;
end

legend(Q_labels(1:length(Q)),'box','off');
xticks(1:3); xticklabels({'S_1','S_2','S_3'});
ylim([0 0.7]);
ylabel('p(suboptimal action)');

nexttile; hold on;
for s = 1:3
    hold on;
    b = bar(s,squeeze(p_suboptimal(:,s,2) - p_suboptimal(:,s,1)));
    b(1).FaceColor = cmap2(s,:); b(1).EdgeColor = [0.5 0.5 0.5]; b(1).LineWidth = 0.01; hold on;
end
xticks(1:3); xticklabels({'S_1','S_2','S_3'});
ylim([-.25 0.25]);
    title('Q2-Q1');
ylabel('\Delta p(a)');

set(gcf, 'Position',  [0, 400, 700, 250])

if ~isempty(pref)
    % action biases
    for c = 1:length(Q)
        nexttile; hold on;
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
        ylim([0 0.7])
        ylabel('p(a)');
        title(['Q' num2str(c)],'Color',cmap(c,:));set(gca,'XColor',cmap(c,:)-0.1);set(gca,'YColor',cmap(c,:)-0.1)
        xticks(1:3); xticklabels({'S_1','S_2','S_3'});

    end

    nexttile;
    for s = 1:3
        b = bar(s,a1_pref(s,:,2)-a1_pref(s,:,1));
        b(1).EdgeColor = [1 1 1]; b(1).FaceColor = cmap2(s,:); b(1).LineWidth = 0.1;
        b(2).EdgeColor = [1 1 1]; b(2).FaceColor = cmap2(s,:); b(2).LineWidth = 0.1;
        hold on; box off;
    end
    ylabel('p(a)');
    title('Q2-Q1');
    xticks(1:3); xticklabels({'S_1','S_2','S_3'});
    ylim([-0.25 0.25])


    set(gcf, 'Position',  [0, 0+opt*100, 1000, 250])
else

    set(gcf, 'Position',  [0, 0+opt*100, 300, 250])
end
sgtitle(opt_labels{opt},'FontSize',25)


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


%% no simulation - vanilla softmax model
clear b stochasticity
for c = 1:length(Q)
    if opt == 1
        idx(c) = find(R(c,:)>agent.C(c),1);
        b(c) = beta(idx(c)); % find the beta that corresponds with a capacity limit C
        complex(c) = R(c,idx(c));
    elseif opt == 2
        if V(c,end)<agent.V
            idx(c) = length(V(c,:));
        else
            idx(c) = find(V(c,:)>=agent.V,1);
        end
        %end
        b(c) = beta(idx(c)); % find the beta that corresponds with an aspiration level R
        complex(c) = R(c,idx(c));
    elseif opt == 3
        idx(c) = find(V(c,:)>=agent.V*max(V(c,:)),1);
        b(c) = beta(idx(c)); % find the beta that corresponds with an aspiration level R
        complex(c) = R(c,idx(c));
    end
    % construct the optimal policy for each condition
    d = b(c)*Q{c}*0.5;
    logpolicy = d - logsumexp(d,2);
    policy = exp(logpolicy);    % softmax policy
    policy = policy./sum(policy,2);
    exprew(c) = Ps(c,:)*sum(policy.*Q{c},2);

    % calculate RT
    rt(c) = 200+1160*mean(policy(:));

    % calculate the choice stochasticity (entropy of optimal policy) H(A|S)
    stochasticity(c) = -Ps(c,:)*nansum(policy.*log2(policy),2);

    % avg probability of choosing suboptimal actions under the optimal policy
    temp = policy.*sub{c};
    p_suboptimal(:,:,c) = nanmean(temp,2)';

    if ~isempty(pref)
        % action bias pref
        temp = policy.*pref{c};
        for s = 1:3
            a1_pref(s,:,c) = temp(s,~isnan(temp(s,:)));
        end
    end
end

figure; hold on; nexttile; hold on; colororder(cmap(1:length(Q),:));
plot(R',V')
for c = 1:length(Q)
    plot(R(c,idx(c)),V(c,idx(c)),'.','MarkerSize',40)
end
ylabel('Average reward'); xlabel('Policy complexity');
legend(Q_labels(1:length(Q)), 'location','Southeast')
xlim([0 1]); ylim([0 1])

% avg complexity
nexttile; hold on;
colororder(cmap(1:length(Q),:));
for c = 1:length(Q); bar(c,complex(c)); end
ylim([0 1])
ylabel('policy complexity');
xticks(1:length(Q));xticklabels(Q_labels)

% avg reward
nexttile; hold on;
for c = 1:length(Q); bar(c,exprew(c)); end
ylim([0 1])
ylabel('average reward');
xticks(1:length(Q));xticklabels(Q_labels)

% stochasticity
nexttile; hold on;
for c = 1:length(Q); bar(c,stochasticity(c)); end
ylim([0 2])
ylabel('stochasticity H(A|S)');
xticks(1:length(Q));xticklabels(Q_labels)

% RT
nexttile; hold on; colororder(cmap(1:length(Q),:))
for c = 1:length(Q); bar(c,rt(c)); end
ylabel('RT (ms)'); set(gca,'XTick',[])
xticks(1:length(Q));xticklabels(Q_labels); ylim([0 1000])

% beta & policy complexity
nexttile; hold on;
plot(R',beta)
for c = 1:length(Q)
    plot(R(c,idx(c)),b(c),'.','MarkerSize',40)
end
ylabel('\beta'); xlabel('policy complexity')
ylim([0 10])
sgtitle('Vanilla Softmax','FontSize',25)
set(gcf, 'Position',  [0, 0+opt*100, 1500, 250])


figure; hold on; colororder(cmap2)
% suboptimal actions
nexttile; hold on;
for s = 1:3
    hold on;
    b = bar(s,squeeze(p_suboptimal(:,s,:)));
    b(1).FaceColor = cmap2(s,:); b(1).EdgeColor = [1 1 1]; b(1).LineWidth = 0.01;
    b(2).FaceColor = [1 1 1]; b(2).EdgeColor = cmap2(s,:); b(2).LineWidth = 4; hold on;
end

legend(Q_labels(1:length(Q)),'box','off');
xticks(1:3); xticklabels({'S_1','S_2','S_3'});
ylim([0 0.7]);
ylabel('p(suboptimal action)');

nexttile; hold on;
for s = 1:3
    hold on;
    b = bar(s,squeeze(p_suboptimal(:,s,2) - p_suboptimal(:,s,1)));
    b(1).FaceColor = cmap2(s,:); b(1).EdgeColor = [0.5 0.5 0.5]; b(1).LineWidth = 0.01; hold on;
end
xticks(1:3); xticklabels({'S_1','S_2','S_3'});
ylim([-.25 0.25]);
    title('Q2-Q1');
ylabel('\Delta p(a)');
set(gcf, 'Position',  [0, 400, 700, 250])

if ~isempty(pref)
    % action biases
    for c = 1:length(Q)
        nexttile; hold on;
        for s = 1:3
            b = bar(s,a1_pref(s,:,c));
            if c==1
                b(1).EdgeColor = [1 1 1]; b(1).FaceColor = cmap2(s,:); b(1).LineWidth = 0.1;
                b(2).EdgeColor = [1 1 1]; b(2).FaceColor = cmap2(s,:); b(2).LineWidth = 0.1;
            else
                b(1).FaceColor = [1 1 1]; b(1).EdgeColor = cmap2(s,:); b(1).LineWidth = 3;
                b(2).FaceColor = [1 1 1]; b(2).EdgeColor = cmap2(s,:); b(2).LineWidth = 3;
            end
            %hatchfill2(b(1),'single','HatchAngle',0,'hatchcolor', cmap2(s,:));
            %hatchfill2(b(2),'cross','HatchAngle',-45,'hatchcolor',cmap2(s,:));
        end
        ylim([0 0.7])
        ylabel('p(a)');
        title(['Q' num2str(c)],'Color',cmap(c,:));set(gca,'XColor',cmap(c,:)-0.1);set(gca,'YColor',cmap(c,:)-0.1)
        xticks(1:3); xticklabels({'S_1','S_2','S_3'});

    end
    nexttile;
    for s = 1:3
        b = bar(s,a1_pref(s,:,2)-a1_pref(s,:,1));
        b(1).EdgeColor = [1 1 1]; b(1).FaceColor = cmap2(s,:); b(1).LineWidth = 0.1;
        b(2).EdgeColor = [1 1 1]; b(2).FaceColor = cmap2(s,:); b(2).LineWidth = 0.1;
        hold on; box off;
    end
    ylabel('p(a)');
    title('Q2-Q1');
    xticks(1:3); xticklabels({'S_1','S_2','S_3'});
    ylim([-0.25 0.25])

    set(gcf, 'Position',  [0, 0+opt*100, 1000, 250])
else

    set(gcf, 'Position',  [0, 0+opt*100, 300, 250])
end
sgtitle('Vanilla Softmax','FontSize',25)

end