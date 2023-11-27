function plot_sim(fig,opt,sim,bh)
% plot model simulations (manual simulations, blahut-arimoto estimates, NOT
% fitted parameters)
%
% opt is whether you are optimizing 1:capacity 2:aspiration or 3: value max
% sim is whether you are simulating data too

if nargin <2; opt = 1; end % capacity is default
if nargin <3; sim = 0; end
if nargin <4; bh = false; end

nSubj = 100;
cmap = brewermap(3,'Set1');
policy_update = {'capacity','value','capacityvalue','value_percent','complexity_gradient','value_gradient'};
pu = policy_update{opt};
opt_labels = {'Optimize capacity','Optimize aspiration','Optimize value percent'};

beta = linspace(0.01,30,70);
Q_labels = {'Q1','Q2','Q3'};

%% TO-DO %%
% Make input choice to plot simulations with if statement
% Set the C and V level in inputs

clear R V
switch fig
    case 'exp1'
        ps = ones(1,3)/3;
        Q = {[0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8];    % 1 optimal action per state
            [0.8 0.8 0.2;0.2 0.8 0.8;0.8 0.2 0.8];     % 2 optimal actions per state
            [0.6 0.6 0;0 0.6 0.6;0.6 0 0.6]};          % 2 optimal actions per state

        sub = {[NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN]};


        Q = {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]
            [1 1 0;0 1 1;1 0 1]};
        sub = {[NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN]};

        pref = {[NaN NaN NaN; 1 NaN 1; 1 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN]};

        agent.C = 0.5;
        agent.V = 0.9;
    case 'exp2'
        ps = ones(1,3)/3;
        Q = {[0.75 0 1;1 0.75 0;0 1 0.75];        % each state has its own suboptimal action (and optimal action)
            [0.75 0 1;1 0.75 0;0.75 1 0]};        % 2 states with the same suboptimal action (each state has own optimal action)

        %Q = {[0.6 0 1;1 0.6 0;0 1 0.6];          % each state has its own suboptimal action (and optimal action)
        %   [0.6 0 1;1 0.6 0;0.6 1 0]};           % 2 states with the same suboptimal action (each state has own optimal action)

        sub = {[1 NaN NaN; NaN 1 NaN; NaN NaN 1];
            [1 NaN NaN; NaN 1 NaN; 1 NaN NaN]};

        Q = {[0.6 0.1 0;0 0.6 0.1;0.1 0 0.6];        % each state has its own optimal action
            [0.6 0.1 0;0.6 0 0.1;0.1 0 0.6]};         % 2 states with same optimal action
        sub = { [NaN 1 NaN; NaN NaN 1; 1 NaN NaN];
            [NaN 1 NaN; NaN NaN 1; 1 NaN NaN]};
        Q = {[1 0.5 0;0 1 0.5;0.5 0 1];         % each state has its own optimal action
            [1 0.5 0;1 0 0.5;0.5 0 1]};         % 2 states with same optimal action
        sub = { [NaN 1 NaN; NaN NaN 1; 1 NaN NaN];
            [NaN 1 NaN; NaN NaN 1; 1 NaN NaN]};
        % pilot 1
        %Q = {[0.7 0 0.8;0.7 0.8 0;0.7 0.8 0];           % a1 suboptimal for 3 states
        %           [0.5 0 1;1 0.5 0;0 1 0.5]};          % each state has its own suboptimal action
        %       sub = { [1 NaN NaN; NaN 1 NaN; NaN NaN 1];
        %           [NaN 1 NaN; NaN 1 NaN; NaN NaN 1]};

        agent.C = 0.4;
        agent.V = 0.85;
    case 'exp3' % cancel this one
        ps = ones(1,3)/3;
        %Q = {[0.9 0.1 0;0 0.9 0.1;0.1 0 0.9];  % each state has its own optimal action
        %    [0.9 0.1 0;0.9 0 0.1;0.1 0 0.9]};  % 2 states with same optimal action
        %sub = {[NaN NaN NaN;NaN NaN NaN;1 NaN NaN];
        %    [NaN NaN NaN;NaN NaN NaN; 1 NaN NaN]};

        Q = {[1 0.5 0;0 1 0.5;0.5 0 1];        % each state has its own optimal action
            [1 0.5 0;1 0 0.5;0.5 0 1]'% 2 states with same optimal action
            [1 0.5 0;1 0 0.5;1 0 0.5]};      % 3 states with same optimal action
        sub = { [NaN 1 NaN; NaN NaN 1; 1 NaN NaN];
            [NaN 1 NaN; NaN NaN 1; 1 NaN NaN];
            [NaN 1 NaN; NaN NaN 1; NaN NaN 1]};

        agent.C = 0.5;
        agent.V = 0.6;

    case 'exp4'
        ps = ones(1,3)/3;
        Q = {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]        % 1 optimal action per state
            [1 1 0;0 1 1;1 0 1]};                   % 2 optimal actions per state
        sub = {[NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN]};

        agent.C = 0.1;
        agent.V = 0.85;

        %         Q = {[0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8];    % 1 optimal action per state
        %             [0.8 0.8 0.2;0.2 0.8 0.8;0.8 0.2 0.8];     % 2 optimal actions per state
        %             [0.6 0.6 0;0 0.6 0.6;0.6 0 0.6]};          % 2 optimal actions per state
        %         sub = {[NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
        %             [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
        %             [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN]};

end

for i = 1:length(Q)
    [R_temp,V_temp,pa_temp] = blahut_arimoto(ps,Q{i},beta); % R = policy complexity, V = average reward
    R(i,:) = interp1(beta,R_temp,linspace(0,30,100));
    V(i,:) = interp1(beta,V_temp,linspace(0,30,100));
    pa(:,:,i) = interp1(beta,pa_temp,linspace(0,30,100));

    if ~isempty(find(diff(R(i,:))<1e-3))
        x = find(diff(R(i,:))<1e-3);
        R(i,x) = linspace(R(i,end),log(3),length(x));
        V(i,x) = max(Q{i}(:));
        if opt == 1
            agent.betastar(i) = beta(find(R(i,:)>=agent.C,1));
        elseif opt == 2
            agent.betastar(i) = beta(find(V(i,:)>=agent.V,1));
        end
    end
end


beta = linspace(0,30,100);
% process model simulation
if sim == 1
    figure; nexttile; hold on; colororder(cmap(1:length(Q),:))
    plot(R',V');
    ylabel('Average reward')
    xlabel('Policy complexity')

    s = 1:size(Q{1},1); s = repmat(s,1,30);
    s_all = []; cond = [];
    for i = 1:length(Q)
        s_all = [s_all s(randperm(length(s)))];
        cond = [cond i*ones(1,length(s))];

    end


    for i = 1:length(s_all)
        data.Q(:,:,i) = Q{cond(i)};
    end


    data.s = s_all;
    data.cond = cond;

    for s = 1:nSubj
        simdata(s) = sim_bandits(data,pu,agent);  %'value_percent' 'complexity_limit'
    end


    for s = 1:nSubj
        for c = 1:length(Q)
            ix = find(simdata(s).cond==c);
            if bh
                ix = ix(end-19:end);
            end
            state = simdata(s).s(ix);
            action = simdata(s).a(ix);
            reward = simdata(s).r(ix);
            rt(s,c) = mean(simdata(s).rt(ix));
            sim_beta(s,c) = mean(simdata(s).beta(ix));
            R_data(s,c) = mutual_information(state,action,0.1);
            V_data(s,c) = mean(reward);

            for i = 1:max(state)
                ps(i)= sum(state==i);
            end
            ps = ps./sum(ps);
            for i = 1:max(state)
                for j = 1:max(action)
                    pas(i,j) = sum(action(state==i)==j);
                end
            end
            pas = pas./sum(pas,2);

            stochasticity(s,c) = -ps*nansum(pas.*log2(pas),2);
            temp = pas.*sub{c};
            suboptimal(s,c) = nanmean(temp(:));

        end
    end
    hold on; colororder(cmap(1:length(Q),:)); plot(R_data,V_data,'.','MarkerSize',20)
    for i = 1:length(Q)
        plot(mean(R_data(:,i)),mean(V_data(:,i)),'o','MarkerSize',20,'MarkerFaceColor',cmap(i,:),'MarkerEdgeColor','k')
    end
    ylim([0 1]); xlim([0 1.2])
    legend(Q_labels(1:length(Q)), 'location','Southeast')

    % avg complexity
    nexttile; hold on;colororder(cmap(1:length(Q),:));
    b = barwitherr(sem(R_data,1),mean(R_data));
    ylabel('policy complexity'); set(gca,'XTick',[]); ylim([0 1])
    xticks([b.XEndPoints]); xticklabels(Q_labels)

    % avg reward
    nexttile; hold on;
    b = barwitherr(sem(V_data,1),mean(V_data));
    ylabel('average reward'); set(gca,'XTick',[]); ylim([0 1])
    xticks([b.XEndPoints]); xticklabels(Q_labels)

    % stochasticity
    nexttile; hold on;
    barwitherr(sem(stochasticity,1),mean(stochasticity))
    ylabel('stochasticity H(A|S)'); set(gca,'XTick',[]); ylim([0 2])
    xticks([b.XEndPoints]); xticklabels(Q_labels)

    % suboptimal actions
    nexttile; hold on; colororder(cmap(1:length(Q),:))
    barwitherr(sem(suboptimal,1),mean(suboptimal))
    ylabel('p(suboptimal actions)'); set(gca,'XTick',[])
    xticks([b.XEndPoints]); xticklabels(Q_labels); ylim([0 0.5])

    % RT
    nexttile; hold on; colororder(cmap(1:length(Q),:))
    barwitherr(sem(rt,1),mean(rt))
    ylabel('RT (ms)'); set(gca,'XTick',[])
    xticks([b.XEndPoints]); xticklabels(Q_labels); ylim([0 1000])

    % beta vs policy complexity
    nexttile; hold on;
    plot(R',beta)
    m = mean(R_data);
    for c = 1:length(Q)
        ix = find(R(c,:)>=m(c),1); % find closest theoretical complexity value match
        if isempty(ix)
            ix = length(R);
        end
        plot(R(c,ix),beta(ix),'.','MarkerSize',40)
    end
    ylabel('\beta'); xlabel('policy complexity')
    ylim([0 10]);

    set(gcf, 'Position',  [0, 100, 1500, 250])

    mean(sim_beta)
end
sgtitle(opt_labels{opt},'FontSize',25)

% no simulation
clear b stochasticity
for c = 1:length(Q)
    if opt == 1
        idx(c) = find(R(c,:)>agent.C,1);
        b(c) = beta(idx(c)); % find the beta that corresponds with a capacity limit C
        complex(c) = R(c,idx(c));
    elseif opt == 2
        %if V(c,find(R(c,:)>C,1))<A % if aspiration level is larger than the value at which max capacity can earn
        %    A = V(c,find(R(c,:)>C,1));
        %    idx(c) = find(V(c,:)>=A,1);
        %else
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
    d = b(c)*Q{c} + log(pa(idx(c),:,c));
    logpolicy = d - logsumexp(d,2);
    policy = exp(logpolicy);    % softmax policy
    policy = policy./sum(policy,2);
    exprew(c) = ps*sum(policy.*Q{c},2);

    % calculate RT
    rt(c) = 200+1160*abs(complex(c));

    % calculate the choice stochasticity (entropy of optimal policy) H(A|S)
    stochasticity(c) = -ps*nansum(policy.*log2(policy),2);

    % avg probability of choosing suboptimal actions under the optimal policy
    temp = policy.*sub{c};
    p_suboptimal(c) = nanmean(temp(:));
end

figure; hold on; nexttile; hold on; colororder(cmap(1:length(Q),:));
plot(R',V')
for c = 1:length(Q)
    plot(R(c,idx(c)),V(c,idx(c)),'.','MarkerSize',40)
end
ylabel('Average reward'); xlabel('Policy complexity');
legend(Q_labels)
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

% suboptimal actions
nexttile; hold on; colororder(cmap(1:length(Q),:))
for c = 1:length(Q); bar(c,p_suboptimal(c)); end
ylim([0 0.5])
ylabel('p(suboptimal actions)');
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

end